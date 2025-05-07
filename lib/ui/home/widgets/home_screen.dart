import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../domain/models/event.dart';
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
      appBar: AppBar(title: Text('Home')),
      body: Center(
        child: Column(
          children: [
            Text('Home'),
            Gap(30),
            ListenableBuilder(
              listenable: widget.viewModel,
              builder: (context, _) {
                print('Number of events: ${widget.viewModel.events.length}');
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: widget.viewModel.events.length,
                  itemBuilder: (_, index) {
                    Event event = widget.viewModel.events[index];
                    return Card(
                      child: ListTile(
                        title: Text(event.address),
                        subtitle: Text(event.noc?.description ?? 'No NOC'),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
