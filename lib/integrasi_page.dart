import 'package:flutter/material.dart';

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
  @override
  _TemperatureControlState createState() => _TemperatureControlState();
}

class _TemperatureControlState extends State<TemperatureControl> {
  int temperature = 0;

  void increaseTemperature() {
    setState(() {
      temperature++;
    });
  }

  void decreaseTemperature() {
    setState(() {
      temperature--;
    });
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
                child: Text(
                  '$temperature°',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 50,
                    fontWeight: FontWeight.bold,
                  ),
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
  @override
  _HumidityControlState createState() => _HumidityControlState();
}

class _HumidityControlState extends State<HumidityControl> {
  int humidity = 0; // Nilai awal kelembapan

  void increaseHumidity() {
    setState(() {
      humidity++; // Menambahkan nilai kelembapan
    });
  }

  void decreaseHumidity() {
    setState(() {
      humidity--; // Mengurangi nilai kelembapan
    });
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
                child: Text(
                  '$humidity% RH',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                  ),
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
  TextEditingController compostInputController =
      TextEditingController(); // Membuat controller untuk input field

  void saveCompost() {
    // Membuat fungsi untuk menyimpan nilai input field
    print('Berat bahan pengompos: ${compostInputController.text} kg');
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
              child: TextField(
                controller:
                    compostInputController, // Menghubungkan controller dengan input field
                decoration: InputDecoration(
                  hintText: 'Masukkan berat bahan pengompos (kg)',
                  border: OutlineInputBorder(
                    // Menambahkan properti border
                    borderSide:
                        BorderSide.none, // Mengatur warna dan lebar border
                    borderRadius:
                        BorderRadius.circular(5), // Mengatur bentuk border
                  ),
                  filled: true,
                  fillColor: Color(0xFFBEC8BC),
                  contentPadding: EdgeInsets.only(top: 10, left: 10),
                ),
                style: TextStyle(
                  // Menambahkan properti style
                  fontSize: 10,
                  color: Colors.white, // Mengatur ukuran teks menjadi 18
                ),
              ),
            ),
            SizedBox(width: 16),
            ElevatedButton(
              onPressed: saveCompost, // Menghubungkan fungsi dengan tombol
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
