import 'package:flutter/material.dart';

import '../../../domain/models/event/special_situation.dart';

class SpecialSituationViewModel {
  SpecialSituationViewModel(this.specialSituation);

  SpecialSituation specialSituation;

  void openDialog(BuildContext context) {
    showAdaptiveDialog(
      context: context,
      builder: (context) {
        return AlertDialog.adaptive(
          title: Text('Special Situation'),
          content: Text(specialSituation.description),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Ok'),
            ),
          ],
        );
      },
    );
  }
}
