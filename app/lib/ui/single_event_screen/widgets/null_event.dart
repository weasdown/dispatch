import 'package:logging/logging.dart';
import 'package:material_ui/material_ui.dart';

import '../../../domain/models/event/event.dart';

class NullEvent extends StatelessWidget {
  const NullEvent({super.key, required this.event, required this.log});

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
