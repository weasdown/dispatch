import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../domain/models/unit/unit.dart';
import '../../../data/repositories/unit/unit_repository.dart';
import '../../../utils/result.dart';

abstract class UnitCallback {
  UnitCallback();

  Future<Unit> call(BuildContext context);
}

class UnitCallsignCallback extends UnitCallback {
  UnitCallsignCallback(String callsign) : _callsign = callsign;

  final String _callsign;

  @override
  Future<Unit> call(BuildContext context) async {
    UnitRepository unitRepository = context.read<UnitRepository>();
    Result<List<Unit>> unitsResult = await unitRepository.allUnits;

    return switch (unitsResult) {
      Ok<List<Unit>>() =>
        unitsResult.value
            .where((Unit unit) => unit.callsign == _callsign)
            .first,
      Error<List<Unit>>() => Future.error(unitsResult.error),
    };
  }
}
