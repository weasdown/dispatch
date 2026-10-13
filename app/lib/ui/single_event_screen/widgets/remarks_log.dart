import 'dart:collection';

import 'package:dispatch/domain/models/remark.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';

import '../../../domain/models/event/event.dart';

class RemarksLog extends StatelessWidget {
  const RemarksLog({super.key, required this.event});

  final Event event;

  List<DataCell> tableRow(Remark remark) {
    return [
      DataCell(Text(remark.author.name)),
      DataCell(
        Text(DateFormat.yMMMd('en_GB').add_Hms().format(remark.timestamp)),
      ),
      DataCell(Text(remark.message)),
    ];
  }

  @override
  Widget build(BuildContext context) {
    initializeDateFormatting('en_GB', null);
    final UnmodifiableListView<Remark> remarks = event.remarks;
    return SingleChildScrollView(
      child: DataTable(
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
    );
  }
}
