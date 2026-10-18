import 'package:dispatch/ui/single_event_screen/widgets/single_event_screen.dart';
import 'package:gap/gap.dart';
import 'package:logging/logging.dart';
import 'package:material_ui/material_ui.dart';

import '../../../domain/models/event/event.dart';
import '../view_models/single_event_screen_viewmodel.dart';
import 'patient_details.dart';
import 'remarks_log.dart';

class NonNullEvent extends StatelessWidget {
  NonNullEvent({
    super.key,
    required this.event,
    required this.eventMode,
    required this.viewModel,
    required this.patientControllers,
  });

  final Event event;
  final EventMode eventMode;
  final Logger _log = Logger('NonNullEvent');
  final PatientControllers patientControllers;
  final SingleEventScreenViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    _log.finer('eventMode: $eventMode');
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
                _Overview(event: event, log: _log),
                const Gap(30),
                _Location(event: event),
                const Gap(30),
                _Buttons(event: event),
                const Gap(50),
                const Divider(),
                const Gap(8),
                PatientDetails(
                  eventMode: eventMode,
                  patientControllers: patientControllers,
                  viewModel: viewModel,
                ),
                const Gap(50),
                RemarksLog(event: event, viewModel: viewModel),
              ],
            ),
          ),
        ),
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

class _Overview extends StatelessWidget {
  const _Overview({required this.event, required this.log});

  final Event event;
  final Logger log;

  @override
  Widget build(BuildContext context) {
    log.info('Building _Overview with event: ${event.idLastFour}');
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
