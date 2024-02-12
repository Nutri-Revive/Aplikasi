import 'package:flutter/material.dart';
import 'package:nutri_revive/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  bool _rememberMe = false;
  bool _isObscure =
      true; // Variabel untuk melacak apakah password tersembunyi atau tidak
  bool _isUsernameFocused = false;
  bool _isPasswordFocused = false;

  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordFocused = !_isPasswordFocused;
    });
  }

  // nyimpan error message
  String _errorMessage = '';

  void login() async {
    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    String custName = "${_usernameController.text}@gmail.com";
    String custId = _passwordController.text;

    try {
      await firebaseAuth.signInWithEmailAndPassword(
          email: custName, password: custId);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);
      setState(() {
        _errorMessage = '';
      });

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } on FirebaseAuthException catch (error) {
      setState(() {
        if (error.code == 'user-not-found') {
          _errorMessage = 'User tidak ditemukan';
        } else if (error.code == 'wrong-password') {
          _errorMessage = 'Password yang Anda masukkan salah';
        } else {
          _errorMessage = 'Terjadi kesalahan saat masuk: ${error.message}';
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF5C7557), // Mengatur warna latar belakang
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 80.0),
              Container(
                width: 266,
                height:
                    338, // Mengatur lebar container agar mengisi lebar layar
                decoration: BoxDecoration(
                  color: Color(0xFF3F7E45), // Warna latar belakang container
                  borderRadius: BorderRadius.circular(
                      73.0), // Mengatur radius border container
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
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 40.0),
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: Text(
                          '  Welcome to\n Nutrie Revive',
                          style: TextStyle(
                            fontSize: 25.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    Image.asset(
                      'assets/trashbin.png', // Ganti dengan path gambar Anda
                      height: 225.0, // Mengatur tinggi gambar
                      width: 160.0, // Mengatur lebar gambar
                      fit: BoxFit
                          .cover, // Mengatur bagaimana gambar menyesuaikan ruang yang tersedia
                    ),
                  ],
                ),
              ),
              SizedBox(height: 100.0),
              Container(
                height: 50.0, // Mengatur tinggi kolom username
                width: double
                    .infinity, // Mengatur lebar kolom username agar mengikuti lebar layar
                child: TextField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons
                        .person), // Menambahkan icon di sebelah kiri teks username
                    labelText: _isUsernameFocused ? null : 'Username',
                    fillColor: Color(
                        0xFFD9D9D9), // Warna latar belakang kolom username
                    filled: true, // Mengaktifkan latar belakang berwarna
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50.0),
                      borderSide:
                          BorderSide(color: Colors.white), // Ubah warna border
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50.0),
                      borderSide:
                          BorderSide(color: Colors.white), // Ubah warna border
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      // Ketika ada perubahan teks, perbarui status _isUsernameFocused
                      _isUsernameFocused = value.isNotEmpty;
                    });
                  },
                ),
              ),
              SizedBox(height: 20.0),
              Container(
                height: 50.0, // Mengatur tinggi kolom username
                width: double
                    .infinity, // Mengatur lebar kolom username agar mengikuti lebar layar
                child: TextField(
                  controller: _passwordController,
                  obscureText:
                      _isObscure, // Menyembunyikan atau menampilkan password sesuai dengan nilai _isObscure
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons
                        .lock), // Menambahkan ikon kunci di sebelah kiri teks password
                    labelText: _isPasswordFocused ? null : 'Password',
                    fillColor: Color(
                        0xFFD9D9D9), // Warna latar belakang kolom username
                    filled: true, // Mengaktifkan latar belakang berwarna
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50.0),
                      borderSide:
                          BorderSide(color: Colors.white), // Ubah warna border
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50.0),
                      borderSide:
                          BorderSide(color: Colors.white), // Ubah warna border
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                          _isObscure ? Icons.visibility : Icons.visibility_off),
                      onPressed: () {
                        setState(() {
                          _isObscure = !_isObscure; // Mengubah nilai _isObscure
                        });
                      },
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      // Ketika ada perubahan teks, perbarui status _isPasswordFocused
                      _isPasswordFocused = value.isNotEmpty;
                    });
                  },
                ),
              ),
              Row(
                children: <Widget>[
                  Checkbox(
                    value: _rememberMe,
                    onChanged: (bool? value) {
                      setState(() {
                        _rememberMe = value!;
                      });
                    },
                  ),
                  Text(
                    'Remember Password',
                    style: TextStyle(color: Colors.white),
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          // Handle forgot password logic here
                        },
                        child: Text(
                          'Forgot Password?',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  login();
                },
                style: ElevatedButton.styleFrom(
                  minimumSize:
                      Size(double.infinity, 50), // Mengatur ukuran tombol
                  backgroundColor: Color(0xFF425537), // Mengatur warna tombol
                ),
                child: Text(
                  'Login',
                  style: TextStyle(
                      color: const Color.fromARGB(255, 255, 255,
                          255)), // Mengubah warna teks tombol login menjadi hijau),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
