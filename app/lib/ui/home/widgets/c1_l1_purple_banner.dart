import 'package:logging/logging.dart';
import 'package:material_ui/material_ui.dart';

import '../../../domain/models/event/category.dart';
import '../../../domain/models/event/event.dart';
import '../../events/priority_colour.dart';
import '../../events/view_models/all_events_view_model.dart';
import '../../events/view_models/single_event_screen_viewmodel.dart';

/// A purple snackbar that's displayed when a new C1/L1 event is received from the [HomeViewModel.newC1L1Stream].
class C1L1PurpleBanner extends SnackBar {
  C1L1PurpleBanner({
    super.key,
    required BuildContext context,
    required AllEventsViewModel eventsViewModel,
    required SingleEventScreenViewModel singleEventScreenViewModel,
    required this.newC1L1,
  }) : super(
         content: Text(
           label(newC1L1),
           style: Theme.of(context).textTheme.bodyLarge!
               .copyWith(color: _textColour),
         ),
         backgroundColor: Category.one.priority.backgroundColour,
         showCloseIcon: true,
         persist: true,
         action: SnackBarAction(
           label: 'Show event',
           textColor: _textColour,
           onPressed: () {
             (Logger('C1L1PurpleBanner')..level = Level.ALL).fine(
               'Selecting new C1/L1 ${newC1L1.idLastFour} from snackbar',
             );
             eventsViewModel.selectEvent.execute(newC1L1);
             singleEventScreenViewModel.displayEvent.execute(newC1L1);
           },
         ),
       );

  final Event newC1L1;

  static String label(Event newC1L1) {
    // Get "C1" or "L1" from the NOC.
    final type = newC1L1.noc!.description.substring(0, 2);
    return 'New $type: ${newC1L1.idLastFour}';
  }

  static final Color _textColour = Colors.white;
}
