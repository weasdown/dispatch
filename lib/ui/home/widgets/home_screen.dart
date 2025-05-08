import 'package:flutter/material.dart';

import '../view_models/home_viewmodel.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.viewModel});

  final HomeViewModel viewModel;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Events',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
      drawer: NavigationDrawer(
        children: [
          DrawerHeader(child: Text('Drawer Header')),
          Container(color: Colors.grey, child: Text('First item')),
        ],
      ),
      body: Center(
        child: Column(
          children: [
            ListenableBuilder(
              listenable: widget.viewModel,
              builder: (context, _) {
                debugPrint(
                  'Number of events: ${widget.viewModel.events.length}',
                );
                return ListView(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  shrinkWrap: true,
                  children: widget.viewModel.eventTiles,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
