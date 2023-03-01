import 'package:classmatch/app/controller/notification_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'alarm_service.dart';

class AuthService extends ChangeNotifier {
  final fcmCollection = FirebaseFirestore.instance.collection('fcmInfo');
  final userInfoCollection = FirebaseFirestore.instance.collection('userInfo');
  final appInfoCollection = FirebaseFirestore.instance.collection('appInfo');
  User? currentUser() {
    // 현재 유저(로그인 되지 않은 경우 null 반환)
    return FirebaseAuth.instance.currentUser;
  }

  Future<int> getTalkNameLastNumber() async {
    final snapshot = await appInfoCollection.get();
    int num = snapshot.docs[0].get('talkNameNum');
    return num;
  }

  void signUp({
    required String email, // 이메일
    required String password, // 비밀번호
    required String phoneNumber,
    required String confirmpassword,
    required String name,
    required bool isChecked,
    required Function onSuccess, // 가입 성공시 호출되는 함수
    required Function(String err) onError, // 에러 발생시 호출되는 함수
  }) async {
    final RegExp regex = RegExp(
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)| (\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');

    // 이메일 및 비밀번호 입력 여부 확인
    if (name.isEmpty) {
      onError("이름을 입력해 주세요.");
      return;
    } else if (phoneNumber.isEmpty) {
      onError("전화번호를 입력해 주세요.");
      return;
    } else if (email.isEmpty) {
      onError("이메일을 입력해 주세요.");
      return;
    } else if (!regex.hasMatch(email)) {
      onError("잘못된 이메일 형식입니다.");
      return;
    } else if (password != confirmpassword) {
      onError("비밀번호가 일치하지 않습니다.");
      return;
    } else if (isChecked == false) {
      onError("개인정보 수집 및 활용에 동의 하셔야 신청할 수 있습니다.");
      return;
    }
    timestamp = Timestamp.now();
    String talkName = "";

    getTalkNameLastNumber().then((val) async {
      val = ++val;
      talkName = "망고${val.toString()}";

      // Last Number 업데이트
      try {
        await appInfoCollection.doc("QHhttYzmFCAZLwYyjVeM").set({
          'talkNameNum': val, // 시간
        }, SetOptions(merge: true));
        // 성공 함수 호출
        // onSuccess();
      } catch (e) {
        // Firebase auth 이외의 에러 발생
        onError(e.toString());
        // print(e.toString());
      }
    }).catchError((error) {
      // error가 해당 에러를 출력
      debugPrint('error: $error');
    });

    // talkName = ;

    // firebase auth 회원 가입
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = currentUser();
      // print(user!.uid);

      // token 발행
      try {
        await fcmCollection.add({
          'uid': user!.uid, // 유저 식별자
          'token': tokenFCM, // fcm 토큰
          'timestamp': timestamp, // 시간
        });
      } catch (e) {
        // Firebase auth 이외의 에러 발생
        // onError(e.toString());
        // print(e.toString());
      }

      // userprofile
      try {
        await userInfoCollection.add({
          'uid': user!.uid, // 유저 식별자
          'onBoarding': false, // 온보딩 완료 체크
          'alarmChk': false, // 알람설정 체크
          'areaList': ['서울'],
          'phoneNumber': phoneNumber, // 전화번호
          'name': name, // 이름
          'email': email, // 이메일
          'isExpired': false,
          'talkName': talkName,
          'timestamp': timestamp, // 시간
        });
      } catch (e) {
        // Firebase auth 이외의 에러 발생
        // onError(e.toString());
        // print(e.toString());
      }
      // 성공 함수 호출
      onSuccess();
    } on FirebaseAuthException catch (e) {
      // Firebase auth 에러 발생
      if (e.code == 'weak-password') {
        onError('비밀번호를 6자리 이상 입력해 주세요.');
      } else if (e.code == 'email-already-in-use') {
        onError('이미 가입된 이메일 입니다.');
      } else if (e.code == 'invalid-email') {
        onError('이메일 형식을 확인해주세요.');
      } else if (e.code == 'user-not-found') {
        onError('일치하는 이메일이 없습니다.');
      } else if (e.code == 'wrong-password') {
        onError('비밀번호가 일치하지 않습니다.');
      } else {
        onError(e.message!);
      }
    } catch (e) {
      // Firebase auth 이외의 에러 발생
      onError(e.toString());
    }
  }

  void signIn({
    required String email, // 이메일
    required String password, // 비밀번호
    required Function onSuccess, // 로그인 성공시 호출되는 함수
    required Function(String err) onError, // 에러 발생시 호출되는 함수
  }) async {
    // 로그인
    if (email.isEmpty) {
      onError('이메일을 입력해주세요.');
      return;
    } else if (password.isEmpty) {
      onError('비밀번호를 입력해주세요.');
      return;
    }

    // 로그인 시도
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      onSuccess(); // 성공 함수 호출
      notifyListeners(); // 로그인 상태 변경 알림
    } on FirebaseAuthException catch (e) {
      // firebase auth 에러 발생
      // onError(e.message!);
      if (e.code == 'weak-password') {
        onError('비밀번호를 6자리 이상 입력해 주세요.');
      } else if (e.code == 'email-already-in-use') {
        onError('이미 가입된 이메일 입니다.');
      } else if (e.code == 'invalid-email') {
        onError('이메일 형식을 확인해주세요.');
      } else if (e.code == 'user-not-found') {
        onError('일치하는 이메일이 없습니다.');
      } else if (e.code == 'wrong-password') {
        onError('비밀번호가 일치하지 않습니다.');
      } else {
        onError(e.message!);
      }
    } catch (e) {
      // Firebase auth 이외의 에러 발생
      onError(e.toString());
    }
  }

  void signOut() async {
    // 로그아웃
    await FirebaseAuth.instance.signOut();
    notifyListeners(); // 로그인 상태 변경 알림
  }
}
