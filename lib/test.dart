import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class RealtimeDataScreen extends StatefulWidget {
  @override
  _RealtimeDataScreenState createState() => _RealtimeDataScreenState();
}

class _RealtimeDataScreenState extends State<RealtimeDataScreen> {
  final databaseReference = FirebaseDatabase.instance.ref();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Realtime Data'),
      ),
      body: StreamBuilder(
        stream: databaseReference.child('kelembaban').onValue,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData && snapshot.data!.snapshot.value != null) {
            var data = snapshot.data!.snapshot.value;
            print(data);

            return Text(
              '$data',
              style: TextStyle(
                  fontFamily: 'Inria Sans',
                  color: Color(0xFF484848),
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold),
            );
          } else {
            return Text('Loading...');
          }
        },
      ),
    );
  }
}
