import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Message {
  final String kimden;
  final String kime;
  final bool bendenMi;
  final String mesaj;
  final String? konusmaSahibi;
  final Timestamp? date;

  Message(
      {required this.kimden,
        required this.kime,
        required this.bendenMi,
        required this.mesaj,
         this.date,
         this.konusmaSahibi});

  Map<String, dynamic> toMap() {
    return {
      'kimden': kimden,
      'kime': kime,
      'bendenMi': bendenMi,
      'mesaj': mesaj,
      'konusmaSahibi': konusmaSahibi,
      'date': date ?? FieldValue.serverTimestamp(),
    };
  }

  Message.fromMap(Map<String, dynamic> map)
      : kimden = map['kimden'],
        kime = map['kime'],
        bendenMi = map['bendenMi'],
        mesaj = map['mesaj'],
        konusmaSahibi = map['konusmaSahibi'],
        date = map['date'];

  @override
  String toString() {
    return 'Mesaj{kimden: $kimden, kime: $kime, bendenMi: $bendenMi, mesaj: $mesaj, date: $date}';
  }
}
