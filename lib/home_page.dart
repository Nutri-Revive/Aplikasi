import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nutri_revive/berat_sampah_page.dart';
import 'package:nutri_revive/integrasi_page.dart';
import 'package:nutri_revive/pengukur_kadar_air.dart';
import 'deteksi_suhu.dart';
import 'monitoring_kelembapan.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
      body: Column(
        children: [
          SizedBox(height: 40),
          Container(
            padding: EdgeInsets.all(20),
            child: Row(
              children: [
                // Profile Picture
                Image.asset(
                  "assets/profil.png", // Ganti dengan path ke gambar Anda
                  width: 50,
                  height: 50,
                ),
                // Spacing
                SizedBox(width: 10),

                // Nama pemilik
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FutureBuilder(
                        future: getDataUser(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return CircularProgressIndicator(); // Menampilkan indikator loading saat data masih diambil
                          } else {
                            if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else {
                              if (snapshot.hasData && snapshot.data!.exists) {
                                Map<String, dynamic> userData =
                                    snapshot.data!.data()!;
                                String nama = userData['nama_lengkap'] ??
                                    ''; // Mendapatkan alamat pengguna, jika ada
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
                        }),
                  ],
                ),

                Spacer(),
                Icon(
                  Icons
                      .notifications, // Change this to the notification icon you want
                  color: Colors.white,
                  size: 30,
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          FutureBuilder(
              future: getDataUser(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator(); // Menampilkan indikator loading saat data masih diambil
                } else {
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    if (snapshot.hasData && snapshot.data!.exists) {
                      Map<String, dynamic> userData = snapshot.data!.data()!;
                      String address = userData['tempat_tinggal'] ??
                          ''; // Mendapatkan alamat pengguna, jika ada
                      return Text(
                        address,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      );
                    } else {
                      return Text('User data not found or empty');
                    }
                  }
                }
              }),
          SizedBox(height: 40),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context, // Konteks dari widget saat ini
                MaterialPageRoute(
                  // Buat rute baru menggunakan MaterialPageRoute
                  builder: (context) =>
                      const IntegrasiPage(), // Widget yang akan ditampilkan di rute baru
                ),
              );
            },
            icon: Padding(
              padding: EdgeInsets.only(right: 15), // Atur jarak gambar ke kanan
              child: Image.asset(
                "assets/control.png", // Ganti dengan path ke gambar Anda
                width: 100,
                height: 100,
              ),
            ),
            label: Column(
              // Kolom untuk menampilkan teks
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  // Teks "CONTROL" dengan ukuran font 18
                  'CONTROL',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                  ),
                ),
                Text(
                  // Teks "IOT FOOD WASTE COMPOSTER" dengan ukuran font 12
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
              // Gaya dari tombol
              backgroundColor:
                  Color(0xFF425537), // Warna latar belakang hijau gelap

              shape: RoundedRectangleBorder(
                  // Bentuk persegi panjang berbulet dengan radius 10
                  borderRadius: BorderRadius.circular(30),
                  side: BorderSide(color: Color(0xFF687144), width: 1.5)),
              padding:
                  EdgeInsets.all(30), // Jarak antara konten dan tepi tombol
            ),
          ),
          SizedBox(
            height: 30.0,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                    EdgeInsets.only(left: 35.0), // Atur nilai sesuai kebutuhan
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
              SizedBox(
                height: 10.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  createCard(context, 'KELEMBAPAN', '+6%', '20 %RH',
                      'assets/kelembapan.png'),
                  createCard(context, 'SUHU', '+6%', '20°', 'assets/suhu.png'),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  createCard(context, 'STOK SAMPAH', '-7%', '30 KG',
                      'assets/stok_sampah.png'),
                  createCard(context, 'KADAR AIR', '+6%', '15 LITER',
                      'assets/kadar_air.png'),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget createCard(BuildContext context, String title, String change,
      String value, String iconPath) {
    return Container(
      width: 150.0,
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
            if (title == 'KELEMBAPAN') {
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
            } else if (title == 'KADAR AIR') {
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
                    Align(
                      alignment: Alignment.topRight,
                      child: Text(
                        change,
                        style: TextStyle(color: Colors.white, fontSize: 10),
                      ),
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
                      width: 50.0,
                    ),
                    SizedBox(width: 10),
                    Text(
                      value,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
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
