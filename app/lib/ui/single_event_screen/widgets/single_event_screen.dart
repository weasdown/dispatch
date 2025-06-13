import 'package:flutter/material.dart';
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
            return Table(
              children: [
                TableRow(children: [Text('ID'), Text(event.id.toString())]),
              ],
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
