import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:logging/logging.dart';

import '../../../domain/models/event/event.dart';
import '../view_models/single_event_screen_viewmodel.dart';

class SingleEventScreen extends StatefulWidget {
  const SingleEventScreen({super.key, required this.viewModel});

  final SingleEventScreenViewModel viewModel;

  @override
  State<SingleEventScreen> createState() => _SingleEventScreenState();
}

class _SingleEventScreenState extends State<SingleEventScreen> {
  final Logger _log = Logger('SingleEventScreen');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Event')),
      body: ListenableBuilder(
        listenable: widget.viewModel.load,
        builder: (context, child) {
          Event? event = widget.viewModel.event;

          if (event != null) {
            _log.fine('There is a selected event');

            final Widget overview = Center(
              child: Table(
                children: [
                  TableRow(
                    children: [
                      Text(
                        (event.noc != null)
                            ? '${event.category.toString()}: ${event.noc!.description}'
                            : 'No NOC',
                      ),
                    ],
                  ),
                ],
              ),
            );

            final Widget patientDetails = DecoratedBox(
              decoration: BoxDecoration(border: Border.all()),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Patient details...\n\nTBC',
                  textAlign: TextAlign.center,
                ),
              ),
            );

            final Widget buttons = Column(
              children: [
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(Colors.red),
                  ),
                  onPressed: () => debugPrint('Find AED'),
                  child: Text(
                    'Find AED',
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium!.copyWith(color: Colors.white),
                  ),
                ),
              ],
            );

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  overview,
                  const Gap(30),
                  buttons,
                  const Gap(50),
                  patientDetails,
                ],
              ),
            );
          } else {
            _log.warning('There is no selected event');
            return Center(
              child: Text(
                'No event selected',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            );
          }
        },
      ),
    );
  }
}
