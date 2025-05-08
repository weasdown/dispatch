import 'package:flutter/material.dart';

import '../view_models/special_situation_viewmodel.dart';

class SpecialSituationButton extends StatelessWidget {
  const SpecialSituationButton({super.key, required this.viewModel});

  final SpecialSituationViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => viewModel.openDialog(context),
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Container(
          color: Colors.red,
          child: Text('SS', style: TextStyle(color: Colors.white)),
        ),
      ),
    );
  }
}
