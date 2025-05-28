import 'package:flutter/material.dart';

Widget text(BuildContext context, String message) => Text(
  message,
  style: Theme.of(context).textTheme.headlineSmall,
  textAlign: TextAlign.center,
);
