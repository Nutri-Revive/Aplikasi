import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class KelembabanTablePage extends StatelessWidget {
  Future<List<List<String>>> getDataKelembaban() async {
    List<String> tanggal = [];
    List<String> waktu = [];
    List<String> nilaiKelembaban = [];

    // Mendapatkan referensi ke koleksi "riwayat_kelembaban"
    CollectionReference users =
        FirebaseFirestore.instance.collection('riwayat_kelembaban');

    // Mendapatkan data dari koleksi "riwayat_kelembaban"
    QuerySnapshot querySnapshot =
        await users.orderBy('waktu', descending: true).get();

    // Looping untuk mendapatkan data setiap dokumen pada querySnapshot
    querySnapshot.docs.forEach((doc) {
      var jam = DateTime.fromMillisecondsSinceEpoch(
          doc['waktu'].millisecondsSinceEpoch);
      var dataJamString =
          '${jam.day.toString().padLeft(2, '0')}-${jam.month.toString().padLeft(2, '0')}-${jam.year}'; // Sesuaikan format tanggal
      var waktuString =
          '${jam.hour.toString().padLeft(2, '0')}:${jam.minute.toString().padLeft(2, '0')}';
      var kelembabanString = '${doc['kelembaban']} %RH';

      tanggal.add(dataJamString);
      waktu.add(waktuString);
      nilaiKelembaban.add(kelembabanString);
    });

    return [tanggal, waktu, nilaiKelembaban];
  }

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
          padding: const EdgeInsets.only(left: 16.0),
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
              child: KelembabanTable(data: getDataKelembaban()),
            ),
          ),
        ],
      ),
    );
  }
}

class KelembabanTable extends StatelessWidget {
  final Future<List<List<String>>> data;

  KelembabanTable({required this.data});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<List<String>>>(
      future: data,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return Container(
            decoration: BoxDecoration(
              color: const Color(0xFF425537),
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Table(
              border: TableBorder.all(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20.0),
              ),
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: _buildTableRows(snapshot.data!),
            ),
          );
        }
      },
    );
  }

  List<TableRow> _buildTableRows(List<List<String>>? data) {
    if (data == null || data.isEmpty) {
      return [];
    }

    List<TableRow> rows = [];
    rows.add(_buildTableRow(['Tanggal', 'Waktu', 'Nilai Kelembaban']));

    for (int i = 0; i < data[0].length; i++) {
      rows.add(_buildTableRow([data[0][i], data[1][i], data[2][i]]));
    }

    return rows;
  }

  TableRow _buildTableRow(List<String> rowData) {
    return TableRow(
      children: rowData.map((item) {
        return Container(
          padding: EdgeInsets.all(10),
          height: 60.0,
          child: Center(
            child: Text(
              item,
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
