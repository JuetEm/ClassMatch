import 'package:classmatch/app/config/analytics_config.dart';
import 'package:classmatch/app/controller/alarm_service.dart';
import 'package:classmatch/app/ui/globa_widget.dart';
import 'package:classmatch/app/ui/onboarding.dart';
import 'package:classmatch/app/ui/service_over.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../main.dart';
import '../controller/auth_service.dart';
import 'alarmlist.dart';
import 'color.dart';
import 'package:amplitude_flutter/amplitude.dart';

Color focusColor = const Color(0xFF615CFE);
Color normalColor = Palette.gray66;

/// 로그인 페이지
class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  FocusNode emailFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthService>(
      builder: (context, authService, child) {
        final alarmService = context.read<AlarmService>();
        // final user = authService.currentUser();
        // final alarmService = context.read<AlarmService>();
        //print("메시지 출력");

        return Scaffold(
          backgroundColor: Palette.grayFF,
          // appBar: AppBar(title: Text("로그인")),
          body: ScrollConfiguration(
            behavior: MyBehavior(),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  /// 현재 유저 로그인 상태
                  Center(
                    child: SizedBox(
                      width: 286,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(height: 100),
                          //SizedBox(height: 120),
                          Image.asset("assets/images/classmatchlogin.png",
                              width: 286),
                          const SizedBox(height: 45),

                          /// 이메일
                          TextField(
                            controller: emailController,
                            style: TextStyle(
                                color: normalColor,
                                fontSize: 14,
                                letterSpacing: -0.33),
                            decoration: InputDecoration(
                              labelText: "이메일",
                              labelStyle: TextStyle(
                                  color: emailFocusNode.hasFocus
                                      ? focusColor
                                      : normalColor),
                              enabledBorder: const UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Palette.gray33, width: 0),
                              ),
                              focusColor: focusColor,
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: focusColor,
                                ),
                              ),
                            ),
                            keyboardType: TextInputType.emailAddress,
                          ),

                          /// 비밀번호
                          TextField(
                            controller: passwordController,
                            obscureText: true,
                            style: TextStyle(
                                color: normalColor,
                                fontSize: 14,
                                letterSpacing: -0.33),
                            decoration: InputDecoration(
                              labelText: "비밀번호",
                              labelStyle: TextStyle(
                                  color: passwordFocusNode.hasFocus
                                      ? focusColor
                                      : normalColor),
                              enabledBorder: const UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Palette.gray33, width: 0),
                              ),
                              focusColor: focusColor,
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: focusColor,
                                ),
                              ),
                            ),
                            keyboardType: TextInputType.visiblePassword,
                          ),
                          const SizedBox(height: 35),

                          Center(
                            child: SizedBox(
                              height: 40,
                              width: 170,
                              child: TextField(
                                style: const TextStyle(
                                  color: Palette.gray00,
                                  fontSize: 12,
                                  letterSpacing: -0.33,
                                ),
                                readOnly: true,
                                controller: switchController,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  suffixIcon: Switch(
                                    activeColor: Palette.mainPoint,
                                    activeTrackColor: const Color.fromARGB(
                                        255, 171, 164, 180),
                                    value: isLogInActiveChecked,
                                    onChanged: (value) {
                                      setState(() {
                                        isLogInActiveChecked =
                                            !isLogInActiveChecked;
                                        // if (isLogInActiveChecked) {
                                        prefs.setString(
                                            "userEmail", emailController.text);
                                        prefs.setString("userPassword",
                                            passwordController.text);
                                        // }

                                        // print(
                                        //     "isLogInActiveChecked : ${isLogInActiveChecked}");
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 59),

                          /// 로그인 버튼
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
                              padding: const EdgeInsets.all(0),
                              elevation: 0,
                              backgroundColor: Palette.mainPoint,

                              minimumSize: const Size.fromHeight(50), // NEW
                            ),
                            onPressed: () {
                              // FlutterDialogImage(context);
                              // 로그인
                              authService.signIn(
                                email: emailController.text,
                                password: passwordController.text,
                                onSuccess: () {
                                  // 서버에서 한번 읽어 와야함.
                                  final user =
                                      context.read<AuthService>().currentUser();
                                  // 종료결과 불러오기
                                  final getUserInfoFromServer =
                                      alarmService.getUserInfo(user!.uid);
                                  getUserInfoFromServer.then((val) {
                                    // int가 나오면 해당 값을 출력
                                    // debugPrint('val: $val');
                                    isExpired = val;

                                    prefs.setBool("isExpired", isExpired);
                                    // if (isExpired == true) {
                                    //   prefs.setBool("isExpired", true);
                                    // } else {
                                    //   prefs.setBool("isExpired", false);
                                    // }

                                    debugPrint(
                                        'isExpired: ${isExpired.toString()}');

                                    // final Identify identify = Identify();

                                    // Analytics_config.analytics
                                    //     .identify(identify);

                                    // Set user Id
                                    Analytics_config.analytics
                                        .setUserId(user.uid);

                                    //amplitude
                                    Amplitude.getInstance()
                                        .logEvent('PAGE_VIEW : LOGIN');

                                    // 로그인 성공
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(builder: (_) {
                                        if (isExpired) {
                                          //amplitude
                                          Amplitude.getInstance().logEvent(
                                              'PAGE_VIEW : SERVICE_OVER');
                                          return const ServiceOverPage();
                                        } else if (isOnboarded) {
                                          //amplitude
                                          Amplitude.getInstance()
                                              .logEvent('PAGE_VIEW : LIST');
                                          return const ArlamListPage();
                                        } else {
                                          //amplitude
                                          Amplitude.getInstance()
                                              .logEvent('PAGE_VIEW : ONBOARD');
                                          return const OnboardingPage();
                                        }
                                      }),
                                      // => isExpired
                                      //     ? const ServiceOverPage()
                                      //     : isOnboarded
                                      //         ? const ArlamListPage()
                                      //         : const OnboardingPage()),
                                    );
                                  }).catchError((error) {
                                    // error가 해당 에러를 출력
                                    debugPrint('error: $error');
                                  });
                                },
                                onError: (err) {
                                  // 에러 발생
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    content: Text(err),
                                  ));
                                },
                              );
                            },
                            child: const Padding(
                              padding: EdgeInsets.all(14.0),
                              child: Text("로그인",
                                  style: TextStyle(
                                    fontSize: 16,
                                    letterSpacing: -0.33,
                                  )),
                            ),
                          ),
                          const SizedBox(height: 10),

                          // /// 로그인 버튼
                          // ElevatedButton(
                          //   child: Text("로그인", style: TextStyle(fontSize: 21)),
                          //   onPressed: () {
                          //     // 로그인
                          //     authService.signIn(
                          //       email: emailController.text,
                          //       password: passwordController.text,
                          //       onSuccess: () async {
                          //         // 로그인 성공
                          //         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          //           content: Text("로그인 성공"),
                          //         ));
                          //         // HomePage로 이동
                          //         Navigator.pushReplacement(
                          //           context,
                          //           MaterialPageRoute(builder: (context) => ArlamList()),
                          //         );
                          //       },
                          //       onError: (err) {
                          //         // 에러 발생
                          //         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          //           content: Text(err),
                          //         ));
                          //       },
                          //     );
                          //   },
                          // ),

                          /// 로그인 버튼
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
                              padding: const EdgeInsets.all(0),
                              elevation: 0,
                              backgroundColor: Palette.mainPoint,

                              minimumSize: const Size.fromHeight(50), // NEW
                            ),
                            onPressed: () {
                              registrationDialog(
                                  context, "무료 체험 신청", authService);

                              // // 회원가입
                              // authService.signUp(
                              //   email: emailController.text,
                              //   password: passwordController.text,
                              //   onSuccess: () {
                              //     // // 최초 토큰 저장
                              //     // final token_update = token_g;
                              //     // print(user!.uid);
                              //     // print(token_update);
                              //     //print(user!.uid);
                              //     //alarmService.createToken(user!.uid, token_update);

                              //     // 회원가입 성공
                              //     ScaffoldMessenger.of(context)
                              //         .showSnackBar(SnackBar(
                              //       content: Text("회원가입 성공"),
                              //     ));
                              //   },
                              //   onError: (err) {
                              //     // 에러 발생
                              //     ScaffoldMessenger.of(context)
                              //         .showSnackBar(SnackBar(
                              //       content: Text(err),
                              //     ));
                              //   },
                              // );
                            },
                            child: const Padding(
                              padding: EdgeInsets.all(14.0),
                              child: Text("7일간 무료체험 신청",
                                  style: TextStyle(
                                    fontSize: 16,
                                    letterSpacing: -0.33,
                                  )),
                            ),
                          ),

                          const SizedBox(height: 10),

                          // // 임시버튼
                          // // 회원가입 버튼
                          // ElevatedButton(
                          //   child: Text("회원가입", style: TextStyle(fontSize: 21)),
                          //   onPressed: () {
                          //     // 회원가입
                          //     authService.signUp(
                          //       email: emailController.text,
                          //       password: passwordController.text,
                          //       onSuccess: () {
                          //         // // 최초 토큰 저장
                          //         // final token_update = token_g;
                          //         // print(user!.uid);
                          //         // print(token_update);
                          //         //print(user!.uid);
                          //         //alarmService.createToken(user!.uid, token_update);

                          //         // 회원가입 성공
                          //         ScaffoldMessenger.of(context)
                          //             .showSnackBar(SnackBar(
                          //           content: Text("회원가입 성공"),
                          //         ));
                          //       },
                          //       onError: (err) {
                          //         // 에러 발생
                          //         ScaffoldMessenger.of(context)
                          //             .showSnackBar(SnackBar(
                          //           content: Text(err),
                          //         ));
                          //       },
                          //     );
                          //   },
                          // ),

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
                  ),
                  // Center(
                  //   child: Text(
                  //     user == null ? "로그인해 주세요 🙂" : "${user.email}님 안녕하세요 👋",
                  //     style: TextStyle(
                  //       fontSize: 24,
                  //     ),
                  //   ),
                  // ),

                  // /// 비밀번호
                  // TextField(
                  //   controller: passwordController,
                  //   obscureText: false, // 비밀번호 안보이게
                  //   decoration: InputDecoration(hintText: "비밀번호"),
                  // ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// class YourClass {
//   Future<void> exampleForAmplitude() async {
//     final Amplitude amplitude = Amplitude.getInstance();

//     amplitude.init("4a0b6470dd736bad54a484e3cec8b03f");

//     final Identify identify1 = Identify();
//     identify1.setOnce('sign_up_date', '2015-08-24');
//     Amplitude.getInstance().identify(identify1);

//     amplitude.logEvent('MyApp startup',
//         eventProperties: {'friend_num': 10, 'is_heavy_user': true});
//     debugPrint("앰플리튜드 실행됨");
//   }
// }

void registrationDialog(context, bodytext, authService) {
  showDialog(
      context: context,
      //barrierDismissible - Dialog를 제외한 다른 화면 터치 x
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Regitration(
          bodytextdata: bodytext,
          authService: authService,
        );
      });
}

class Regitration extends StatefulWidget {
  const Regitration({
    super.key,
    required this.bodytextdata,
    required this.authService,
  });

  final String bodytextdata;
  final AuthService authService;

  @override
  State<Regitration> createState() => _RegitrationState();
}

class _RegitrationState extends State<Regitration> {
  TextEditingController nameControllerDialog = TextEditingController();
  TextEditingController phoneNumberControllerDialog = TextEditingController();
  TextEditingController emailControllerDialog = TextEditingController();
  TextEditingController passwordControllerDialog = TextEditingController();
  TextEditingController passwordControllerConfirmDialog =
      TextEditingController();

  FocusNode nameFocusNodeDialog = FocusNode();
  FocusNode phoneNumberFocusNodeDialog = FocusNode();
  FocusNode emailFocusNodeDialog = FocusNode();
  FocusNode passwordFocusNodeDialog = FocusNode();
  FocusNode passwordFocusNodeConfirmDialog = FocusNode();
  bool passwordVisible = false;
  bool _isChecked = false;
  @override
  Widget build(BuildContext context) {
    debugPrint(passwordVisible.toString());
    return AlertDialog(
      // RoundedRectangleBorder - Dialog 화면 모서리 둥글게 조절
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),

      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            width: 350,
            child: Text(
              widget.bodytextdata,
            ),
          ),
          const SizedBox(height: 10),

          //이름

          TextField(
            controller: nameControllerDialog,
            // obscureText: false, // 비밀번호 안보이게
            style: TextStyle(color: normalColor),
            decoration: InputDecoration(
              labelText: "이름",
              labelStyle: TextStyle(
                  color:
                      nameFocusNodeDialog.hasFocus ? focusColor : normalColor),
              enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Palette.gray33, width: 0),
              ),
              focusColor: focusColor,
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: focusColor,
                ),
              ),
            ),
          ),

          /// 전화번호
          TextField(
            controller: phoneNumberControllerDialog,
            // obscureText: false, // 비밀번호 안보이게

            style: TextStyle(color: normalColor),
            decoration: InputDecoration(
              labelText: "휴대폰번호",
              labelStyle: TextStyle(
                  color: phoneNumberFocusNodeDialog.hasFocus
                      ? focusColor
                      : normalColor),
              enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Palette.gray33, width: 0),
              ),
              focusColor: focusColor,
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: focusColor,
                ),
              ),
            ),
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly, //숫자만!
              NumberFormatter(), // 자동하이픈
              LengthLimitingTextInputFormatter(13) //13자리만 입력받도록 하이픈 2개+숫자 11개
            ],
            // inputFormatters: [
            //   FilteringTextInputFormatter.allow(RegExp('[0-9]'))
            // ],
          ),

          /// 이메일
          TextField(
            controller: emailControllerDialog,
            style: TextStyle(
                color: normalColor, fontSize: 14, letterSpacing: -0.33),
            decoration: InputDecoration(
              labelText: "이메일",
              labelStyle: TextStyle(
                  color:
                      emailFocusNodeDialog.hasFocus ? focusColor : normalColor),
              enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Palette.gray33, width: 0),
              ),
              focusColor: focusColor,
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: focusColor,
                ),
              ),
            ),
            keyboardType: TextInputType.emailAddress,
          ),

          /// 비밀번호
          TextField(
            controller: passwordControllerDialog,
            obscureText: !passwordVisible, //This will obscure text dynamically
            style: TextStyle(
                color: normalColor, fontSize: 14, letterSpacing: -0.33),
            // Here is key idea

            decoration: InputDecoration(
              suffixIcon: IconButton(
                icon: Icon(
                  size: 14,
                  // Based on passwordVisible state choose the icon
                  passwordVisible ? Icons.visibility : Icons.visibility_off,
                  color: Palette.gray66,
                ),
                onPressed: () {
                  // Update the state i.e. toogle the state of passwordVisible variable
                  setState(() {
                    passwordVisible = !passwordVisible;
                    debugPrint("체크");
                  });
                },
              ),
              labelText: "비밀번호",
              labelStyle: TextStyle(
                  color: passwordFocusNodeDialog.hasFocus
                      ? focusColor
                      : normalColor),
              enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Palette.gray33, width: 0),
              ),
              focusColor: focusColor,
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: focusColor,
                ),
              ),
            ),
            keyboardType: TextInputType.visiblePassword,
          ),
          const SizedBox(height: 10),

          /// 비밀번호 확인
          TextField(
            controller: passwordControllerConfirmDialog,
            obscureText: !passwordVisible, //This will obscure text dynamically
            style: TextStyle(
                color: normalColor, fontSize: 14, letterSpacing: -0.33),
            // Here is key idea

            decoration: InputDecoration(
              suffixIcon: IconButton(
                icon: Icon(
                  size: 14,
                  // Based on passwordVisible state choose the icon
                  passwordVisible ? Icons.visibility : Icons.visibility_off,
                  color: Palette.gray66,
                ),
                onPressed: () {
                  // Update the state i.e. toogle the state of passwordVisible variable
                  setState(() {
                    passwordVisible = !passwordVisible;
                    debugPrint("체크");
                  });
                },
              ),
              labelText: "비밀번호 확인",
              labelStyle: TextStyle(
                  color: passwordFocusNodeConfirmDialog.hasFocus
                      ? focusColor
                      : normalColor),
              enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Palette.gray33, width: 0),
              ),
              focusColor: focusColor,
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: focusColor,
                ),
              ),
            ),
            keyboardType: TextInputType.visiblePassword,
          ),
          const SizedBox(height: 35),
          const Text("개인정보 수집 및 활용에 동의하십니까?"),
          const SizedBox(height: 10),

          SizedBox(
            width: 200,
            child: Row(
              children: [
                const SizedBox(width: 10),
                Checkbox(
                    value: _isChecked,
                    onChanged: (value) {
                      setState(() {
                        _isChecked = value!;
                      });
                    }),
                const Text("네"),
              ],
            ),
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          child: const Text("확인"),
          onPressed: () {
            // 회원가입
            widget.authService.signUp(
              phoneNumber: phoneNumberControllerDialog.text,
              name: nameControllerDialog.text,
              isChecked: _isChecked,
              email: emailControllerDialog.text,
              password: passwordControllerDialog.text,
              onSuccess: () {
                Navigator.pop(context);

                // 회원가입 성공
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
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
      ],
    );
  }
}

class NumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    var text = newValue.text;

    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }

    var buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      var nonZeroIndex = i + 1;
      if (nonZeroIndex <= 3) {
        if (nonZeroIndex % 3 == 0 && nonZeroIndex != text.length) {
          buffer.write('-'); // Add double spaces.
        }
      } else {
        if (nonZeroIndex % 7 == 0 &&
            nonZeroIndex != text.length &&
            nonZeroIndex > 4) {
          buffer.write('-');
        }
      }
    }

    var string = buffer.toString();
    return newValue.copyWith(
        text: string,
        selection: TextSelection.collapsed(offset: string.length));
  }
}
