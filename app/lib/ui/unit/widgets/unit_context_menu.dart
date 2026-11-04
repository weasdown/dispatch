import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';
import 'package:material_ui/material_ui.dart';

import '../../../domain/models/unit/unit.dart';
import '../../../ui/map/view_models/map_view_model.dart';
import '../../../utils/result.dart';
import '../../events/view_models/all_events_view_model.dart';
import '../view_models/units_view_model.dart';

final class UnitContextMenuRegion extends StatelessWidget {
  const UnitContextMenuRegion({
    super.key,
    required this.unit,
    required this.controller,
    required this.child,
    required this._mapViewModel,
    required this.eventsViewModel,
    required this.unitsViewModel,
  });

  final Widget child;

  final ContextMenuController controller;

  final AllEventsViewModel eventsViewModel;

  /// Contains a [ContextMenuButtonItem] for actions on units.
  List<ContextMenuButtonItem> items(
    BuildContext context,
  ) => <ContextMenuButtonItem>[
    // Dispatch
    UnitContextMenuButtonItem(
      label: 'Dispatch ${unit.callsign}',
      onPressed: () async {
        _log.info('Dispatching ${unit.callsign} via context menu');
        final result = await _mapViewModel.dispatchUnit(unit);

        switch (result) {
          case Ok<void>():
            _log.info('Successfully dispatched ${unit.callsign}');
          case Error<void>():
            _log.severe('Failed to dispatch ${unit.callsign}: ${result.error}');
        }
      },
    ),
    // // Mobile
    // UnitContextMenuButtonItem(
    //   label: 'Mobile',
    //   onPressed: () {
    //     _log.info('Setting ${unit.callsign} as Mobile via context menu');
    //     singleEventScreenViewModel.dispatchUnit(unit);
    //   },
    // ),
    // // At Scene
    // UnitContextMenuButtonItem(
    //   label: 'At Scene',
    //   onPressed: () {
    //     _log.info('Setting ${unit.callsign} as At Scene via context menu');
    //     singleEventScreenViewModel.dispatchUnit(unit);
    //   },
    // ),
    // // With Patient
    // UnitContextMenuButtonItem(
    //   label: 'With Patient',
    //   onPressed: () {
    //     _log.info('Setting ${unit.callsign} as With Patient via context menu');
    //     throw UnimplementedError(); // TODO implement action
    //   },
    // ),
    // // At RV Point
    // UnitContextMenuButtonItem(
    //   label: 'At RV Point',
    //   onPressed: () {
    //     _log.info('Setting ${unit.callsign} as At RV Point via context menu');
    //     throw UnimplementedError(); // TODO implement action
    //   },
    // ),
    // // Request Transport
    // UnitContextMenuButtonItem(
    //   label: 'Request Transport',
    //   onPressed: () {
    //     _log.info(
    //       'Setting ${unit.callsign} as Request Transport via context menu',
    //     );
    //     throw UnimplementedError(); // TODO implement action
    //   },
    // ),
    // // No Transport Required
    // UnitContextMenuButtonItem(
    //   label: 'No Transport Required',
    //   onPressed: () {
    //     _log.info(
    //       'Setting ${unit.callsign} as No Transport Required via context menu',
    //     );
    //     throw UnimplementedError(); // TODO implement action
    //   },
    // ),
    // // Leaving Scene
    // UnitContextMenuButtonItem(
    //   label: 'Leaving Scene',
    //   onPressed: () {
    //     _log.info('Setting ${unit.callsign} as Leaving Scene via context menu');
    //     throw UnimplementedError(); // TODO implement action
    //   },
    // ),
    // // At Hospital
    // UnitContextMenuButtonItem(
    //   label: 'At Hospital',
    //   onPressed: () {
    //     _log.info('Setting ${unit.callsign} as At Hospital via context menu');
    //     throw UnimplementedError(); // TODO implement action
    //   },
    // ),
    // Clear Unit
    // UnitContextMenuButtonItem(
    //   label: 'Clear Unit',
    //   onPressed: () {
    //     _log.info('Clearing down ${unit.callsign} via context menu');
    //     throw UnimplementedError(); // TODO implement action
    //   },
    // ),
    // // TODO once UnitContextMenuButtonItem refactored for nesting (see TODO on its class), add nesting menu for Available statuses
    // // Available Returning
    // UnitContextMenuButtonItem(
    //   label: 'Available Returning',
    //   onPressed: () {
    //     _log.info(
    //       'Setting ${unit.callsign} as Available Returning via context menu',
    //     );
    //     throw UnimplementedError(); // TODO implement action
    //   },
    // ),
    // // Available Base
    // UnitContextMenuButtonItem(
    //   label: 'Available Base',
    //   onPressed: () {
    //     _log.info(
    //       'Setting ${unit.callsign} as Available Base via context menu',
    //     );
    //     throw UnimplementedError(); // TODO implement action
    //   },
    // ),
    // // Available Other
    // UnitContextMenuButtonItem(
    //   label: 'Available Other',
    //   onPressed: () {
    //     _log.info(
    //       'Setting ${unit.callsign} as Available Other via context menu',
    //     );
    //     throw UnimplementedError(); // TODO implement action
    //   },
    // ),
    // // Mobile to Standby
    // UnitContextMenuButtonItem(
    //   label: 'Mobile to Standby',
    //   onPressed: () {
    //     _log.info(
    //       'Setting ${unit.callsign} as Mobile to Standby via context menu',
    //     );
    //     throw UnimplementedError(); // TODO implement action
    //   },
    // ),
    // // Available Standby
    // UnitContextMenuButtonItem(
    //   label: 'Available Standby',
    //   onPressed: () {
    //     _log.info(
    //       'Setting ${unit.callsign} as Available Standby via context menu',
    //     );
    //     throw UnimplementedError(); // TODO implement action
    //   },
    // ),
    // // Available Voice
    // UnitContextMenuButtonItem(
    //   label: 'Available Voice',
    //   onPressed: () {
    //     _log.info(
    //       'Setting ${unit.callsign} as Available Voice via context menu',
    //     );
    //     throw UnimplementedError(); // TODO implement action
    //   },
    // ),
    // // Pre Duty
    // UnitContextMenuButtonItem(
    //   label: 'Pre Duty',
    //   onPressed: () {
    //     _log.info('Setting ${unit.callsign} as Pre Duty via context menu');
    //     throw UnimplementedError(); // TODO implement action
    //   },
    // ),
    // // Dispatch Assign
    // UnitContextMenuButtonItem(
    //   label: 'Dispatch Assign to ${unit.callsign}',
    //   onPressed: () {
    //     _log.info('Dispatch Assigning to ${unit.callsign} via context menu');
    //     throw UnimplementedError(); // TODO implement action
    //   },
    // ),
    //
    // UnitContextMenuButtonItem.spacer(),
    //
    // // Send MDT Message
    // UnitContextMenuButtonItem(
    //   label: 'Send Message to ${unit.callsign}',
    //   onPressed: () {
    //     _log.info('Sending message to ${unit.callsign} via context menu');
    //     throw UnimplementedError(); // TODO implement action
    //   },
    // ),

    UnitContextMenuButtonItem.spacer(),

    // Standdown unit
    UnitContextMenuButtonItem(
      label: 'Standdown ${unit.callsign}',
      onPressed: () async {
        _log.info('Standing down ${unit.callsign} via context menu');
        final result = await _mapViewModel.standdownUnit(unit);

        switch (result) {
          case Ok<void>():
            _log.info('Successfully stood down ${unit.callsign}');
          case Error<void>():
            _log.severe(
              'Failed to stand down ${unit.callsign}: ${result.error}',
            );
        }
      },
    ),

    // UnitContextMenuButtonItem.spacer(),
    //
    // // Out of Service
    // UnitContextMenuButtonItem(
    //   label: 'Out of Service',
    //   onPressed: () {
    //     _log.info('Putting ${unit.callsign} out of service via context menu');
    //     throw UnimplementedError(); // TODO implement action
    //   },
    // ),
    // // Into Service
    // UnitContextMenuButtonItem(
    //   label: 'Into Service',
    //   onPressed: () {
    //     _log.info(
    //       'Putting ${unit.callsign} back into service via context menu',
    //     );
    //     throw UnimplementedError(); // TODO implement action
    //   },
    // ),
    // // Create Running Call
    // UnitContextMenuButtonItem(
    //   label: 'Create Running Call',
    //   onPressed: () {
    //     _log.info(
    //       'Creating Running Call for ${unit.callsign} via context menu',
    //     );
    //     throw UnimplementedError(); // TODO implement action
    //   },
    // ),
    // // Window Unit...
    // UnitContextMenuButtonItem(
    //   label: 'Window Unit...',
    //   onPressed: () {
    //     _log.info('Windowing unit via context menu');
    //     throw UnimplementedError(); // TODO implement action
    //   },
    // ),
    // // Change Location
    // UnitContextMenuButtonItem(
    //   label: 'Change ${unit.callsign}\'s Location',
    //   onPressed: () {
    //     _log.info('Changing location for ${unit.callsign} via context menu');
    //     throw UnimplementedError(); // TODO implement action
    //   },
    // ),
    // // Relocate Unit
    // UnitContextMenuButtonItem(
    //   label: 'Relocate ${unit.callsign}',
    //   onPressed: () {
    //     _log.info('Relocating ${unit.callsign} via context menu');
    //     throw UnimplementedError(); // TODO implement action
    //   },
    // ),
    // // Transfer Unit
    // UnitContextMenuButtonItem(
    //   label: 'Transfer ${unit.callsign}',
    //   onPressed: () {
    //     _log.info('Transferring ${unit.callsign} via context menu');
    //     throw UnimplementedError(); // TODO implement action
    //   },
    // ),
    //
    // UnitContextMenuButtonItem.spacer(),
    //
    // // Put on Break
    // UnitContextMenuButtonItem(
    //   label: 'Put ${unit.callsign} on Break',
    //   onPressed: () {
    //     _log.info('Putting ${unit.callsign} on break via context menu');
    //     throw UnimplementedError(); // TODO implement action
    //   },
    // ),
    // // Disturb Break
    // UnitContextMenuButtonItem(
    //   label: 'Disturb ${unit.callsign}\'s Break',
    //   onPressed: () {
    //     _log.info('Disturbing ${unit.callsign}\'s break via context menu');
    //     throw UnimplementedError(); // TODO implement action
    //   },
    // ),
    //
    // UnitContextMenuButtonItem.spacer(),
    //
    // // Unit Properties
    // UnitContextMenuButtonItem(
    //   label: 'Unit Properties',
    //   onPressed: () {
    //     _log.info(
    //       'Opening Unit Properties for ${unit.callsign} via context menu',
    //     );
    //     throw UnimplementedError(); // TODO implement action
    //   },
    // ),
    //
    // UnitContextMenuButtonItem.spacer(),
    //
    // // Log Off
    // UnitContextMenuButtonItem(
    //   label: 'Log Off',
    //   onPressed: () {
    //     _log.info('Logging off ${unit.callsign} via context menu');
    //     throw UnimplementedError(); // TODO implement action
    //   },
    // ),
  ];

  Logger get _log {
    final Logger log = Logger('UnitContextMenu');
    log.level = Level.ALL;
    return log;
  }

  final Unit unit;

  final MapViewModel _mapViewModel;

  final UnitsViewModel unitsViewModel;

  @override
  Widget build(BuildContext context) {
    return ContextMenuRegion(
      controller: controller,
      contextMenuBuilder: (BuildContext context, Offset offset) {
        _log.fine('Right clicked map marker for ${unit.callsign}');
        // The custom context menu will look like the default context menu
        // on the current platform with buttons as specified in buttonItems.
        return AdaptiveTextSelectionToolbar.buttonItems(
          anchors: TextSelectionToolbarAnchors(primaryAnchor: offset),
          buttonItems: items(context),
        );
      },
      child: child,
    );
  }
}

/// A builder that includes an [Offset] to draw the context menu at.
typedef ContextMenuBuilder = Widget Function(
  BuildContext context,
  Offset offset,
);

/// Shows and hides the context menu based on user gestures.
///
/// By default, shows the menu on right clicks and long presses.
class ContextMenuRegion extends StatefulWidget {
  /// Creates an instance of [ContextMenuRegion].
  const ContextMenuRegion({
    super.key,
    required this.child,
    required this.controller,
    required this.contextMenuBuilder,
  });

  /// Builds the context menu.
  final ContextMenuBuilder contextMenuBuilder;

  /// The child widget that will be listened to for gestures.
  final Widget child;

  final ContextMenuController controller;

  @override
  State<ContextMenuRegion> createState() => _ContextMenuRegionState();
}

class _ContextMenuRegionState extends State<ContextMenuRegion> {
  Offset? _longPressOffset;

  late final ContextMenuController _contextMenuController = widget.controller;

  static bool get _longPressEnabled {
    switch (defaultTargetPlatform) {
      case .android:
      case .iOS:
        return true;
      case .macOS:
      case .fuchsia:
      case .linux:
      case .windows:
        return false;
    }
  }

  void _onSecondaryTapUp(TapUpDetails details) {
    // debugPrint('_onSecondaryTapUp');
    _show(details.globalPosition);
  }

  void _onSecondaryTapDown(TapDownDetails details) {
    // debugPrint('_onSecondaryTapDown');
  }

  void _onSecondaryTapCancel() {
    // debugPrint('_onSecondaryTapCancel');
    _hide();
  }

  void _onTap() {
    // debugPrint('_onTap (ContextMenuRegion)');
    if (!_contextMenuController.isShown) {
      // debugPrint('_contextMenuController is NOT shown');
      return;
    }
    // debugPrint('_contextMenuController is shown - hiding');
    _hide();
  }

  void _onLongPressStart(LongPressStartDetails details) {
    // debugPrint('_onLongPressStart');
    _longPressOffset = details.globalPosition;
  }

  void _onLongPress() {
    // debugPrint('_onLongPress');
    assert(_longPressOffset != null);
    _show(_longPressOffset!);
    _longPressOffset = null;
  }

  void _show(Offset position) {
    // debugPrint('_show');
    _contextMenuController.show(
      context: context,
      contextMenuBuilder: (BuildContext context) {
        return widget.contextMenuBuilder(context, position);
      },
    );
  }

  void _hide() {
    // debugPrint('_hide');
    _contextMenuController.remove();
  }

  @override
  void dispose() {
    _hide();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onSecondaryTapUp: _onSecondaryTapUp,
      // TODO consider removing onSecondaryTapDown, onSecondaryTapCancel - likely not needed
      onSecondaryTapDown: _onSecondaryTapDown,
      onSecondaryTapCancel: _onSecondaryTapCancel,
      onTap: _onTap,
      onTapCancel: _hide,
      onLongPress: _longPressEnabled ? _onLongPress : null,
      onLongPressStart: _longPressEnabled ? _onLongPressStart : null,
      child: widget.child,
    );
  }
}

// TODO refactor context menu to base it on MenuItemButton/Menu Entry to allow sub-options - see example: https://api.flutter.dev/flutter/material/MenuItemButton-class.html#material.MenuBar.1
final class UnitContextMenuButtonItem extends ContextMenuButtonItem {
  UnitContextMenuButtonItem({
    required void Function() onPressed,
    required super.label,
  }) : super(
         onPressed: () {
           ContextMenuController.removeAny();
           onPressed();
         },
       );

  /// An item without a label that simply closes the menu, for adding a blank line between menu items.
  UnitContextMenuButtonItem.spacer()
    : super(onPressed: () => ContextMenuController.removeAny());
}
