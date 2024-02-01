import 'package:flutter/material.dart';

class BeratSampahPage extends StatefulWidget {
  const BeratSampahPage({Key? key}) : super(key: key);

  @override
  State<BeratSampahPage> createState() => _BeratSampahPageState();
}

class _BeratSampahPageState extends State<BeratSampahPage> {
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
            top: MediaQuery.of(context).size.height / 2 - 250, // Atur posisi vertikal
            left: MediaQuery.of(context).size.width / 2 - 133, // Atur posisi horizontal
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
                          Text(
                            '30 KG',
                            style: TextStyle(
                              fontSize: 40.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
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
            left: MediaQuery.of(context).size.width / 2 - 130, // Atur posisi horizontal ke tengah
            child: Text(
              'Status Sampah',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
       

          Positioned(
            top: 600,
            height: 93,
            width: 265,
            left: MediaQuery.of(context).size.width / 2 - 132.5, // Atur posisi horizontal di tengah
            child: Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Color(0XFF00B16B),
                borderRadius: BorderRadius.circular(30.0),),
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  'Penuh',
                  textAlign: TextAlign.center, // Atur teks menjadi center secara horizontal
                  style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),


        ],
      ),
    );
  }
}
