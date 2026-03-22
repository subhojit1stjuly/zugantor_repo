# Security Requirements

## What This Document Covers

This document describes the security concerns that arise from the SDUI system on the frontend side — what the frontend does to protect itself, what it needs from the backend to do so effectively, and what decisions the architect needs to make.

---

## Why SDUI Introduces Security Considerations

In a traditional mobile app, the UI is compiled into the binary. A bad actor cannot change the layout of a screen without distributing a new binary — and that binary must pass app store review. SDUI changes this: the layout of a screen can change at runtime by serving a different template.

This introduces risks that a conventional app does not have:

- A tampered template could instruct the frontend to navigate to a malicious route
- A tampered template could display misleading UI (e.g. a fake "Transfer confirmed" message)
- A template could reference a component type that does not exist yet, potentially crashing or confusing the app
- A malicious URL in an `open_url` action could direct users to phishing sites

The frontend addresses these risks with validation, allowlists, and schema checks. But these client-side defenses are only effective if the backend provides trusted content. The architect needs to understand what the frontend's defenses are and what they depend on.

---

## What the Frontend Does on Its Own

The following protections are implemented on the frontend and do not require backend support:

### 1. Schema Validation

When the frontend receives a template, it validates it against the SDUI schema before persisting or rendering it. A template that does not match the expected structure is rejected. The frontend falls back to its hardcoded layout for that screen.

### 2. Component Registry Allowlist

The frontend only renders components whose `type` is in its local component registry. Unknown `type` values are replaced with a safe empty placeholder. This prevents a template from instructing the frontend to render something that was never built.

### 3. Route Allowlist for Navigate Actions

Before the frontend follows a `navigate` action from a template, it checks the target route against an internal allowlist of known routes. Routes not on the allowlist are silently blocked. The allowlist is compiled into the app binary and cannot be changed at runtime by a template.

### 4. Domain Allowlist for Open URL Actions

Before the frontend opens a URL from an `open_url` action, it checks the domain against a configured allowlist. URLs with domains not on the allowlist are silently blocked.

### 5. No Executable Content

The template format is a data structure, not code. There is no `eval`, no script tag, no dynamic dart loading, no function reference by name. The template cannot instruct the frontend to execute arbitrary code.

---

## What the Frontend Needs from the Backend

The frontend's schema and allowlist protections are effective against a *poorly crafted* template. They are not sufficient against a *deliberately forged and plausible* template — one that passes schema validation but presents misleading financial information.

For the SDUI system to be trustworthy, the frontend needs the backend to ensure:

### 1. Templates Are Delivered Over a Secure Channel

The frontend needs confidence that the template it receives has not been modified in transit. The transport mechanism should prevent interception and modification. How the architect achieves this (TLS, signed payloads, or both) is their decision.

### 2. Templates Are Tamper-Evident

The frontend needs a way to verify that a template file has not been modified after it was published. Without this, a third party who could intercept or modify the delivery channel could alter the template in flight.

The frontend can support a **template hash or signature verification** step: a trusted expected hash or signature for each template version is delivered separately from the template file itself (e.g. in the manifest), and the frontend checks the downloaded template against this value before persisting it. If the check fails, the template is discarded.

Whether and how to implement this (hash comparison, signature verification, or relying purely on transport-layer security) is the architect's decision.

### 3. Only Authorized Sources Can Publish Templates

The frontend cannot enforce this — it has no visibility into how templates are authored or published. However, the architect should ensure that the system for creating and publishing templates has proper access controls. A compromised template authoring tool is equivalent to a compromised app release.

### 4. Templates Do Not Contain Sensitive Data

Templates are cached on device and may be present in local storage after the app is closed. The template format is designed to be non-personalised (no user data), but the architect should verify that nothing in the template content — including metadata fields — contains values that would be sensitive if extracted from a device.

---

## Authentication for Template Requests

The architect needs to decide whether template requests require authentication. There are at least two reasonable approaches:

**Option A: Templates are unauthenticated**
Templates are not personalized. They are the same for all users (or all users in a segment). There is no secret in a template. They can be delivered without requiring the requester to prove who they are.

*Concern:* A bad actor could enumerate templates. Depending on the content, this may or may not matter.

**Option B: Templates require authentication**
The same credential used for data requests is required for template requests. This ensures only authenticated users can access templates.

*Concern:* Templates need to be accessible on the background sync at startup. If the user is not authenticated at startup (e.g. on first launch), this may block template pre-loading.

The architect should decide which approach fits the product's security posture.

---

## PII and Financial Data in Templates

Templates should not contain personally identifiable information (PII) or financial values. All user-specific values must flow through the data map and bind expressions, never be embedded in the template itself.

The frontend cannot enforce this — it renders whatever the template contains. The architect should ensure template authoring tooling or publishing pipelines validate that templates do not include hard-coded user-specific or sensitive data.

---

## Logging and Auditability

The frontend emits analytics events that include `template_version`, `experiment_id`, and `variant_id` from template metadata. These events can be used by the architect to audit which template versions are in use across the user population at any time.

The architect should maintain a server-side log of which template version was served to which user (or device) and when. This provides the ability to investigate incidents related to template content.

---

## Open Questions for the Architect

- What is the chosen mechanism for transport security for template delivery? Is TLS sufficient, or does the architect want signed templates?
- If template hashes or signatures are used: where is the expected hash delivered (manifest? separate endpoint?), and what signing key infrastructure exists?
- Is there a process for security review of templates before they are published? Since a template can instruct the app to navigate to routes and open URLs, the content is security-relevant.
- How will the architect handle the event of a compromised template being served? Is there a mechanism to rapidly push a replacement template to all devices (see [sync_requirements.md](sync_requirements.md) for the force-refresh open question)?
- Are there regulatory requirements (e.g. GDPR, PSD2, DORA) that affect what can or cannot be stored in a locally cached template file? The frontend's local template store would be in scope for any audit of on-device data.
- What is the incident response plan if a malicious template is distributed? The frontend's defenses (allowlists, schema validation) limit damage, but understanding what notifications or actions the backend can take will help define the full response capability.
