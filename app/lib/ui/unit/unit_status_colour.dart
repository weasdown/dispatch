import 'package:flutter/material.dart';

import '../../domain/models/unit/unit_status.dart';

extension Colours on UnitStatus {
  Color get backgroundColour => switch (this) {
    UnitStatus.oneR => Color(0xFF14E6B4), // Estimated
    UnitStatus.ab => Color(0xFFFF6600),
    UnitStatus.af => Color(0xFF00CC00),
    UnitStatus.ah => Color(0xFFFF0000),
    UnitStatus.ak => Color(0xFFFF0000),
    UnitStatus.am => Color(0xFF00CC00),
    UnitStatus.as => Color(0xFFFF0000),
    UnitStatus.av => Color(0xFF00CC00),
    UnitStatus.dp => Color(0xFFFF0000),
    UnitStatus.ds => Color(0xFF00CC00),
    UnitStatus.ho => Color(0xFFFF0000),
    UnitStatus.ls => Color(0xFFFF0000),
    UnitStatus.mo => Color(0xFFFF3399),
    UnitStatus.ms => Color(0xFF00CC00),
    UnitStatus.nt => Color(0xFFFF0000),
    UnitStatus.os => Color(0xFF000000),
    UnitStatus.pd => Color(0xFF808080),
    UnitStatus.ra => Color(0xFF006600),
    UnitStatus.rt => Color(0xFF990000),
    UnitStatus.rv => Color(0xFFFF0000),
    UnitStatus.sb => Color(0xFF00CC00),
    UnitStatus.vc => Color(0xFF00CCFF),
    UnitStatus.wp => Color(0xFFFF0000),
  };

  Color get textColour => switch (this) {
    UnitStatus.oneR => Colors.black, // Estimated
    UnitStatus.ab => Colors.black,
    UnitStatus.af => Colors.white,
    UnitStatus.ah => Colors.black,
    UnitStatus.ak => Colors.black,
    UnitStatus.am => Colors.white,
    UnitStatus.as => Colors.black,
    UnitStatus.av => Colors.white,
    UnitStatus.dp => Color(0xFFBFBFBF),
    UnitStatus.ds => Color(0xFFD9D9D9),
    UnitStatus.ho => Colors.black,
    UnitStatus.ls => Colors.black,
    UnitStatus.mo => Colors.white,
    UnitStatus.ms => Colors.white,
    UnitStatus.nt => Colors.black,
    UnitStatus.os => Colors.white,
    UnitStatus.pd => Colors.white,
    UnitStatus.ra => Colors.white,
    UnitStatus.rt => Colors.white,
    UnitStatus.rv => Colors.black,
    UnitStatus.sb => Colors.black,
    UnitStatus.vc => Colors.black,
    UnitStatus.wp => Colors.black,
  };
}
