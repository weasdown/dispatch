import 'package:flutter/material.dart';

Widget text(BuildContext context, String message) => Text(
  message,
  style: Theme.of(context).textTheme.headlineSmall,
  textAlign: TextAlign.center,
);

Widget errorText(BuildContext context, AsyncSnapshot snapshot) =>
    text(context, 'Error!\n\n${snapshot.error.toString()}');
