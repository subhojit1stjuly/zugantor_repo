# AI Prompt Bar

> Feature: Natural language screen generation and modification · Zone: Top (full width, collapsible)

---

## Overview

The AI Prompt Bar lets users describe what they want in plain English and have the AI generate,
modify, or explain SDUI JSON. It is the primary interface for product managers and a productivity
tool for designers and developers.

---

## Layout

```
┌────────────────────────────────────────────────────────────────────────────┐
│  [✦ AI]  Describe what you want...                   [Generate]  [▾ hide] │
└────────────────────────────────────────────────────────────────────────────┘
```

- The bar spans the full width of the editor, above the three-column zone split.
- It is collapsible — clicking `[▾ hide]` collapses it to a single thin strip with an expand handle.
- Keyboard shortcut: `` Ctrl/Cmd+` `` toggles expand/collapse.

---

## Three Modes

The AI operates in one of three modes depending on context:

| Mode | When Active | What the AI Does |
|---|---|---|
| **Generate** | Nothing is selected on canvas | Generates a full screen layout from the prompt |
| **Modify** | A node is selected on canvas | Modifies the selected subtree based on the prompt |
| **Explain** | User clicks `[Explain selection]` | Explains what the selected JSON does in plain English |

The current mode is shown as a small chip next to the prompt input (e.g. `✦ Generate mode`).

---

## Generate Mode

**Trigger:** User types a prompt with nothing selected, then clicks `[Generate]` or presses `Enter`.

**Example prompts:**
- *"A profile screen with avatar, display name, bio, and a follow button"*
- *"Login form with email, password, forgot password link, and a primary action button"*

**Behaviour:**
1. Prompt is sent to the selected AI provider.
2. A loading spinner appears in the bar.
3. On success: the returned SDUI JSON replaces the current screen (with undo checkpoint).
4. Canvas and JSON editor update to reflect the new layout.
5. On failure: an inline error message is shown in the bar.

---

## Modify Mode

**Trigger:** A node is selected on canvas, user types a prompt, clicks `[Modify]` or presses `Enter`.

**Example prompts:**
- *"Make this column scrollable"*
- *"Add a divider between these two items"*
- *"Change the button style to outlined"*

**Behaviour:**
1. The current selected node's JSON subtree + the prompt are sent to the AI.
2. On success: the selected subtree is replaced with the AI-returned subtree.
3. The rest of the screen is untouched.
4. Undo checkpoint is created before the modification.

---

## Explain Mode

**Trigger:** User clicks `[Explain selection]` button (appears when a node is selected).

**Behaviour:**
1. The selected node's JSON subtree is sent to the AI with an explain instruction.
2. The AI's explanation is shown inline below the prompt bar in a read-only text block.
3. The explanation block can be dismissed with `[✕]`.

---

## AI Provider Configuration

- API key and provider are set in the **Settings** screen.
- Supported providers: **OpenAI** (GPT-4o), **Anthropic** (Claude 3.5 Sonnet).
- Keys are stored in platform secure storage (`flutter_secure_storage`).
- If no API key is configured, clicking the bar shows a message:
  > "Set up your AI API key in Settings to use this feature."
  > `[Go to Settings →]`

---

## System Prompt

The system prompt instructs the AI to:
- Return only valid SDUI JSON (no markdown fences, no commentary).
- Use only component types that exist in the ZDS registry.
- Always assign a unique `id` to every node.
- Follow the SDUI schema (version 1).

---

## Error Handling

| Error | User-visible message |
|---|---|
| Network error | "Couldn't reach the AI provider. Check your connection." |
| Invalid API key | "Your API key was rejected. Update it in Settings." |
| AI returned invalid JSON | "The AI response wasn't valid SDUI JSON. Try rephrasing your prompt." |
| Rate limit | "Rate limit reached. Please wait a moment and try again." |

---

## Prompt History

- The last 20 prompts are stored in local storage per project.
- Pressing the Up arrow in the prompt input cycles through recent prompts.
