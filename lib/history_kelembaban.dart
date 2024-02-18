import 'package:flutter/material.dart';

class KelembabanTablePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF5C7557),
      appBar: AppBar(
        title: Text(
          'History Kelembaban',
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF5C7557),
        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0), // Sesuaikan nilai padding
          child: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
            color: Colors.white,
            iconSize: 40,
          ),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: KelembabanTable(),
            ),
          ),
        ],
      ),
    );
  }
}

class KelembabanTable extends StatelessWidget {
  final List<List<dynamic>> data = [
    ['Tanggal', 'Waktu', 'Nila Kelembaban'],
    ['01-02-2024', '08:00', '25°C'],
    ['02-02-2024', '12:30', '28°C'],
    ['03-02-2024', '16:45', '23°C'],
    // Tambahkan data lain sesuai kebutuhan
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF425537), // Ganti dengan warna yang diinginkan
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Table(
        border: TableBorder.all(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.0),
        ),
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        children: data.map((rowData) {
          return _buildTableRow(rowData);
        }).toList(),
      ),
    );
  }

  TableRow _buildTableRow(List<dynamic> rowData,) {
    return TableRow(
      children: rowData.map((item) {
        return Container(
          padding: EdgeInsets.all(10),
          height: 50.0,
          child: Center(
            child: Text(
              item.toString(),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
