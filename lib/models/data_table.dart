import 'package:flutter/material.dart';

class MyDataTable extends StatelessWidget {
  final List<Map<String, dynamic>> categoryItems;

  const MyDataTable({Key? key, required this.categoryItems}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DataTable(
      columns: const <DataColumn>[
        DataColumn(label: Text('id')),
        DataColumn(label: Text('user')),
        DataColumn(label: Text('shop')),
        DataColumn(label: Text('date')),
        DataColumn(label: Text('time')),
        DataColumn(label: Text('name')),
        DataColumn(label: Text('model_name')),
        DataColumn(label: Text('color_name')),
        DataColumn(label: Text('size_name')),
        DataColumn(label: Text('quantity')),
        DataColumn(label: Text('mrp')),
        DataColumn(label: Text('total_price')),
      ],
      rows: categoryItems.map((data) {
        return DataRow(
          cells: <DataCell>[
            DataCell(Text(data['id']?.toString() ?? '')),
            DataCell(Text(data['user']?.toString() ?? '')),
            DataCell(Text(data['shop']?.toString() ?? '')),
            DataCell(Text(data['date']?.toString() ?? '')),
            DataCell(Text(data['time']?.toString() ?? '')),
            DataCell(Text(data['name']?.toString() ?? '')),
            DataCell(Text(data['model_name']?.toString() ?? '')),
            DataCell(Text(data['color_name']?.toString() ?? '')),
            DataCell(Text(data['size_name']?.toString() ?? '')),
            DataCell(Text(data['quantity']?.toString() ?? '')),
            DataCell(Text(data['mrp']?.toString() ?? '')),
            DataCell(Text(data['total_price']?.toString() ?? '')),
          ],
        );
      }).toList(),
    );
  }
}
