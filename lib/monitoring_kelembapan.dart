import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'history_kelembaban.dart';

class MonotoringKelembapanPage extends StatefulWidget {
  const MonotoringKelembapanPage({Key? key}) : super(key: key);

  @override
  State<MonotoringKelembapanPage> createState() =>
      _MonotoringKelembapanPageState();
}

class _MonotoringKelembapanPageState extends State<MonotoringKelembapanPage> {
  final databaseReference = FirebaseDatabase.instance.ref();

  Future<List<List<String>>> getDataKelembaban() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    User? user = _auth.currentUser;
    String? _userId = user?.uid;
    List<String> waktu = [];
    List<String> kelembaban = [];

    // Mendapatkan referensi ke koleksi "riwayat_kelembaban"
    CollectionReference users =
        FirebaseFirestore.instance.collection('riwayat_kelembaban');

    // Mendapatkan data dari koleksi "riwayat_kelembaban"
    QuerySnapshot querySnapshot = await users.get();

    // Looping untuk mendapatkan data setiap dokumen pada querySnapshot
    querySnapshot.docs.forEach((doc) {
      var jam = DateTime.fromMillisecondsSinceEpoch(
          doc['waktu'].millisecondsSinceEpoch);
      var dataJamString = '${jam.hour}:${jam.minute}${jam.second}';
      var kelembabanString = '${doc['kelembaban']}% RH';
      kelembaban.add(kelembabanString);
      waktu.add(dataJamString);
    });

    return [waktu, kelembaban];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF5C7557),
      body: Stack(
        children: <Widget>[
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.fromLTRB(20.0, 120.0, 20.0,
                  20.0), // Sesuaikan padding untuk konten lainnya
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: 40),
                  // Kotak pertama
                  Container(
                    width: 266,
                    height: 307,
                    padding: EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: const Color(0xFF425537),
                      border: null,
                      borderRadius: BorderRadius.circular(30.0),
                      boxShadow: [
                        BoxShadow(
                          color:
                              Colors.black.withOpacity(0.3), // Warna bayangan
                          spreadRadius: 2, // Seberapa jauh bayangan menyebar
                          blurRadius: 20, // Seberapa kabur bayangan
                          offset: Offset(0, 14), // Perpindahan bayangan (x, y)
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Kelembaban',
                          style: TextStyle(
                              fontSize: 30.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        SizedBox(height: 8.0),
                        Expanded(
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/kelembapan_besar.png',
                                  width: 100.0,
                                  height: 100.0,
                                ),
                                SizedBox(width: 8.0),
                                StreamBuilder(
                                  stream: databaseReference
                                      .child('kelembaban')
                                      .onValue,
                                  builder: (BuildContext context,
                                      AsyncSnapshot snapshot) {
                                    if (snapshot.hasData &&
                                        snapshot.data!.snapshot.value != null) {
                                      var data = snapshot.data!.snapshot.value;

                                      return Text(
                                        '${data} %RH',
                                        style: TextStyle(
                                            fontSize: 25.0,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      );
                                    } else {
                                      return Text('Loading...');
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 30.0),
                  // Teks "Historis Suhu" di bawah kotak pertama
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Historis Kelembaban',
                      style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),

                  SizedBox(height: 16.0),

                  // Kotak kedua (tabel)
                  Container(
                    padding: EdgeInsets.all(0),
                    decoration: BoxDecoration(
                      color: const Color(
                          0xFF425537), // Warna latar belakang pada padding tabel
                      borderRadius: BorderRadius.circular(
                          20.0), // Radius border pada padding
                    ),
                    child: FutureBuilder(
                        future: getDataKelembaban(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return CircularProgressIndicator(); // Menampilkan indikator loading saat data masih diambil
                          } else {
                            if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else {
                              print(snapshot.data);
                              if (snapshot.hasData) {
                                var data = snapshot.data;
                                return Table(
                                  border: TableBorder.all(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(
                                          20.0)), // Warna border tabel
                                  defaultVerticalAlignment:
                                      TableCellVerticalAlignment.middle,
                                  children: [
                                    _buildTableRow(data![0],
                                        isHeader: true, height: 50.0),
                                    _buildTableRow(data[1],
                                        isHeader: false, height: 100.0),
                                  ],
                                );
                              } else {
                                return Text('User data not found or empty');
                              }
                            }
                          }
                        }),
                  ),

//disini

                  SizedBox(height: 16.0),
                  // Teks "Selengkapnya" dengan aksi onTap
                  InkWell(
                    onTap: () {
                      // Navigasi ke halaman lainnya
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => KelembabanTablePage()),
                      );
                    },
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        'Selengkapnya',
                        style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 65, // Atur posisi vertikal
            left: 28, // Atur posisi horizontal
            child: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.of(context).pop();
              },
              color: Colors.white,
              iconSize: 40,
              alignment: Alignment.topLeft,
            ),
          ),
        ],
      ),
    );
  }

  // Fungsi _buildTableRow diperbarui
  TableRow _buildTableRow(List<String> data,
      {bool isHeader = true, double height = 30.0}) {
    return TableRow(
      children: data
          .map(
            (item) => Container(
              padding: EdgeInsets.all(10),
              height: height,
              child: Center(
                child: Text(
                  item,
                  textAlign: TextAlign.center, // Menetapkan textAlign ke center
                  style: TextStyle(
                    fontSize: isHeader ? 16.0 : 20.0,
                    color: Colors.white,
                    fontWeight: isHeader ? FontWeight.bold : FontWeight.bold,
                  ),
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}

class SecondPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Halaman Kedua'),
      ),
      body: Center(
        child: Text('Halaman Kedua'),
      ),
    );
  }
}
