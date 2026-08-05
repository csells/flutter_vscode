/// Deterministic Dart binding generation from a pinned VS Code API inventory.
library;

import 'dart:convert';

import 'package:crypto/crypto.dart';

import 'coverage_ledger.dart';
import 'ecmascript_whitespace.dart';
import 'ir_validator.dart';
import 'manifest_projection.dart';
import 'templates.dart';
import 'validators.dart';

export 'ir_validator.dart' show computeDeclarationFingerprint;

part 'generator/core.dart';
part 'generator/slice_validation.dart';
part 'generator/strategy_matching.dart';
part 'generator/type_predicates.dart';
part 'generator/override_review.dart';
