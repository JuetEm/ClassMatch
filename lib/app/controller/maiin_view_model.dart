import 'package:classmatch/app/controller/social_login.dart';
import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

class MainViewModel {
  final SocialLogin _socialLogin;
  bool isLogined = false;
  User? user;

  MainViewModel(this._socialLogin);

  Future login() async {
    isLogined = await _socialLogin.login();
    debugPrint("카카오로그인 성공-1");

    if (isLogined) {
      user = await UserApi.instance.me();
      debugPrint("카카오로그인 성공");
    }
  }

  Future logout() async {
    await _socialLogin.logout();
    debugPrint("카카오로그아웃");
    isLogined = false;
    user = null;
  }
}
