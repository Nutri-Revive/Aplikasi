import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class RealtimeDataScreen extends StatefulWidget {
  @override
  _RealtimeDataScreenState createState() => _RealtimeDataScreenState();
}

class _RealtimeDataScreenState extends State<RealtimeDataScreen> {
  final databaseReference = FirebaseDatabase.instance
      .reference()
      .child('nutri-review-default-rtdb-asia-southeast1');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Realtime Data'),
      ),
      body: StreamBuilder<Event>(
        stream: databaseReference.onValue,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
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
          } else if (snapshot.hasData) {
            DataSnapshot data = snapshot.data!.snapshot;
            Map<dynamic, dynamic> map = data.value ?? {};
            return ListView(
              children: map.entries
                  .map(
                    (entry) => ListTile(
                      title: Text(entry.key),
                      subtitle: Text(entry.value.toString()),
                    ),
                  )
                  .toList(),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
