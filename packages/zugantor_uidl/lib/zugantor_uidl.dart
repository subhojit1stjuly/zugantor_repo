/// The Zugantor UIDL (UI Description Language) core library.
///
/// This library is the single source of truth for the UIDL data contract.
/// It is pure Dart with zero Flutter dependency and is consumed by:
/// - `zugantor_renderer` (UIDL → Flutter widgets)
/// - `zugantor_codegen`  (UIDL → Dart/Swift/Kotlin/TSX source)
/// - `zugantor_build`    (the visual builder app)
library zugantor_uidl;

export 'src/model/uidl_node.dart';
export 'src/model/screen_template.dart';
export 'src/model/design_tokens.dart';
export 'src/model/prop_definition.dart';
export 'src/model/component_definition.dart';
export 'src/registry/component_registry.dart';
export 'src/token/token_resolver.dart';
export 'src/token/token_ref.dart';
export 'src/validation/uidl_validator.dart';
export 'src/validation/validation_result.dart';
