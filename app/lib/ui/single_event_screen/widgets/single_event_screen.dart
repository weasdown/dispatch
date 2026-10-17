import 'package:gap/gap.dart';
import 'package:logging/logging.dart';
import 'package:material_ui/material_ui.dart';

import '../../../domain/models/event/event.dart';
import '../view_models/single_event_screen_viewmodel.dart';
import 'remarks_log.dart';

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
                _EventModeButton(
                  label: 'Select',
                  value: EventMode.select,
                  onEventModeUpdate: onEventModeUpdate,
                ),

                // Create button
                _EventModeButton(
                  label: 'Create',
                  value: EventMode.create,
                  onEventModeUpdate: onEventModeUpdate,
                ),

                // Update button
                _EventModeButton(
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
                  ? _NullEvent(event: event, log: log)
                  : _NonNullEvent(
                      event: event,
                      log: log,
                      viewModel: widget.viewModel,
                    ); // event != null;
            },
          );
        },
      ),
    );
  }
}

class _Buttons extends StatelessWidget {
  const _Buttons({required this.event});

  final Event event;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          style: ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(Colors.red),
          ),
          onPressed: () => debugPrint('Find AED'),
          child: Text(
            'Find AED',
            style: Theme.of(context).textTheme.bodyMedium!
                .copyWith(color: Colors.white),
          ),
        ),
      ],
    );
  }
}

class _Location extends StatelessWidget {
  const _Location({required this.event});

  final Event event;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(event.address, style: Theme.of(context).textTheme.headlineSmall),
      ],
    );
  }
}

class _NonNullEvent extends StatelessWidget {
  const _NonNullEvent({
    required this.event,
    required this.log,
    required this.viewModel,
  });

  final Event event;
  final Logger log;
  final SingleEventScreenViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox.expand(
        child: Align(
          alignment: AlignmentGeometry.center,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Gap(12),
                _Overview(event: event, log: log),
                const Gap(30),
                _Location(event: event),
                const Gap(30),
                _Buttons(event: event),
                const Gap(50),
                _PatientDetails(event: event),
                const Gap(50),
                Expanded(
                  child: RemarksLog(event: event, viewModel: viewModel),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NullEvent extends StatelessWidget {
  const _NullEvent({required this.event, required this.log});

  final Event? event;
  final Logger log;

  @override
  Widget build(BuildContext context) {
    log.warning('There is no selected event');
    return Center(
      child: Text(
        'No event selected',
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.headlineSmall,
      ),
    );
  }
}

class _Overview extends StatelessWidget {
  const _Overview({required this.event, required this.log});

  final Event event;
  final Logger log;

  @override
  Widget build(BuildContext context) {
    log.info('Selected event in _Overview: ${event.idLastFour}');
    return Center(
      child: Table(
        children: [
          TableRow(
            children: [
              Text(
                (event.noc != null)
                    ? '${event.category.toString()}: ${event.noc!.description}'
                    : event.status.toString(),
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PatientDetails extends StatelessWidget {
  const _PatientDetails({required this.event});

  final Event event;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(border: Border.all(color: Colors.blue)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),

        child: Table(
          children: [
            TableRow(children: [Text('Name'), Text('[pt name]')]),
          ],
        ),
      ),
    );
  }
}

class _EventModeButton extends StatelessWidget {
  const _EventModeButton({
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
