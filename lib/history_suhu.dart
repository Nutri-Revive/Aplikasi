import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SuhuTablePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF5C7557),
      appBar: AppBar(
        title: Text(
          'History Suhu',
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
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SuhuTable(),
        ),
      ),
    );
  }
}

class SuhuTable extends StatefulWidget {
  @override
  _SuhuTableState createState() => _SuhuTableState();
}

class _SuhuTableState extends State<SuhuTable> {
  List<List<dynamic>> data = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    // Mengambil referensi koleksi "riwayat_suhu" dari Firestore dan mengurutkan berdasarkan waktu secara descending
    CollectionReference suhuCollection =
        FirebaseFirestore.instance.collection('riwayat_suhu');
    QuerySnapshot querySnapshot =
        await suhuCollection.orderBy('waktu', descending: true).get();

    // Mengonversi data timestamp menjadi format tanggal dan waktu yang sesuai
    List<List<dynamic>> newData = [
      ['Tanggal', 'Waktu', 'Nilai Suhu'],
      ...querySnapshot.docs.map((doc) {
        Timestamp timestamp = doc['waktu'];
        DateTime dateTime = timestamp.toDate();

        String formattedDate =
            '${dateTime.day}-${dateTime.month}-${dateTime.year}';
        String formattedTime = '${dateTime.hour}:${dateTime.minute}';

        return [formattedDate, formattedTime, doc['suhu']];
      }).toList(),
    ];

    setState(() {
      data = newData;
    });
  }

  @override
  Widget build(BuildContext context) {
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
        children: data.map((rowData) {
          return _buildTableRow(rowData);
        }).toList(),
      ),
    );
  }

  TableRow _buildTableRow(List<dynamic> rowData) {
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
