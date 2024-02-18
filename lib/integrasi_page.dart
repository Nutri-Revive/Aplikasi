import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class IntegrasiPage extends StatefulWidget {
  const IntegrasiPage({Key? key}) : super(key: key);

  @override
  State<IntegrasiPage> createState() => _IntegrasiPageState();
}

class _IntegrasiPageState extends State<IntegrasiPage> {
  @override
  Widget build(BuildContext context) {
    var isKeyboardVisible = MediaQuery.of(context).viewInsets.bottom != 0;
    return Scaffold(
      backgroundColor: const Color(0xFF5C7557),
      resizeToAvoidBottomInset:
          true, // parameter ini dapat dihilangkan karena nilainya true secara default
      body: Stack(
        children: <Widget>[
          if (!isKeyboardVisible)
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
          Center(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              TemperatureControl(),
              SizedBox(height: 32),
              HumidityControl(),
              SizedBox(height: 32),
              CompostControl(),
            ]),
          ),
        ],
      ),
    );
  }
}

class TemperatureControl extends StatefulWidget {
  const TemperatureControl({Key? key}) : super(key: key);
  @override
  _TemperatureControlState createState() => _TemperatureControlState();
}

class _TemperatureControlState extends State<TemperatureControl> {
  final databaseReference = FirebaseDatabase.instance.ref();
  var temperatureNow;
  int temperature = 0;

  void increaseTemperature() {
    setState(() {
      temperature++;
      ubahSuhu();
    });
  }

  void decreaseTemperature() {
    setState(() {
      temperature--;
      ubahSuhu();
    });
  }

  void ubahSuhu() {
    if (((temperatureNow as int) + temperature) > -1) {
      databaseReference
          .child('suhu')
          .set((temperatureNow as int) + temperature);
      setState(() {
        temperature = 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 32.0),
          child: Text(
            'Atur Suhu',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: decreaseTemperature,
              child: Text(
                '-',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 30,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF8B9D88),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: EdgeInsets.all(10),
              ),
            ),
            SizedBox(width: 16),
            Container(
              width: 142,
              height: 93,
              decoration: BoxDecoration(
                color: Color(0xFF425537),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: StreamBuilder(
                  stream: databaseReference.child('suhu').onValue,
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData &&
                        snapshot.data!.snapshot.value != null) {
                      var data = snapshot.data!.snapshot.value;
                      databaseReference.child('suhu').onValue.listen((event) {
                        temperatureNow = event.snapshot.value;
                      });
                      return Text(
                        '$data°',
                        style: TextStyle(
                          fontSize: 50.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      );
                    } else {
                      return Text('Loading...');
                    }
                  },
                ),
              ),
            ),
            SizedBox(width: 16),
            ElevatedButton(
              onPressed: increaseTemperature,
              child: Text(
                '+',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 30,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF8B9D88),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: EdgeInsets.all(10),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// Membuat kelas HumidityControl
class HumidityControl extends StatefulWidget {
  const HumidityControl({Key? key}) : super(key: key);
  @override
  _HumidityControlState createState() => _HumidityControlState();
}

class _HumidityControlState extends State<HumidityControl> {
  final databaseReference = FirebaseDatabase.instance.ref();
  var humidityNow;
  int humidity = 0; // Nilai awal kelembapan

  void increaseHumidity() {
    setState(() {
      humidity++; // Menambahkan nilai kelembapan
      ubahKelembaban();
    });
  }

  void decreaseHumidity() {
    setState(() {
      humidity--; // Mengurangi nilai kelembapan
      ubahKelembaban();
    });
  }

  void ubahKelembaban() {
    if (((humidityNow as int) + humidity) > -1) {
      databaseReference
          .child('kelembaban')
          .set((humidityNow as int) + humidity);
      setState(() {
        humidity = 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 32.0),
          child: Text(
            'Atur Kelembapan',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: decreaseHumidity,
              child: Text(
                '-',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 30,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF8B9D88),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: EdgeInsets.all(10),
              ),
            ),
            SizedBox(width: 16),
            Container(
              width: 142,
              height: 93,
              decoration: BoxDecoration(
                color: Color(0xFF425537),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: StreamBuilder(
                  stream: databaseReference.child('kelembaban').onValue,
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData &&
                        snapshot.data!.snapshot.value != null) {
                      var data = snapshot.data!.snapshot.value;
                      databaseReference
                          .child('kelembaban')
                          .onValue
                          .listen((event) {
                        humidityNow = event.snapshot.value;
                      });
                      return Text(
                        '$data %RH',
                        style: TextStyle(
                          fontSize: 35.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      );
                    } else {
                      return Text('Loading...');
                    }
                  },
                ),
              ),
            ),
            SizedBox(width: 16),
            ElevatedButton(
              onPressed: increaseHumidity,
              child: Text(
                '+',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 30,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF8B9D88),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: EdgeInsets.all(10),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class CompostControl extends StatefulWidget {
  @override
  _CompostControlState createState() => _CompostControlState();
}

class _CompostControlState extends State<CompostControl> {
  final databaseReference = FirebaseDatabase.instance.ref();
  int pengomposNow = 0;

  TextEditingController compostInputController =
      TextEditingController(); // Membuat controller untuk input field

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 32.0),
          child: Text(
            'Atur Bahan Pengompos',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 220,
              height: 35,
              child: StreamBuilder(
                stream: databaseReference.child('bahan_pengompos').onValue,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData &&
                      snapshot.data!.snapshot.value != null) {
                    pengomposNow = snapshot.data!.snapshot.value;
                    return TextField(
                      controller: compostInputController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: 'Masukkan berat bahan pengompos (kg)',
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        filled: true,
                        fillColor: Color(0xFFBEC8BC),
                        contentPadding: EdgeInsets.only(top: 10, left: 10),
                      ),
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.black,
                      ),
                    );
                  } else {
                    return Text('Loading...');
                  }
                },
              ),
            ),
            SizedBox(width: 16),
            ElevatedButton(
              onPressed: () {
                int pengomposInput =
                    int.tryParse(compostInputController.text) ?? 0;
                if (pengomposNow + pengomposInput > -1) {
                  databaseReference
                      .child('bahan_pengompos')
                      .set(pengomposNow + pengomposInput);
                  setState(() {
                    compostInputController.text =
                        ''; // Clear input after setting to the database
                  });
                }
              }, // Menghubungkan fungsi dengan tombol
              child: Text(
                'Simpan',
                style: TextStyle(
                  color: Color(0xFFFFFFFF),
                  fontSize: 15,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF425537),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                padding: EdgeInsets.all(5),
                minimumSize: Size(68, 35),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
