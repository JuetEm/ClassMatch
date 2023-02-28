import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

Timestamp? timestamp;

class AlarmService extends ChangeNotifier {
  //final alarmCollection = FirebaseFirestore.instance.collection('live');
  final alarmCollection = FirebaseFirestore.instance.collection('inprogress2');
  final fcmCollection = FirebaseFirestore.instance.collection('fcmInfo');
  final userInfoCollection = FirebaseFirestore.instance.collection('userInfo');

  // Stream<QuerySnapshot<Map<String, dynamic>>> read(String uid) async* {
  //   // 내 bucketList 가져오기
  //   // yield alarmCollection.orderBy('startTime', descending: true).snapshots();
  // }
}
