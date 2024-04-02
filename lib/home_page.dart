import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nutri_revive/berat_sampah_page.dart';
import 'package:nutri_revive/integrasi_page.dart';
import 'package:nutri_revive/pengukur_kadar_air.dart';
import 'deteksi_suhu.dart';
import 'monitoring_kelembapan.dart';
import 'package:firebase_database/firebase_database.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final DatabaseReference _database = FirebaseDatabase.instance.ref();

  Future<DocumentSnapshot<Map<String, dynamic>>> getDataUser() async {
    try {
      final FirebaseAuth _auth = FirebaseAuth.instance;
      User? user = _auth.currentUser;

      // Menangani jika pengguna tidak terautentikasi
      if (user == null) {
        throw Exception('User is not authenticated');
      }

      // Mendapatkan ID pengguna
      String userId = user.uid;

      // Mendapatkan referensi ke koleksi "user_data"
      CollectionReference users =
          FirebaseFirestore.instance.collection('user_data');

      // Mendapatkan dokumen pengguna berdasarkan ID
      DocumentSnapshot<Map<String, dynamic>> doc = await users.doc(userId).get()
          as DocumentSnapshot<Map<String, dynamic>>;

      // Memeriksa apakah dokumen ada dan memiliki data sebelum mengembalikannya
      if (doc.exists) {
        return doc;
      } else {
        throw Exception('User data not found');
      }
    } catch (e) {
      // Menangani kesalahan jika terjadi
      throw Exception('Error getting user data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF5C7557),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 40),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Image.asset(
                      "assets/profile.jpg",
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FutureBuilder(
                        future: getDataUser(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return CircularProgressIndicator();
                          } else {
                            if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else {
                              if (snapshot.hasData && snapshot.data!.exists) {
                                Map<String, dynamic> userData =
                                    snapshot.data!.data()!;
                                String nama = userData['nama_lengkap'] ?? '';
                                return Text(
                                  nama,
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                );
                              } else {
                                return Text('User data not found or empty');
                              }
                            }
                          }
                        },
                      ),
                    ],
                  ),
                  Spacer(),
                ],
              ),
            ),
            SizedBox(height: 20),
            FutureBuilder(
              future: getDataUser(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else {
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    if (snapshot.hasData && snapshot.data!.exists) {
                      Map<String, dynamic> userData = snapshot.data!.data()!;
                      String address = userData['tempat_tinggal'] ?? '';
                      // Membuat TextSpan untuk memformat teks dengan baris baru setelah koma
                      TextSpan textSpan = TextSpan(
                        text: address,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      );
                      int commaIndex = address.indexOf(',');
                      // Jika koma ditemukan, tambahkan baris baru setelah koma
                      if (commaIndex != -1) {
                        textSpan = TextSpan(
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          children: [
                            TextSpan(
                                text: address.substring(
                                    0, commaIndex + 1)), // Teks sebelum koma
                            TextSpan(text: '\n'), // Baris baru setelah koma
                            TextSpan(
                                text: address.substring(
                                    commaIndex + 1)), // Teks setelah koma
                          ],
                        );
                      }
                      return RichText(
                        textAlign: TextAlign.center,
                        text: textSpan,
                      );
                    } else {
                      return Text('User data not found or empty');
                    }
                  }
                }
              },
            ),
            SizedBox(height: 40),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const IntegrasiPage(),
                  ),
                );
              },
              icon: Padding(
                padding: EdgeInsets.only(right: 15),
                child: Image.asset(
                  "assets/control.png",
                  width: 100,
                  height: 100,
                ),
              ),
              label: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'CONTROL',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                    ),
                  ),
                  Text(
                    'IOT FOOD WASTE\nCOMPOSTER',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                    ),
                  ),
                ],
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF425537),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                  side: BorderSide(color: Color(0xFF687144), width: 1.5),
                ),
                padding: EdgeInsets.all(30),
              ),
            ),
            SizedBox(height: 50.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 35.0),
                  child: Text(
                    'Parameter',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: 10.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    createCard(
                      context,
                      'KELEMBABAN UDARA',
                      'assets/kelembapan.png',
                      'kelembaban_udara',
                      ' %RH',
                    ),
                    createCard(
                      context,
                      'SUHU',
                      'assets/suhu.png',
                      'suhu',
                      '° C',
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    createCard(
                      context,
                      'STOK SAMPAH',
                      'assets/stok_sampah.png',
                      'kepenuhan',
                      '',
                    ),
                    createCard(
                      context,
                      'KELEMBABAN TANAH',
                      'assets/kadar_air.png',
                      'kelembaban_tanah',
                      ' %',
                    ),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget createCard(BuildContext context, String title, String iconPath,
      String dataType, String unit) {
    return Container(
      width: 155.0,
      height: 100.0,
      child: Card(
        color: Color(0xFF425537),
        shape: RoundedRectangleBorder(
          side: BorderSide(
              color: Color(0xFF687144),
              width: 1.5), // Warna dan ketebalan border
          borderRadius: BorderRadius.circular(12.0), // Radius border
        ),
        child: InkWell(
          onTap: () async {
            if (title == 'KELEMBABAN UDARA') {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const MonotoringKelembapanPage()),
              );
            } else if (title == 'SUHU') {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const DeteksiSuhuPage()),
              );
            } else if (title == 'STOK SAMPAH') {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const BeratSampahPage()),
              );
            } else if (title == 'KELEMBABAN TANAH') {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const PengukurKadarAir()),
              );
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      title,
                      style: TextStyle(color: Colors.white, fontSize: 10),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.asset(
                      iconPath,
                      height: 50.0,
                      width: 40.0,
                    ),
                    SizedBox(width: 10),
                    StreamBuilder(
                      stream: _database.child(dataType).onValue,
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (snapshot.hasData &&
                            snapshot.data!.snapshot.value != null) {
                          var data = snapshot.data!.snapshot.value;
                          return Text(
                            '$data$unit', // Menggabungkan nilai dan satuan tanpa spasi di antaranya
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        } else {
                          return Text(
                            '',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
