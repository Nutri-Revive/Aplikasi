import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:nutri_revive/home_page.dart';

class PengukurKadarAir extends StatefulWidget {
  const PengukurKadarAir({Key? key}) : super(key: key);

  @override
  _PengukurKadarAirState createState() => _PengukurKadarAirState();
}

class _PengukurKadarAirState extends State<PengukurKadarAir> {
  final databaseReference = FirebaseDatabase.instance.ref();
  var waterNow;
  int water = 0;
  int meter = 0;

  void increasewater() {
    setState(() {
      water++;
    });
  }

  void decreasewater() {
    print((waterNow as int) - water);
    if (waterNow > -1) {
      setState(() {
        water--;
      });
    }
  }

  void ubahKadarAir() {
    if (((waterNow as int) + water) > -1) {
      databaseReference.child('kadar_air').set((waterNow as int) + water);
      setState(() {
        water = 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF5C7557),
      body: Stack(
        children: <Widget>[
          // Tombol Kembali
          Positioned(
            top: 65,
            left: 28,
            child: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomePage(),
                  ),
                );
              },
              color: Colors.white,
              iconSize: 40,
            ),
          ),

          Positioned(
            top: MediaQuery.of(context).size.height / 2 - 250,
            left: MediaQuery.of(context).size.width / 2 - 133,
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
                      'KETINGGIAN AIR',
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
                              'assets/kadar_air.png',
                              width: 110,
                              height: 110,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(width: 0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          StreamBuilder(
                            stream:
                                databaseReference.child('kadar_air').onValue,
                            builder:
                                (BuildContext context, AsyncSnapshot snapshot) {
                              if (snapshot.hasData &&
                                  snapshot.data!.snapshot.value != null) {
                                var data = snapshot.data!.snapshot.value;
                                databaseReference
                                    .child('kadar_air')
                                    .onValue
                                    .listen((event) {
                                  waterNow = event.snapshot.value;
                                });
                                return Text(
                                  '$data METER',
                                  style: TextStyle(
                                    fontSize: 25.0,
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
            bottom: 275,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Tombol -
                ElevatedButton(
                  onPressed: decreasewater,
                  child: Text(
                    '-',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF8B9D88),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: EdgeInsets.symmetric(
                        vertical: 10, horizontal: 30), // Atur tinggi dan lebar
                  ),
                ),
                SizedBox(width: 25),

                // Nilai Tinggi Air
                Container(
                  child: Center(
                    child: Text(
                      '$water',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 25),

                // Tombol +
                ElevatedButton(
                  onPressed: increasewater,
                  child: Text(
                    '+',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF8B9D88),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: EdgeInsets.symmetric(
                        vertical: 10, horizontal: 30), // Atur tinggi dan lebar
                  ),
                ),
              ],
            ),
          ),

          // Tombol Simpah
          Positioned(
            bottom: 180,
            left: 120,
            right: 120,
            child: ElevatedButton(
              onPressed: ubahKadarAir,
              child: Text(
                'Simpan',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF425537),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                minimumSize: Size(125, 70), // Atur tinggi dan lebar tombol
              ),
            ),
          ),
        ],
      ),
    );
  }
}
