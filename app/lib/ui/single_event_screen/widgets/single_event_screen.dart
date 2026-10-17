import 'package:logging/logging.dart';
import 'package:material_ui/material_ui.dart';

import '../../../domain/models/event/event.dart';
import '../view_models/single_event_screen_viewmodel.dart';
import 'event_mode_button.dart';
import 'non_null_event.dart';
import 'null_event.dart';

class SingleEventScreen extends StatefulWidget {
  const SingleEventScreen({super.key, required this.viewModel});

  final SingleEventScreenViewModel viewModel;

  @override
  State<SingleEventScreen> createState() => _SingleEventScreenState();
}

class _SingleEventScreenState extends State<SingleEventScreen> {
  EventMode? _eventMode = .select;

  void onEventModeUpdate(EventMode? mode) {
    setState(() => _eventMode = mode);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Event'),
        elevation: 8,
        automaticallyImplyLeading: false,
        actions: [
          RadioGroup<EventMode>(
            groupValue: _eventMode,
            onChanged: onEventModeUpdate,
            child: Row(
              children: [
                // Select button
                EventModeButton(
                  label: 'Select',
                  value: EventMode.select,
                  onEventModeUpdate: onEventModeUpdate,
                ),

                // Create button
                EventModeButton(
                  label: 'Create',
                  value: EventMode.create,
                  onEventModeUpdate: onEventModeUpdate,
                ),

                // Update button
                EventModeButton(
                  label: 'Update',
                  value: EventMode.update,
                  onEventModeUpdate: onEventModeUpdate,
                  colourOnSelected: Colors.red,
                ),
              ],
            ),
          ),
        ],
      ),
      body: ListenableBuilder(
        listenable: widget.viewModel.load,
        builder: (context, child) {
          final Logger log = Logger('_SingleEventScreenState');
          return ListenableBuilder(
            listenable: widget.viewModel,
            builder: (context, _) {
              final Event? event = widget.viewModel.event;
              return (event == null)
                  ? NullEvent(event: event, log: log)
                  : NonNullEvent(
                      event: event,
                      log: log,
                      viewModel: widget.viewModel,
                    ); // event != null
            },
          );
        },
      ),
    );
  }
}
