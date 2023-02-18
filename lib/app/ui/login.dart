import 'package:classmatch/app/controller/alarm_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:provider/provider.dart';
import '../controller/auth_service.dart';
import 'alarmlist.dart';
import '../controller/notification_controller.dart';

/// 로그인 페이지
class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthService>(
      builder: (context, authService, child) {
        final user = authService.currentUser();
        final alarmService = context.read<AlarmService>();
        //print("메시지 출력");

        return Scaffold(
          appBar: AppBar(title: Text("로그인")),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                /// 현재 유저 로그인 상태
                Center(
                  child: Text(
                    user == null ? "로그인해 주세요 🙂" : "${user.email}님 안녕하세요 👋",
                    style: TextStyle(
                      fontSize: 24,
                    ),
                  ),
                ),

                SizedBox(height: 32),

                /// 이메일
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(hintText: "이메일"),
                ),

                /// 비밀번호
                TextField(
                  controller: passwordController,
                  obscureText: false, // 비밀번호 안보이게
                  decoration: InputDecoration(hintText: "비밀번호"),
                ),
                SizedBox(height: 32),

                /// 로그인 버튼
                ElevatedButton(
                  child: Text("로그인", style: TextStyle(fontSize: 21)),
                  onPressed: () {
                    // 로그인
                    authService.signIn(
                      email: emailController.text,
                      password: passwordController.text,
                      onSuccess: () async {
                        // 로그인 성공
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text("로그인 성공"),
                        ));
                        // HomePage로 이동
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => ArlamList()),
                        );
                      },
                      onError: (err) {
                        // 에러 발생
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(err),
                        ));
                      },
                    );
                  },
                ),

                /// 회원가입 버튼
                ElevatedButton(
                  child: Text("회원가입", style: TextStyle(fontSize: 21)),
                  onPressed: () {
                    // 회원가입
                    authService.signUp(
                      email: emailController.text,
                      password: passwordController.text,
                      onSuccess: () {
                        // // 최초 토큰 저장
                        // final token_update = token_g;
                        // print(user!.uid);
                        // print(token_update);
                        //print(user!.uid);
                        //alarmService.createToken(user!.uid, token_update);

                        // 회원가입 성공
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text("회원가입 성공"),
                        ));
                      },
                      onError: (err) {
                        // 에러 발생
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(err),
                        ));
                      },
                    );
                  },
                ),

                // /// 회원가입 버튼
                // ElevatedButton(
                //     child: Text("카카오 로그인", style: TextStyle(fontSize: 21)),
                //     onPressed: () async {
                //       if (await isKakaoTalkInstalled()) {
                //         try {
                //           await UserApi.instance.loginWithKakaoTalk();
                //           print('카카오톡으로 로그인 성공');
                //           _get_user_info();
                //           // HomePage로 이동
                //           Navigator.pushReplacement(
                //             context,
                //             MaterialPageRoute(
                //                 builder: (context) => ArlamList()),
                //           );
                //         } catch (error) {
                //           print('카카오톡으로 로그인 실패 $error');
                //           // 카카오톡에 연결된 카카오계정이 없는 경우, 카카오계정으로 로그인
                //           try {
                //             await UserApi.instance.loginWithKakaoAccount();
                //             print('카카오계정으로 로그인 성공');
                //             _get_user_info();
                //             // HomePage로 이동
                //             Navigator.pushReplacement(
                //               context,
                //               MaterialPageRoute(
                //                   builder: (context) => ArlamList()),
                //             );
                //           } catch (error) {
                //             print('카카오계정으로 로그인 실패 $error');
                //           }
                //         }
                //       } else {
                //         try {
                //           await UserApi.instance.loginWithKakaoAccount();
                //           print('카카오계정으로 로그인 성공');
                //           _get_user_info();
                //           // HomePage로 이동
                //           Navigator.pushReplacement(
                //             context,
                //             MaterialPageRoute(
                //                 builder: (context) => ArlamListOld()),
                //           );
                //         } catch (error) {
                //           print('카카오계정으로 로그인 실패 $error');
                //         }
                //       }
                //     }),
              ],
            ),
          ),
        );
      },
    );
  }

  void _get_user_info() async {
    try {
      User user = await UserApi.instance.me();
      print('사용자 정보 요청 성공'
          '\n회원번호: ${user.id}'
          '\n닉네임: ${user.kakaoAccount?.profile?.nickname}');
    } catch (error) {
      print('사용자 정보 요청 실패 $error');
    }
  }
}

class FcmToken {
  final String? uid;
  final String? token;
  final Timestamp? timestamp;

  FcmToken({
    this.uid,
    this.token,
    this.timestamp,
  });

  factory FcmToken.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return FcmToken(
      uid: data?['uid'],
      token: data?['token'],
      timestamp: data?['timestamp'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (uid != null) "uid": uid,
      if (token != null) "token": token,
      if (timestamp != null) "timestamp": timestamp,
    };
  }
}
