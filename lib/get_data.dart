import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<dynamic> getDataUser() async {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? user = _auth.currentUser;
  String? _userId = user?.uid;

  var userData = {};
  // Mendapatkan referensi ke koleksi "users"
  CollectionReference users =
      FirebaseFirestore.instance.collection('user_data');

  // Mendapatkan data dari koleksi "users"
  QuerySnapshot querySnapshot =
      await users.where('id_user', isEqualTo: _userId).get();

  // Looping untuk mendapatkan data setiap dokumen pada querySnapshot
  querySnapshot.docs.forEach((doc) {
    userData['custId'] = doc['customer_id'];
    userData['custName'] = doc['customer_name'];
    userData['idUser'] = doc['id_user'];
  });
  return userData;
}