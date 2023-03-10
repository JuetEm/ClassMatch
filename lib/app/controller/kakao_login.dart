import 'package:classmatch/app/controller/social_login.dart';
import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

class KakaoLogin implements SocialLogin {
  @override
  Future<bool> login() async {
    try {
      bool isInstalled = await isKakaoTalkInstalled();
      if (isInstalled) {
        try {
          await UserApi.instance.loginWithKakaoTalk();
          return true;
        } catch (e) {
          return false;
        }
      } else {
        try {
          debugPrint("loginWithKakaoAccount");
          await UserApi.instance.loginWithKakaoAccount();
          return true;
        } catch (e) {
          debugPrint(e.toString());
          return false;
        }
      }
    } catch (e) {
      debugPrint("KakaoLogin");
      debugPrint(e.toString());
      return false;
    }
  }

  @override
  Future<bool> logout() async {
    try {
      await UserApi.instance.unlink();
      return true;
    } catch (error) {
      return false;
    }
  }
}
