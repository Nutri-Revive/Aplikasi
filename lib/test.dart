import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class RealtimeDataScreen extends StatefulWidget {
  @override
  _RealtimeDataScreenState createState() => _RealtimeDataScreenState();
}

class _RealtimeDataScreenState extends State<RealtimeDataScreen> {
  // Langkah 2: Mengganti URL database dengan URL yang benar dari Firebase
  final databaseReference = FirebaseDatabase.instance
      .ref()
      .child('nutri-review-default-rtdb-asia-southeast1');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Realtime Data'),
      ),
      body: StreamBuilder(
        // Langkah 3: Menggunakan StreamBuilder yang tepat untuk mendengarkan perubahan data di database
        stream: databaseReference.onValue,
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            print('Data: ${snapshot.data!.snapshot.value}');
            Map<dynamic, dynamic> map = snapshot.data!.snapshot.value;
            var kelembaban = map['kelembaban'];
            var suhu = map['suhu'];
            var kadar_air = map['kadar_air'];
            var stok_sampah = map['stok_sampah'];

            // Langkah 4: Menggunakan ListView.builder untuk menampilkan data dalam daftar
            return ListView.builder(
              itemCount: map.length,
              itemBuilder: (context, index) {
                String key = map.keys.elementAt(index);
                String value = map.values.elementAt(index).toString();
                return ListTile(
                  title: Text(key),
                  subtitle: Text(value),
                );
              },
            );
          } else if (snapshot.hasError) {
            print('Error: ${snapshot.error}');
            return Center(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  "Error loading data",
                  style: TextStyle(color: Colors.red, fontSize: 20),
                ),
              ),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
