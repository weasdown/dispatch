import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';
import 'package:material_ui/material_ui.dart';

import '../../../domain/models/unit/unit.dart';
import '../../events/view_models/all_events_view_model.dart';
import '../view_models/units_view_model.dart';

final class UnitContextMenuRegion extends StatelessWidget {
  const UnitContextMenuRegion({
    super.key,
    required this.unit,
    required this.child,
    required this.eventsViewModel,
    required this.unitsViewModel,
  });

  final Widget child;

  final AllEventsViewModel eventsViewModel;

  List<ContextMenuButtonItem> items(BuildContext context) =>
      <ContextMenuButtonItem>[
        // Dispatch unit
        ContextMenuButtonItem(
          label: 'Dispatch ${unit.callsign}',
          onPressed: () {
            ContextMenuController.removeAny();
            _log.info('Dispatching of ${unit.callsign} via context menu');
            // TODO replace snackbar with actual dispatch function
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Dispatching ${unit.callsign}')),
            );
          },
        ),
      ];

  Logger get _log {
    final Logger log = Logger('UnitContextMenu');
    log.level = Level.ALL;
    return log;
  }

  final Unit unit;

  final UnitsViewModel unitsViewModel;

  @override
  Widget build(BuildContext context) {
    return _ContextMenuRegion(
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
typedef _ContextMenuBuilder = Widget Function(
  BuildContext context,
  Offset offset,
);

/// Shows and hides the context menu based on user gestures.
///
/// By default, shows the menu on right clicks and long presses.
class _ContextMenuRegion extends StatefulWidget {
  /// Creates an instance of [_ContextMenuRegion].
  const _ContextMenuRegion({
    required this.child,
    required this.contextMenuBuilder,
  });

  /// Builds the context menu.
  final _ContextMenuBuilder contextMenuBuilder;

  /// The child widget that will be listened to for gestures.
  final Widget child;

  @override
  State<_ContextMenuRegion> createState() => _ContextMenuRegionState();
}

class _ContextMenuRegionState extends State<_ContextMenuRegion> {
  Offset? _longPressOffset;

  final ContextMenuController _contextMenuController = ContextMenuController();

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
    _show(details.globalPosition);
  }

  void _onTap() {
    if (!_contextMenuController.isShown) {
      return;
    }
    _hide();
  }

  void _onLongPressStart(LongPressStartDetails details) {
    _longPressOffset = details.globalPosition;
  }

  void _onLongPress() {
    assert(_longPressOffset != null);
    _show(_longPressOffset!);
    _longPressOffset = null;
  }

  void _show(Offset position) {
    _contextMenuController.show(
      context: context,
      contextMenuBuilder: (BuildContext context) {
        return widget.contextMenuBuilder(context, position);
      },
    );
  }

  void _hide() {
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
      onTap: _onTap,
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
