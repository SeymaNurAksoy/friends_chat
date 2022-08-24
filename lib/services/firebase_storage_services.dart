import 'dart:io';


import 'package:firebase_storage/firebase_storage.dart';
import 'package:friendss_messenger/services/storage_base.dart';

class FirebaseStorageService implements StorageBase {
  FirebaseStorage storage = FirebaseStorage.instance;
  late Reference _storageReference;

  @override
  Future<String> uploadFile(String userId, String fileType, File yuklenecekDosya) async {
    _storageReference = FirebaseStorage.instance.ref().child(userId).child(fileType).child("profil_foto.png");

    UploadTask uploadTask = _storageReference.putFile(yuklenecekDosya as File);

    TaskSnapshot snapshot = await uploadTask;

    var url = await _storageReference.getDownloadURL();
    return url;
  }
}
