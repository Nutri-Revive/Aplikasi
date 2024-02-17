import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class BeratSampahPage extends StatefulWidget {
  const BeratSampahPage({Key? key}) : super(key: key);

  @override
  State<BeratSampahPage> createState() => _BeratSampahPageState();
}

class _BeratSampahPageState extends State<BeratSampahPage> {
  final databaseReference = FirebaseDatabase.instance.ref();
  
  Color _getColorFromStokSampah(int? stokSampah) {
    if (stokSampah == null || stokSampah == 0) {
      return Colors.grey; // Warna abu-abu untuk "kosong"
    } else if (stokSampah <= 25) {
      return Color.fromARGB(255, 3, 251, 52); // Warna kuning untuk "sedikit"
    } else if (stokSampah <= 29) {
      return Colors.orange; // Warna oranye untuk "banyak"
    } else {
      return Color.fromARGB(255, 221, 25, 11); // Warna merah untuk "penuh"
    }
  }

  String _getTextFromStokSampah(int? stokSampah) {
    if (stokSampah == null || stokSampah == 0) {
      return 'Kosong'; // Teks "kosong"
    } else if (stokSampah <= 25) {
      return 'Sedikit'; // Teks "sedikit"
    } else if (stokSampah <= 29) {
      return 'Banyak'; // Teks "banyak"
    } else {
      return 'Penuh'; // Teks "penuh"
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF5C7557),
      body: Stack(
        children: <Widget>[
          Positioned(
            top: 65,
            left: 28,
            child: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.of(context).pop();
              },
              color: Colors.white,
              iconSize: 40,
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height / 2 -
                250, // Atur posisi vertikal
            left: MediaQuery.of(context).size.width / 2 -
                133, // Atur posisi horizontal
            child: Container(
              width: 266,
              height: 307,
              decoration: BoxDecoration(
                color: Color(0xFF425537),
                borderRadius: BorderRadius.circular(30.0),
                border: Border.all(
                  color: Color(0xFF687144),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3), // Warna bayangan
                    spreadRadius: 2, // Seberapa jauh bayangan menyebar
                    blurRadius: 20, // Seberapa kabur bayangan
                    offset: Offset(0, 14), // Perpindahan bayangan (x, y)
                  ),
                ],
              ),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Text(
                      'Berat Sampah',
                      style: TextStyle(
                        fontSize: 25.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.asset(
                              'assets/trash_logo.png',
                              width: 110,
                              height: 110,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          StreamBuilder(
                            stream:
                                databaseReference.child('stok_sampah').onValue,
                            builder:
                                (BuildContext context, AsyncSnapshot snapshot) {
                              if (snapshot.hasData &&
                                  snapshot.data!.snapshot.value != null) {
                                var stokSampah = snapshot.data!.snapshot.value;
                                return Text(
                                  '$stokSampah KG',
                                  style: TextStyle(
                                    fontSize: 40.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                );
                              } else {
                                return Text('Loading...');
                              }
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 560, // Atur posisi vertikal ke bawah
            left: MediaQuery.of(context).size.width / 2 -
                130, // Atur posisi horizontal ke tengah
            child: Text(
              'Status Sampah',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          StreamBuilder(
            stream: databaseReference.child('stok_sampah').onValue,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData &&
                  snapshot.data!.snapshot.value != null) {
                var stokSampah = snapshot.data!.snapshot.value;
                return Positioned(
                  top: 600,
                  height: 93,
                  width: 265,
                  left: MediaQuery.of(context).size.width / 2 - 132.5,
                  child: Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: _getColorFromStokSampah(stokSampah),
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        _getTextFromStokSampah(stokSampah),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 35,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                );
              } else {
                return SizedBox(); // Jika tidak ada data, kembalikan widget kosong
              }
            },
          ),
        ],
      ),
    );
  }
}
