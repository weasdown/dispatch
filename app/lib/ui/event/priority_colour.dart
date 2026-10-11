/// Extension for defining each [Priority]'s colour.
///
/// Kept as a separate library to `priority.dart` so that file does not need to import `material.dart`.
library;

import 'package:dispatch/domain/models/event/priority.dart';
import 'package:flutter/material.dart';

extension PriorityColour on Priority {
  /// Defines the colour to be used for displaying events of this priority.
  Color get backgroundColour => switch (this) {
    Priority.zero => Color(0xFF9A019A),
    Priority.one => Color(0xFFFE0000),
    Priority.two => Color(0xFFFFC000),
    Priority.three => Color(0xFF01B400),
    Priority.four => Color(0xFFFF01FA),
    Priority.five => Color(0xFF015A00),
    Priority.six => Color(0xFF699DFF),
    Priority.seven => Color(0xFF1871FF),
    Priority.eight => Color(0xFF00467A),
    Priority.nine => Color(0xFF012060),
  };

  Color get textColour => switch (this) {
    Priority.zero => Colors.black,
    Priority.one => Colors.black,
    Priority.two => Colors.black,
    Priority.three => Colors.black,
    Priority.four => Colors.white,
    Priority.five => Colors.white,
    Priority.six => Colors.black,
    Priority.seven => Colors.black,
    Priority.eight => Colors.white,
    Priority.nine => Colors.white,
  };
}
