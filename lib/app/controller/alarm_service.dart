import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

Timestamp? timestamp = null;

class AlarmService extends ChangeNotifier {
  //final alarmCollection = FirebaseFirestore.instance.collection('live');
  final alarmCollection = FirebaseFirestore.instance.collection('inprogress2');
  final fcmCollection = FirebaseFirestore.instance.collection('fcmInfo');

  // Stream<QuerySnapshot<Map<String, dynamic>>> read(String uid) async* {
  //   // 내 bucketList 가져오기
  //   // yield alarmCollection.orderBy('startTime', descending: true).snapshots();
  // }

  void createToken(String uid, String token) async {
    timestamp = Timestamp.now();
    print('${uid}/${token}/${timestamp.toString()}');

    // firebase auth 회원 가입
    try {
      await fcmCollection.add({
        'uid': uid, // 유저 식별자
        'token': token, // fcm 토큰
        'timestamp': timestamp.toString(), // 시간
      });
    } catch (e) {
      // Firebase auth 이외의 에러 발생
      // onError(e.toString());
      print(e.toString());
    }
  }

  void updateToken(String uid, String token) async {
    timestamp = Timestamp.now();

    final snapshot = await findtoken(uid);
    String docId = snapshot.docs[0].id;

    print('docId : ${docId}');

    // firebase auth 회원 가입
    try {
      // bucket 만들기
      await fcmCollection.doc(docId).update({
        'uid': uid, // 유저 식별자
        'token': token, // fcm 토큰
        'timestamp': timestamp, // 시간
      });
      print("토큰업데이트 : ${uid}${timestamp}${token}");
    } catch (e) {
      // Firebase auth 이외의 에러 발생
      // onError(e.toString());
      print(e.toString());
    }
  }

  Future<QuerySnapshot> findtoken(
    String uid,
  ) async {
    final fcmCollection = FirebaseFirestore.instance.collection('fcmInfo');
    return await fcmCollection.where('uid', isEqualTo: uid).get();
  }
}
