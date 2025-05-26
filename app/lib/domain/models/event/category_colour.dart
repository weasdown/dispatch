import 'package:dispatch/domain/models/event/category.dart';
import 'package:flutter/material.dart';

extension CategoryColour on Category {
  Color get colour => switch (this) {
    Category.one => Colors.purple,
    Category.two => Colors.red,
    Category.three => Colors.yellow,
    Category.four => Colors.green,
    Category.none => Colors.grey,
  };
}
