import 'dart:collection';

import 'package:gap/gap.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

import '../../../domain/models/event/event.dart';
import '../../../domain/models/event/remark.dart';
import '../../../ui/single_event_screen/view_models/single_event_screen_viewmodel.dart';

class RemarksLog extends StatefulWidget {
  const RemarksLog({super.key, required this.event, required this.viewModel});

  final Event event;

  final SingleEventScreenViewModel viewModel;

  @override
  State<RemarksLog> createState() => _RemarksLogState();
}

class _RemarksLogState extends State<RemarksLog> {
  List<DataCell> tableRow(Remark remark) {
    return [
      DataCell(Text(remark.author.name)),
      DataCell(
        Text(DateFormat.yMMMd('en_GB').add_Hms().format(remark.timestamp)),
      ),
      DataCell(Text(remark.message)),
    ];
  }

  final _formKey = GlobalKey<FormState>();

  Future<void> _submitRemark(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      await widget.viewModel.addRemark(context.read(), _textController.text);
      _textController.clear();
      setState(() {});
    }
  }

  // Text controller to retrieve current value of remark text box.
  final _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    initializeDateFormatting('en_GB', null);
    final UnmodifiableListView<Remark> remarks = widget.event.remarks;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Form(
          key: _formKey,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: TextFormField(
                  controller: _textController,
                  autovalidateMode: AutovalidateMode.onUserInteractionIfError,
                  autofocus: true,
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '';
                    }
                    return null;
                  },
                ),
              ),
              ElevatedButton(
                onPressed: () => _submitRemark(context),
                child: Text('Submit'),
              ),
            ],
          ),
        ),
        Gap(8),
        Expanded(
          child: ListView(
            shrinkWrap: true,
            children: [
              DataTable(
                columns: [
                  DataColumn(
                    label: Text('Name'),
                    headingRowAlignment: MainAxisAlignment.start,
                    columnWidth: FractionColumnWidth(0.2),
                  ),
                  DataColumn(
                    label: Text('Time'),
                    headingRowAlignment: MainAxisAlignment.start,
                    columnWidth: FractionColumnWidth(0.2),
                  ),
                  DataColumn(
                    label: Text('Remark'),
                    headingRowAlignment: MainAxisAlignment.start,
                    columnWidth: FractionColumnWidth(0.6),
                  ),
                ],
                rows: remarks
                    .map((Remark remark) => DataRow(cells: tableRow(remark)))
                    .toList(),
                dividerThickness: 1,
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  void didUpdateWidget(covariant RemarksLog oldWidget) {
    oldWidget.viewModel.updateEvent.removeListener(_onResult);
    widget.viewModel.updateEvent.addListener(_onResult);
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    widget.viewModel.updateEvent.removeListener(_onResult);
    // Clean up the controller when the widget is disposed.
    _textController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    widget.viewModel.updateEvent.addListener(_onResult);
  }

  void _onResult() {
    if (widget.viewModel.updateEvent.completed) {
      widget.viewModel.updateEvent.clearResult();
    }

    if (widget.viewModel.updateEvent.error) {
      widget.viewModel.updateEvent.clearResult();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error while setting event'),
          action: SnackBarAction(
            label: 'Try again',
            onPressed: widget.viewModel.updateEvent.execute,
          ),
        ),
      );
    }
  }
}
