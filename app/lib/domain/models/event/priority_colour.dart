/// Extension for defining each [Priority]'s colour.
///
/// Kept as a separate library to `priority.dart` so that file does not need to import `material.dart`.
library;

import 'package:dispatch/domain/models/event/priority.dart';
import 'package:flutter/material.dart';

extension PriorityColour on Priority {
  /// Defines the colour to be used for displaying events of this priority.
  Color get colour => switch (this) {
    Priority.zero => Color(0x009A019A),
    Priority.one => Color(0x00FE0000),
    Priority.two => Color(0x00FFC000),
    Priority.three => Color(0x0001B400),
    Priority.four => Color(0x00FF01FA),
    Priority.five => Color(0x00015A00),
    Priority.six => Color(0x00699DFF),
    Priority.seven => Color(0x001871FF),
    Priority.eight => Color(0x0000467A),
    Priority.nine => Color(0x00012060),
  };
}
