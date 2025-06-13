import 'package:flutter/material.dart';

import '../../../domain/models/event/event.dart';
import '../view_models/single_event_screen_viewmodel.dart';

class SingleEventScreen extends StatefulWidget {
  const SingleEventScreen({super.key, required this.viewModel});

  final SingleEventScreenViewModel viewModel;

  @override
  State<SingleEventScreen> createState() => _SingleEventScreenState();
}

class _SingleEventScreenState extends State<SingleEventScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Event')),
      body: ListenableBuilder(
        listenable: widget.viewModel.load,
        builder: (context, child) {
          Event? event = widget.viewModel.event;

          return (event != null)
              ? Table(
                  children: [
                    TableRow(children: [Text('ID'), Text(event.id.toString())]),
                  ],
                )
              : Center(
                  child: Text(
                    'No event selected',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                );
        },
      ),
    );
  }
}
