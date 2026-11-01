import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';
import 'package:material_ui/material_ui.dart';

import '../../../domain/models/unit/unit.dart';
import '../../../ui/events/view_models/single_event_screen_viewmodel.dart';
import '../../events/view_models/all_events_view_model.dart';
import '../view_models/units_view_model.dart';

final class UnitContextMenuRegion extends StatelessWidget {
  const UnitContextMenuRegion({
    super.key,
    required this.unit,
    required this.controller,
    required this.child,
    required this.singleEventScreenViewModel,
    required this.eventsViewModel,
    required this.unitsViewModel,
  });

  final Widget child;

  final ContextMenuController controller;

  final AllEventsViewModel eventsViewModel;

  List<ContextMenuButtonItem> items(BuildContext context) =>
      <ContextMenuButtonItem>[
        // Dispatch unit
        ContextMenuButtonItem(
          label: 'Dispatch ${unit.callsign}',
          onPressed: () {
            ContextMenuController.removeAny();
            _log.info('Dispatching ${unit.callsign} via context menu');
            // singleEventScreenViewModel.dispatchUnit(unit);
          },
        ),
      ];

  Logger get _log {
    final Logger log = Logger('UnitContextMenu');
    log.level = Level.ALL;
    return log;
  }

  final Unit unit;

  final SingleEventScreenViewModel singleEventScreenViewModel;

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

final class UnitContextMenuButtonItem extends ContextMenuButtonItem {
  new({required void Function() onPressed, required super.label})
    : super(
        onPressed: () {
          ContextMenuController.removeAny();
          onPressed();
        },
      );
}
