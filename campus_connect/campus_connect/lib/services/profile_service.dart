import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileService {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String?> uploadProfilePicture(File imageFile) async {
    final user = _auth.currentUser;
    if (user == null) return null;
    final ref = _storage.ref().child('profile_pictures').child('${user.uid}.jpg');
    await ref.putFile(imageFile);
    return await ref.getDownloadURL();
  }
}
