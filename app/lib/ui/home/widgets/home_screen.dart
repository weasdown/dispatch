import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../single_event_screen/view_models/single_event_screen_viewmodel.dart';
import '../../single_event_screen/widgets/single_event_screen.dart';
import '../view_models/home_viewmodel.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
    required this.homeViewModel,
    required this.singleEventScreenViewModel,
  });

  final HomeViewModel homeViewModel;

  final SingleEventScreenViewModel singleEventScreenViewModel;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    SingleEventScreenViewModel placeholderViewModel =
        SingleEventScreenViewModel(eventRepository: context.read());
    return SingleEventScreen(viewModel: placeholderViewModel);

    // // TODO remove commented code below to AllEventsScreen (not yet created)
    // return Scaffold(
    //   appBar: AppBar(
    //     title: Text(
    //       'Events',
    //       style: Theme.of(context).textTheme.headlineMedium,
    //     ),
    //   ),
    //   drawer: NavigationDrawer(
    //     children: [
    //       DrawerHeader(child: Text('Drawer Header')),
    //       Container(color: Colors.grey, child: Text('First item')),
    //     ],
    //   ),
    //   body: Center(
    //     child: Column(
    //       children: [
    //         ListenableBuilder(
    //           listenable: widget.viewModel,
    //           builder: (context, _) {
    //             debugPrint(
    //               'Number of events: ${widget.viewModel.events.length}',
    //             );
    //             return ListView(
    //               padding: EdgeInsets.symmetric(horizontal: 20),
    //               shrinkWrap: true,
    //               children: widget.viewModel.eventTiles,
    //             );
    //           },
    //         ),
    //       ],
    //     ),
    //   ),
    // );
  }
}
