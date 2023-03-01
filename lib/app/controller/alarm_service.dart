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

  void createToken(String uid, String token) async {
    timestamp = Timestamp.now();
    // print('${uid}/${token}/${timestamp.toString()}');

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
      // print(e.toString());
    }
  }

  void updateToken(String uid, String token) async {
    timestamp = Timestamp.now();

    final snapshot = await findtoken(uid);
    String docId = snapshot.docs[0].id;

    // print('docId : ${docId}');

    // firebase auth 회원 가입
    try {
      // bucket 만들기
      await fcmCollection.doc(docId).update({
        'uid': uid, // 유저 식별자
        'token': token, // fcm 토큰
        'timestamp': timestamp, // 시간
      });
      // print("토큰업데이트 : ${uid}${timestamp}${token}");
    } catch (e) {
      // Firebase auth 이외의 에러 발생
      // onError(e.toString());
      // print(e.toString());
    }
  }

  Future<QuerySnapshot> findtoken(
    String uid,
  ) async {
    final fcmCollection = FirebaseFirestore.instance.collection('fcmInfo');
    return await fcmCollection.where('uid', isEqualTo: uid).get();
  }

  Future<QuerySnapshot> findUserInfo(
    String uid,
  ) async {
    return await userInfoCollection.where('uid', isEqualTo: uid).get();
  }

  // void signUp({
  //   required String email, // 이메일
  //   required String password, // 비밀번호
  //   required Function onSuccess, // 가입 성공시 호출되는 함수
  //   required Function(String err) onError, // 에러 발생시 호출되는 함수
  // }) async {

  Future<List> findFavArea(String uid) async {
    final snapshot =
        await userInfoCollection.where('uid', isEqualTo: uid).get();
    List areaList = snapshot.docs[0].get('areaList');
    return areaList;
  }

  Future<bool> getUserInfo(String uid) async {
    final snapshot =
        await userInfoCollection.where('uid', isEqualTo: uid).get();
    bool isExpired = snapshot.docs[0].get('isExpired');
    return isExpired;
  }

  Future<String> findtalkName(String uid) async {
    final snapshot =
        await userInfoCollection.where('uid', isEqualTo: uid).get();
    String talkName = snapshot.docs[0].get('talkName');
    return talkName;
  }

  void updateOnboardChk({
    required String uid,
    required bool onBoarding,
    required Function onSuccess,
    required Function(String err) onError,
  }) async {
    timestamp = Timestamp.now();

    final snapshot = await findUserInfo(uid);
    String docId = snapshot.docs[0].id;

    // print('docId : ${docId}');

    try {
      // bucket 만들기
      await userInfoCollection.doc(docId).set({
        'uid': uid, // 유저 식별자
        'onBoarding': onBoarding, // 온보딩정보
        'timestamp': timestamp, // 시간
      }, SetOptions(merge: true));
      // 성공 함수 호출
      onSuccess();
      // print("온보딩업데이트 : ${uid}${timestamp}${onBoarding.toString()}");
    } catch (e) {
      // Firebase auth 이외의 에러 발생
      onError(e.toString());
      // print(e.toString());
    }
  }

  void updateAlarmChk({
    required String uid,
    required bool alarmChk,
    required Function onSuccess,
    required Function(String err) onError,
  }) async {
    timestamp = Timestamp.now();

    final snapshot = await findUserInfo(uid);
    String docId = snapshot.docs[0].id;

    // print('docId : ${docId}');

    try {
      // bucket 만들기
      await userInfoCollection.doc(docId).set({
        'uid': uid, // 유저 식별자
        'alarmChk': alarmChk, // 알람체크정보
        'timestamp': timestamp, // 시간
      }, SetOptions(merge: true));
      // 성공 함수 호출
      onSuccess();
      // print("알람체크 : ${uid}${timestamp}${alarmChk.toString()}");
    } catch (e) {
      // Firebase auth 이외의 에러 발생
      onError(e.toString());
      // print(e.toString());
    }
  }

  void updateFavArea({
    required String uid,
    required List<String> areaList,
    required Function onSuccess,
    required Function(String err) onError,
  }) async {
    timestamp = Timestamp.now();

    final snapshot = await findUserInfo(uid);
    String docId = snapshot.docs[0].id;
    debugPrint("서버업데이트 직전 ${areaList.toString()}");

    try {
      // bucket 만들기
      await userInfoCollection.doc(docId).set({
        'uid': uid, // 유저 식별자
        'areaList': areaList, // 선호지역
        'timestamp': timestamp, // 시간
      }, SetOptions(merge: true));
      // 성공 함수 호출
      notifyListeners();
      onSuccess();
      // print("알람체크 : ${uid}${timestamp}${alarmChk.toString()}");
    } catch (e) {
      // Firebase auth 이외의 에러 발생
      onError(e.toString());
      // print(e.toString());
    }
  }

  void syncdBupdate({
    required String uid,
  }) async {
    final snapshot = await findUserInfo(uid);
    String docId = snapshot.docs[0].id;

    try {
      // bucket 만들기
      await userInfoCollection.doc(docId).set({
        'phoneNumber': "phoneNumber", // 전화번호
        'name': "name", // 이름
        'talkName': "talkName",
      }, SetOptions(merge: true));
    } catch (e) {}
  }
}
