import 'package:gap/gap.dart';
import 'package:material_ui/material_ui.dart';

import '../view_models/single_event_screen_viewmodel.dart';

class EventModeButton extends StatelessWidget {
  const EventModeButton({
    super.key,
    required this.label,
    required this.value,
    required this.onEventModeUpdate,
    this.colourOnSelected,
  });

  final Color? colourOnSelected;

  final String label;

  final EventMode value;

  final void Function(EventMode? mode) onEventModeUpdate;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onEventModeUpdate(value),
      child: Row(
        children: [
          const Gap(2),
          Radio(
            value: value,
            side: (colourOnSelected == null)
                ? null
                : WidgetStateBorderSide.resolveWith(
                    (Set<WidgetState> states) =>
                        (states.contains(WidgetState.selected))
                        ? BorderSide(
                            color: colourOnSelected!,
                            width: 4,
                            strokeAlign: BorderSide.strokeAlignCenter,
                          )
                        : null,
                  ),
          ),
          const Gap(2),
          Text(label, softWrap: false),
          const Gap(8),
        ],
      ),
    );
  }
}
