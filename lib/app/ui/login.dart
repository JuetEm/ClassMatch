import 'package:classmatch/app/config/analytics_config.dart';
import 'package:classmatch/app/controller/alarm_service.dart';
import 'package:classmatch/app/controller/dialog_warning.dart';
import 'package:classmatch/app/controller/login_controller.dart';
import 'package:classmatch/app/ui/globa_widget.dart';
import 'package:classmatch/app/ui/onboarding.dart';
import 'package:classmatch/app/ui/service_over.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../../main.dart';
import '../controller/auth_service.dart';
import 'alarmlist.dart';
import 'color.dart';
import 'package:amplitude_flutter/amplitude.dart';

Color focusColor = const Color(0xFF615CFE);
Color normalColor = Palette.gray66;
// 소셜 로그인 Controller
LoginController loginController = LoginController();

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
                                    debugPrint(
                                        'isExpired: ${isExpired.toString()}');

                                    // Set user Id
                                    Analytics_config.analytics
                                        .setUserId(user.uid);

                                    final talkNameFromSever =
                                        alarmService.findtalkName(user.uid);
                                    talkNameFromSever.then((val) {
                                      // int가 나오면 해당 값을 출력
                                      debugPrint('처음서버값: $val');
                                      //해당 함수는 빌드가 끝난 다음 수행 된다.
                                      //https://velog.io/@jun7332568/%ED%94%8C%EB%9F%AC%ED%84%B0flutter-setState-or-markNeedsBuild-called-during-build.-%EC%98%A4%EB%A5%98-%ED%95%B4%EA%B2%B0
                                      // WidgetsBinding.instance!.addPostFrameCallback((_) {
                                      talkName = val;
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
                                            Amplitude.getInstance().logEvent(
                                                'PAGE_VIEW : ONBOARD');
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

                          /// 무료 체험 신청
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
                              //amplitude
                              Amplitude.getInstance()
                                  .logEvent('BTN_CLK : FREE TRIAL');
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

                          // /// 더미 DB 업그레이드 - 함부로 사용금지
                          // ElevatedButton(
                          //   style: ElevatedButton.styleFrom(
                          //     shape: RoundedRectangleBorder(
                          //       borderRadius: BorderRadius.circular(6),
                          //     ),
                          //     padding: const EdgeInsets.all(0),
                          //     elevation: 0,
                          //     backgroundColor: Palette.mainPoint,

                          //     minimumSize: const Size.fromHeight(50), // NEW
                          //   ),
                          //   onPressed: () {
                          //     // alarmService.syncdBupdate(
                          //     //     uid: 'WbUBzPLZF0ZmQ0Gct42du4HCQOV2');
                          //     // alarmService.syncdBupdate(
                          //     //     uid: 'WefdLhbRDvbN6fZ4io9gnyGPt6k1');
                          //     // alarmService.syncdBupdate(
                          //     //     uid: '3lBhM6IrHzO6eIFtRQR7oRE3DXm2');
                          //     // alarmService.syncdBupdate(
                          //     //     uid: 'EbxlRWoiXiSfikNnk1TOHBgt0eo2');
                          //     // alarmService.syncdBupdate(
                          //     //     uid: 'p3jUBepvweP5iAZzAdrvAwbOHZH2');
                          //     // alarmService.syncdBupdate(
                          //     //     uid: 'njPTk7ecrsU2RhV1c27gfqTx3Pz1');
                          //     // alarmService.syncdBupdate(
                          //     //     uid: 'LCnNOTXlxeWNURDM0S4rFAJLxME2');
                          //     // alarmService.syncdBupdate(
                          //     //     uid: 'KenypIS6fBZRHhAxhxc0gyzYPMI3');
                          //     // alarmService.syncdBupdate(
                          //     //     uid: 'rWMXiRVJf2VWvIs09gQpfIhdgwu1');
                          //     // alarmService.syncdBupdate(
                          //         // uid: 'fiFy9TfyJyTM1q8bpC8bBKvzcwi1');
                          //   },
                          //   child: const Padding(
                          //     padding: EdgeInsets.all(14.0),
                          //     child: Text("더미 회원DB 업데이트",
                          //         style: TextStyle(
                          //           fontSize: 16,
                          //           letterSpacing: -0.33,
                          //         )),
                          //   ),
                          // ),

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

                          // /// 카카오로 로그인
                          // ElevatedButton(
                          //     child: const Text("카카오 로그인",
                          //         style: TextStyle(fontSize: 21)),
                          //     onPressed: () async {
                          //       if (await isKakaoTalkInstalled()) {
                          //         try {
                          //           await UserApi.instance.loginWithKakaoTalk();
                          //           print('카카오톡으로 로그인 성공');
                          //           // _get_user_info();
                          //           // HomePage로 이동
                          //           Navigator.pushReplacement(
                          //             context,
                          //             MaterialPageRoute(
                          //                 builder: (context) =>
                          //                     const ArlamListPage()),
                          //           );
                          //         } catch (error) {
                          //           print('카카오톡으로 로그인 실패 $error');
                          //           // 카카오톡에 연결된 카카오계정이 없는 경우, 카카오계정으로 로그인
                          //           try {
                          //             await UserApi.instance
                          //                 .loginWithKakaoAccount();
                          //             print('카카오계정으로 로그인 성공');
                          //             // _get_user_info();
                          //             // HomePage로 이동
                          //             Navigator.pushReplacement(
                          //               context,
                          //               MaterialPageRoute(
                          //                   builder: (context) =>
                          //                       const ArlamListPage()),
                          //             );
                          //           } catch (error) {
                          //             print('카카오계정으로 로그인 실패 $error');
                          //           }
                          //         }
                          //       } else {
                          //         try {
                          //           await UserApi.instance
                          //               .loginWithKakaoAccount();
                          //           print('카카오계정으로 로그인 성공');
                          //           // _get_user_info();
                          //           // HomePage로 이동
                          //           Navigator.pushReplacement(
                          //             context,
                          //             MaterialPageRoute(
                          //                 builder: (context) =>
                          //                     const ArlamListPage()),
                          //           );
                          //         } catch (error) {
                          //           print('카카오계정으로 로그인 실패 $error');
                          //         }
                          //       }
                          //     }),

                          // // 카카오톡으로 로그인 버튼
                          // ElevatedButton(
                          //   style: ElevatedButton.styleFrom(
                          //     shape: RoundedRectangleBorder(
                          //       borderRadius: BorderRadius.circular(10),
                          //     ),
                          //     padding: const EdgeInsets.all(0),
                          //     elevation: 0,
                          //     backgroundColor: Palette.buttonKakao,
                          //   ),
                          //   onPressed: () async {
                          //     try {
                          //       // web 방식 로그인 구현
                          //       print("JAVASCRIPT - 카카오톡으로 로그인 시작");
                          //       loginController.kakaoSignIn().then(
                          //         (value) {
                          //           print("value : $value");
                          //           // 서버에서 한번 읽어 와야함.
                          //           final user = context
                          //               .read<AuthService>()
                          //               .currentUser();
                          //           // 종료결과 불러오기
                          //           final getUserInfoFromServer =
                          //               alarmService.getUserInfo(user!.uid);
                          //           getUserInfoFromServer.then((val) {
                          //             // int가 나오면 해당 값을 출력
                          //             // debugPrint('val: $val');
                          //             isExpired = val;
                          //             prefs.setBool("isExpired", isExpired);
                          //             debugPrint(
                          //                 'isExpired: ${isExpired.toString()}');

                          //             // Set user Id
                          //             Analytics_config.analytics
                          //                 .setUserId(user.uid);

                          //             final talkNameFromSever =
                          //                 alarmService.findtalkName(user.uid);
                          //             talkNameFromSever.then((val) {
                          //               // int가 나오면 해당 값을 출력
                          //               debugPrint('처음서버값: $val');
                          //               //해당 함수는 빌드가 끝난 다음 수행 된다.
                          //               //https://velog.io/@jun7332568/%ED%94%8C%EB%9F%AC%ED%84%B0flutter-setState-or-markNeedsBuild-called-during-build.-%EC%98%A4%EB%A5%98-%ED%95%B4%EA%B2%B0
                          //               // WidgetsBinding.instance!.addPostFrameCallback((_) {
                          //               talkName = val;
                          //               //amplitude
                          //               Amplitude.getInstance()
                          //                   .logEvent('PAGE_VIEW : LOGIN');

                          //               // 로그인 성공
                          //               Navigator.pushReplacement(
                          //                 context,
                          //                 MaterialPageRoute(builder: (_) {
                          //                   if (isExpired) {
                          //                     //amplitude
                          //                     Amplitude.getInstance().logEvent(
                          //                         'PAGE_VIEW : SERVICE_OVER');
                          //                     return const ServiceOverPage();
                          //                   } else if (isOnboarded) {
                          //                     //amplitude
                          //                     Amplitude.getInstance()
                          //                         .logEvent('PAGE_VIEW : LIST');
                          //                     return const ArlamListPage();
                          //                   } else {
                          //                     //amplitude
                          //                     Amplitude.getInstance().logEvent(
                          //                         'PAGE_VIEW : ONBOARD');
                          //                     return const OnboardingPage();
                          //                   }
                          //                 }),
                          //                 // => isExpired
                          //                 //     ? const ServiceOverPage()
                          //                 //     : isOnboarded
                          //                 //         ? const ArlamListPage()
                          //                 //         : const OnboardingPage()),
                          //               );
                          //             }).catchError((error) {
                          //               // error가 해당 에러를 출력
                          //               debugPrint('error: $error');
                          //             });
                          //           }).catchError((error) {
                          //             // error가 해당 에러를 출력
                          //             debugPrint('error: $error');
                          //           });
                          //         },
                          //       );
                          //     } catch (error) {
                          //       print('카카오톡으로 로그인 실패 - error : $error');
                          //     }
                          //   },
                          //   child: Padding(
                          //     padding: const EdgeInsets.all(14.0),
                          //     child: SizedBox(
                          //       child: Row(
                          //         mainAxisAlignment: MainAxisAlignment.center,
                          //         children: [
                          //           SizedBox(
                          //               child: Image.asset(
                          //                   "assets/images/kakao.png")),
                          //           const SizedBox(width: 5),
                          //           const Text("카카오로 로그인하기",
                          //               style: TextStyle(
                          //                   fontSize: 16,
                          //                   color: Palette.gray00)),
                          //         ],
                          //       ),
                          //     ),
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  ),

                  // ElevatedButton(
                  //   onPressed: () async {
                  //     debugPrint("카톡로그인 버튼 클릭");
                  //     await viewModel.login();
                  //     debugPrint("카톡로그인 버튼 클릭 - 로그인 수행 끝");
                  //     // Navigator.of(context).pushNamed(Routes.favareaSelect);
                  //     setState(() {});
                  //   },
                  //   child: const Text('Login'),
                  // ),
                  // ElevatedButton(
                  //   onPressed: () async {
                  //     debugPrint("카톡로그아웃 버튼 클릭");
                  //     await viewModel.logout();
                  //     debugPrint("카톡로그아웃 버튼 클릭 - 로그인 수행 끝");
                  //     setState(() {});
                  //   },
                  //   child: const Text('Logout'),
                  // ),
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
  FocusNode checkedBocFocusNode = FocusNode();
  bool passwordVisible = false;
  bool _isChecked = false;

  final GlobalKey emailKey = GlobalKey();
  final GlobalKey nameKey = GlobalKey();
  final GlobalKey phoneKey = GlobalKey();
  final GlobalKey passwordKey = GlobalKey();
  final GlobalKey passwordConbfirmKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    debugPrint(passwordVisible.toString());
    final controller = Get.put(DialogWarning());

    return SingleChildScrollView(
      child: AlertDialog(
        // RoundedRectangleBorder - Dialog 화면 모서리 둥글게 조절
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),

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
              focusNode: nameFocusNodeDialog,
              onSubmitted: (value) {
                phoneNumberFocusNodeDialog.requestFocus();
              },
              controller: nameControllerDialog,
              // obscureText: false, // 비밀번호 안보이게
              style: TextStyle(
                  color: normalColor, fontSize: 14, letterSpacing: -0.33),
              decoration: InputDecoration(
                labelText: "이름",
                labelStyle: TextStyle(
                    color: nameFocusNodeDialog.hasFocus
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
            ),

            /// 전화번호
            TextField(
              focusNode: phoneNumberFocusNodeDialog,
              onSubmitted: (value) {
                emailFocusNodeDialog.requestFocus();
              },
              controller: phoneNumberControllerDialog,
              // obscureText: false, // 비밀번호 안보이게

              style: TextStyle(
                  color: normalColor, fontSize: 14, letterSpacing: -0.33),
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
              focusNode: emailFocusNodeDialog,
              onSubmitted: (value) {
                passwordFocusNodeDialog.requestFocus();
              },
              controller: emailControllerDialog,
              style: TextStyle(
                  color: normalColor, fontSize: 14, letterSpacing: -0.33),
              decoration: InputDecoration(
                labelText: "이메일",
                labelStyle: TextStyle(
                    color: emailFocusNodeDialog.hasFocus
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
              keyboardType: TextInputType.emailAddress,
            ),

            /// 비밀번호
            TextFormField(
              focusNode: passwordFocusNodeDialog,
              onFieldSubmitted: (value) {
                passwordFocusNodeConfirmDialog.requestFocus();
              },
              key: passwordKey,
              controller: passwordControllerDialog,
              obscureText:
                  !passwordVisible, //This will obscure text dynamically
              style: TextStyle(
                  color: normalColor, fontSize: 14, letterSpacing: -0.33),
              // Here is key idea
              validator: (value) {
                if (value!.isEmpty) {
                  return "Please enter password";
                }
                return null;
              },
              // onChanged: (value) {
              //   if (passwordKey.currentState!.validate()) {
              //     // If the form is valid, display a snackbar. In the real world,
              //     // you'd often call a server or save the information in a database.
              //     ScaffoldMessenger.of(context).showSnackBar(
              //       const SnackBar(content: Text('Processing Data')),
              //     );
              //   }
              // },

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
            const Text("비밀번호는 6자리 이상 입력해주세요",
                style: TextStyle(
                    color: Palette.gray66, fontSize: 12, letterSpacing: -0.33)),
            const SizedBox(height: 10),

            /// 비밀번호 확인
            TextFormField(
              focusNode: passwordFocusNodeConfirmDialog,
              onFieldSubmitted: (value) {
                checkedBocFocusNode.requestFocus();
              },
              controller: passwordControllerConfirmDialog,
              obscureText:
                  !passwordVisible, //This will obscure text dynamically
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

            const SizedBox(height: 10),
            const Text("개인정보 수집 및 활용에 동의하십니까?",
                style: TextStyle(
                    color: Palette.gray66, fontSize: 12, letterSpacing: -0.33)),
            const SizedBox(height: 10),

            SizedBox(
              width: 200,
              child: Row(
                children: [
                  const SizedBox(width: 10),
                  Checkbox(
                      focusNode: checkedBocFocusNode,
                      value: _isChecked,
                      onChanged: (value) {
                        setState(() {
                          _isChecked = value!;
                        });
                      }),
                  const Text("네",
                      style: TextStyle(
                          color: Palette.gray66,
                          fontSize: 12,
                          letterSpacing: -0.33)),
                ],
              ),
            ),
            const SizedBox(height: 5),
            SizedBox(
              child: Obx(() {
                return Text(controller.message.value,
                    overflow: TextOverflow.clip,
                    maxLines: 30,
                    style: const TextStyle(
                        color: Palette.textRed,
                        fontSize: 14,
                        letterSpacing: -0.33));
              }),
            ),
          ],
        ),
        actions: <Widget>[
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    child: const Text("취소",
                        style: TextStyle(
                            color: Palette.gray66,
                            fontSize: 16,
                            letterSpacing: -0.33)),
                    onPressed: () {
                      //amplitude
                      Amplitude.getInstance().logEvent('BTN_CLK : CANCEL');
                      Navigator.pop(context);
                    },
                  ),
                  // TextButton(
                  //   child: const Text("경고"),
                  //   onPressed: () {
                  //     controller.message.value = "경고입니다.";
                  //   },
                  // ),
                  TextButton(
                    child: const Text("확인",
                        style: TextStyle(
                            color: Palette.gray66,
                            fontSize: 16,
                            letterSpacing: -0.33)),
                    onPressed: () {
                      // 회원가입
                      widget.authService.signUp(
                        phoneNumber: phoneNumberControllerDialog.text,
                        name: nameControllerDialog.text,
                        isChecked: _isChecked,
                        email: emailControllerDialog.text,
                        password: passwordControllerDialog.text,
                        confirmpassword: passwordControllerConfirmDialog.text,
                        onSuccess: () {
                          Navigator.pop(context);
                          //amplitude
                          Amplitude.getInstance()
                              .logEvent('EVENT : 7FREE JOIN');
                          // controller.message.value = "무료 체험 신청이 완료 되어었습니다.";

                          // // 회원가입 성공
                          // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          //   content: Text("회원가입 성공"),
                          // ));
                        },
                        onError: (err) {
                          controller.message.value = err;
                          // // 에러 발생
                          // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          //   content: Text(err),
                          // ));
                        },
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ],
      ),
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

// void loginWithCurrentUser(FB.User? cUser, BuildContext context) {
//   Future<List> resultFirstMemberList =
//       memberService.readMemberListAtFirstTime(cUser!.uid);

//   resultFirstMemberList.then((value) {
//     print(
//         "resultFirstMemberList then is called!! value.length : ${value.length}");
//     globalVariables.resultList = [];
//     globalVariables.resultList.addAll(value);
//     /* for (int i = 0; i < value.length; i++) {
//         print("value[${i}] : ${value[i]}");
//       } */
//   }).onError((error, stackTrace) {
//     print("error : ${error}");
//     print("stackTrace : \r\n${stackTrace}");
//   }).whenComplete(() async {
//     print("memberList await init complete!");

//     Future<List> resultFirstActionList =
//         actionService.readActionListAtFirstTime(cUser.uid);

//     resultFirstActionList.then((value) {
//       print(
//           "3. resultFirstActionList then is called!! value.length : ${value.length}");
//       globalVariables.actionList = [];
//       globalVariables.actionList.addAll(value);
//     }).onError((error, stackTrace) {
//       print("error : ${error}");
//       print("stackTrace : \r\n${stackTrace}");
//     }).whenComplete(() async {
//       print("actionList await init complete!");

//       await ticketLibraryService.read(cUser.uid).then((value) {
//         globalVariables.ticketLibraryList.addAll(value);
//       }).onError((error, stackTrace) {
//         print("error : ${error}");
//         print("stackTrace : \r\n${stackTrace}");
//       }).whenComplete(() async {
//         print("ticketLibraryList await init complete!");

//         await memberTicketService.read(cUser.uid).then((value) {
//           globalVariables.memberTicketList.addAll(value);
//         }).onError((error, stackTrace) {
//           print("error : ${error}");
//           print("stackTrace : \r\n${stackTrace}");
//         }).whenComplete(() {
//           print("memberTicketList await init complete!");
//           // 로그인 성공
//           ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//             content: Text("로그인 성공"),
//           ));
//           // 로그인 성공시 Home로 이동
//           /*  Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (_) => MemberList()),
//         //MaterialPageRoute(builder: (_) => Mainpage()),
//       ); */
//           List<dynamic> args = [
//             globalVariables.resultList,
//             globalVariables.actionList
//           ];
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => MemberList(),
//               // setting에서 arguments로 다음 화면에 회원 정보 넘기기
//               settings: RouteSettings(arguments: args),
//             ),
//           );

//           emailController.clear();
//           passwordController.clear();
//         });
//       });
//     });
//   });
// }
