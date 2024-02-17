import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class DeteksiSuhuPage extends StatefulWidget {
  const DeteksiSuhuPage({Key? key}) : super(key: key);

  @override
  State<DeteksiSuhuPage> createState() => _DeteksiSuhuPageState();
}

class _DeteksiSuhuPageState extends State<DeteksiSuhuPage> {
  final databaseReference = FirebaseDatabase.instance.ref();

  Future<List> getDataSuhu() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    User? user = _auth.currentUser;
    String? _userId = user?.uid;
    List waktu = [];
    List suhu = [];

    // Mendapatkan referensi ke koleksi "users"
    CollectionReference users =
        FirebaseFirestore.instance.collection('riwayat_suhu');

    // Mendapatkan data dari koleksi "users"
    QuerySnapshot querySnapshot = await users.get();

    // Looping untuk mendapatkan data setiap dokumen pada querySnapshot
    querySnapshot.docs.forEach((doc) {
      var jam = DateTime.fromMillisecondsSinceEpoch(
          doc['waktu'].millisecondsSinceEpoch);
      var dataJamString = '${jam.hour}:${jam.minute}${jam.second}';
      var suhuString = '${doc['suhu']}°';
      suhu.add(suhuString);
      waktu.add(dataJamString);
    });
    return [
      waktu,
      suhu,
    ];
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
                          'Suhu',
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
                                  'assets/deteksi_suhu.png',
                                  width: 100.0,
                                  height: 100.0,
                                ),
                                SizedBox(width: 8.0),
                                StreamBuilder(
                                  stream: databaseReference
                                      .child('suhu')
                                      .onValue,
                                  builder: (BuildContext context,
                                      AsyncSnapshot snapshot) {
                                    if (snapshot.hasData &&
                                        snapshot.data!.snapshot.value != null) {
                                      var data = snapshot.data!.snapshot.value;

                                      return Text(
                                        '${data}°',
                                        style: TextStyle(
                                            fontSize: 50.0,
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
                      'Historis Suhu',
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
                        future: getDataSuhu(),
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

                  SizedBox(height: 16.0),
                  // Teks "Selengkapnya" dengan aksi onTap
                  InkWell(
                    onTap: () {
                      // Navigasi ke halaman lainnya
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SecondPage()),
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
  TableRow _buildTableRow(List data,
      {bool isHeader = true, double height = 30.0}) {
    return TableRow(
      children: data
          .map(
            (item) => Container(
              padding: EdgeInsets.all(10),
              height: height,
              child: Center(
                child: Text(
                  item.toString(),
                  textAlign: TextAlign.center, // Menetapkan textAlign ke center
                  style: TextStyle(
                    fontSize: isHeader ? 16.0 : 30.0,
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
