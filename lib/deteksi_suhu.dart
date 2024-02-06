import 'package:flutter/material.dart';

class DeteksiSuhuPage extends StatefulWidget {
  const DeteksiSuhuPage({Key? key}) : super(key: key);

  @override
  State<DeteksiSuhuPage> createState() => _DeteksiSuhuPageState();
}

class _DeteksiSuhuPageState extends State<DeteksiSuhuPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF5C7557),
      body: Stack(
        children: <Widget>[
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.fromLTRB(20.0, 120.0, 20.0, 20.0), // Sesuaikan padding untuk konten lainnya
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: 70),
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
                      color: Colors.black.withOpacity(0.3), // Warna bayangan
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
                        Text('Suhu',
                          style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold, color: Colors.white),
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
                                Text(
                                  '20°',
                                  style: TextStyle(fontSize: 50.0, fontWeight: FontWeight.bold, color: Colors.white),
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
                      style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                  
                  SizedBox(height: 16.0),
                  
                  // Kotak kedua (tabel)
                  Container(
                    padding: EdgeInsets.all(0),
                    decoration: BoxDecoration(
                      color: const Color(0xFF425537),  // Warna latar belakang pada padding tabel
                      borderRadius: BorderRadius.circular(20.0),  // Radius border pada padding
                    ),
                    child: Table(
                      border: TableBorder.all(color: Colors.white, borderRadius: BorderRadius.circular(20.0)), // Warna border tabel
                      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                      children: [
                        _buildTableRow(['08.00', '09.00', '10.00', '11.00'], isHeader: true, height: 50.0),
                        _buildTableRow(['20°', '20°', '20°', '20°'], isHeader: false, height: 100.0),
                      ],
                    ),
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
                        style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.white),
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
  TableRow _buildTableRow(List<String> data, {bool isHeader = true, double height = 30.0}) {
    return TableRow(
      children: data
          .map(
            (item) => Container(
              padding: EdgeInsets.all(10),
              height: height,
              child: Center(
                child: Text(
                  item,
                  textAlign: TextAlign.center,  // Menetapkan textAlign ke center
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
