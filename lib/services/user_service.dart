import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/app_user.dart';

class UserService {
  final _usersRef = FirebaseFirestore.instance.collection('users');

  Future<AppUser?> getUserById(String uid) async {
    final doc = await _usersRef.doc(uid).get();
    if (!doc.exists) return null;
    return AppUser.fromFirestore(uid, doc.data()!);
  }
}
