import 'package:amplitude_flutter/amplitude.dart';
import 'package:classmatch/app/controller/auth_service.dart';
import 'package:classmatch/app/routes/routes.dart';
import 'package:classmatch/app/ui/color.dart';
import 'package:classmatch/main.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:provider/provider.dart';

import '../controller/alarm_service.dart';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({Key? key}) : super(key: key);

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  @override
  void initState() {
    final alarmService = context.read<AlarmService>();
    final authService = context.read<AuthService>();
    final user = authService.currentUser();
    // 프로필 아이디
    final talkNameFromSever = alarmService.findtalkName(user!.uid);
    talkNameFromSever.then((val) {
      // int가 나오면 해당 값을 출력
      debugPrint('처음서버값: $val');
      //해당 함수는 빌드가 끝난 다음 수행 된다.
      //https://velog.io/@jun7332568/%ED%94%8C%EB%9F%AC%ED%84%B0flutter-setState-or-markNeedsBuild-called-during-build.-%EC%98%A4%EB%A5%98-%ED%95%B4%EA%B2%B0
      // WidgetsBinding.instance!.addPostFrameCallback((_) {
      talkName = val;
    }).catchError((error) {
      // error가 해당 에러를 출력
      debugPrint('error: $error');
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final authService = context.read<AuthService>();
    final user = authService.currentUser();
    final alarmService = context.read<AlarmService>();
    return Scaffold(
      backgroundColor: Palette.secondaryBackground,
      body: IntroductionScreen(
        globalBackgroundColor: Palette.secondaryBackground,
        baseBtnStyle: TextButton.styleFrom(
          foregroundColor: Palette.gray95,
          // surfaceTintColor: Palette.gray95,
        ),
        dotsDecorator: DotsDecorator(
          size: const Size.square(10.0),
          activeSize: const Size(20.0, 10.0),
          activeColor: Palette.gray66,
          color: Palette.gray95,
          spacing: const EdgeInsets.symmetric(horizontal: 3.0),
          activeShape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
        ),
        // dotsDecorator: const DotsDecorator(
        //   color: Palette.grayF5,
        //   activeColor: Palette.gray66,
        // ),
        pages: [
          // 0번째 페이지
          PageViewModel(
            titleWidget: const SizedBox(height: 1),
            bodyWidget: Column(
              children: [
                Image.asset(
                  'assets/images/onboarding0.png',
                  width: 340,
                ),
                const SizedBox(height: 20),
                Text(
                  '프로필 이름을 $talkName로 입장해주세요',
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Palette.mainPoint,
                        letterSpacing: -0.33,
                      ),
                ),
                Text(
                  '참여번호 : 2580',
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Palette.mainPoint,
                        letterSpacing: -0.33,
                      ),
                ),
                const SizedBox(height: 20),
                Container(
                  margin: const EdgeInsets.only(left: 10, right: 10),
                  decoration: BoxDecoration(
                      border: Border.all(color: Palette.grayB4, width: 1),
                      borderRadius: BorderRadius.circular(10)),
                  width: 250,
                  height: 50,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(10),
                    onTap: () {
                      //amplitude
                      Amplitude.getInstance().logEvent('BTN_CLK : OPNCHAT_ENT',
                          eventProperties: {"AREA": "서울"});
                      html.window
                          .open('https://open.kakao.com/o/g7mDXV5e', 'new tab');
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: const [
                        Text(
                          "서울 대강 알림 오픈채팅방",
                          style: TextStyle(
                            fontSize: 16,
                            color: Palette.gray66,
                            letterSpacing: -0.33,
                          ),
                        ),
                        SizedBox(width: 10),
                        Icon(
                          Icons.arrow_circle_right,
                          color: Palette.gray66,
                          size: 22,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  margin: const EdgeInsets.only(left: 10, right: 10),
                  decoration: BoxDecoration(
                      border: Border.all(color: Palette.grayB4, width: 1),
                      borderRadius: BorderRadius.circular(10)),
                  width: 250,
                  height: 50,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(10),
                    onTap: () {
                      //amplitude
                      Amplitude.getInstance().logEvent('BTN_CLK : OPNCHAT_ENT',
                          eventProperties: {"AREA": "경기"});

                      html.window
                          .open('https://open.kakao.com/o/gMXiLn6e', 'new tab');
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: const [
                        Text(
                          "경기 대강 알림 오픈채팅방",
                          style: TextStyle(
                            fontSize: 16,
                            color: Palette.gray66,
                            letterSpacing: -0.33,
                          ),
                        ),
                        SizedBox(width: 10),
                        Icon(
                          Icons.arrow_circle_right,
                          color: Palette.gray66,
                          size: 22,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  margin: const EdgeInsets.only(left: 10, right: 10),
                  decoration: BoxDecoration(
                      border: Border.all(color: Palette.grayB4, width: 1),
                      borderRadius: BorderRadius.circular(10)),
                  width: 250,
                  height: 50,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(10),
                    onTap: () {
                      //amplitude
                      Amplitude.getInstance().logEvent('BTN_CLK : OPNCHAT_ENT',
                          eventProperties: {"AREA": "인천"});
                      html.window
                          .open('https://open.kakao.com/o/ggS2Op6e', 'new tab');
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: const [
                        Text(
                          "인천 대강 알림 오픈채팅방",
                          style: TextStyle(
                            fontSize: 16,
                            color: Palette.gray66,
                            letterSpacing: -0.33,
                          ),
                        ),
                        SizedBox(width: 10),
                        Icon(
                          Icons.arrow_circle_right,
                          color: Palette.gray66,
                          size: 22,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  margin: const EdgeInsets.only(left: 10, right: 10),
                  decoration: BoxDecoration(
                      border: Border.all(color: Palette.grayB4, width: 1),
                      borderRadius: BorderRadius.circular(10)),
                  width: 250,
                  height: 50,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(10),
                    onTap: () {
                      //amplitude
                      Amplitude.getInstance().logEvent('BTN_CLK : OPNCHAT_ENT',
                          eventProperties: {"AREA": "기타"});
                      html.window
                          .open('https://open.kakao.com/o/g2vOPp6e', 'new tab');
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: const [
                        Text(
                          "기타 대강 알림 오픈채팅방",
                          style: TextStyle(
                            fontSize: 16,
                            color: Palette.gray66,
                            letterSpacing: -0.33,
                          ),
                        ),
                        SizedBox(width: 10),
                        Icon(
                          Icons.arrow_circle_right,
                          color: Palette.gray66,
                          size: 22,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            decoration: const PageDecoration(
              titlePadding: EdgeInsets.all(0),
              contentMargin: EdgeInsets.all(0),
              bodyFlex: 100,
              // imageFlex: 10,
              // imageAlignment: Alignment.topCenter,
              bodyAlignment: Alignment.topCenter,
              fullScreen: true,
              titleTextStyle: TextStyle(
                color: Palette.mainPoint,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              bodyTextStyle: TextStyle(
                color: Colors.black,
                fontSize: 18,
              ),
            ),
          ),
          // 첫번째 페이지
          PageViewModel(
            titleWidget: const SizedBox(height: 1),
            bodyWidget: Image.asset(
              'assets/images/onboarding1.png',
              width: 340,
              // height: 4000,
              // fit: BoxFit.cover,
            ),
            decoration: const PageDecoration(
              titlePadding: EdgeInsets.all(0),
              contentMargin: EdgeInsets.all(0),
              bodyFlex: 100,
              // imageFlex: 10,
              // imageAlignment: Alignment.topCenter,
              bodyAlignment: Alignment.topCenter,
              fullScreen: true,
              titleTextStyle: TextStyle(
                color: Palette.mainPoint,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              bodyTextStyle: TextStyle(
                color: Colors.black,
                fontSize: 18,
              ),
            ),
          ),
          // 두번째 페이지
          PageViewModel(
            titleWidget: const SizedBox(height: 1),
            bodyWidget: Image.asset(
              'assets/images/onboarding2.png',
              width: 340,
              // height: 4000,
              // fit: BoxFit.cover,
            ),
            decoration: const PageDecoration(
              titlePadding: EdgeInsets.all(0),
              contentMargin: EdgeInsets.all(0),
              bodyFlex: 100,
              // imageFlex: 10,
              // imageAlignment: Alignment.topCenter,
              bodyAlignment: Alignment.topCenter,
              fullScreen: true,
              titleTextStyle: TextStyle(
                color: Palette.mainPoint,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              bodyTextStyle: TextStyle(
                color: Colors.black,
                fontSize: 18,
              ),
            ),
          ),
          // 세번째 페이지
          PageViewModel(
            titleWidget: const SizedBox(height: 1),
            bodyWidget: Image.asset(
              'assets/images/onboarding3.png',
              width: 340,
              // height: 4000,
              // fit: BoxFit.cover,
            ),
            decoration: const PageDecoration(
              titlePadding: EdgeInsets.all(0),
              contentMargin: EdgeInsets.all(0),
              bodyFlex: 100,
              // imageFlex: 10,
              // imageAlignment: Alignment.topCenter,
              bodyAlignment: Alignment.topCenter,
              fullScreen: true,
              titleTextStyle: TextStyle(
                color: Palette.mainPoint,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              bodyTextStyle: TextStyle(
                color: Colors.black,
                fontSize: 18,
              ),
            ),
          ),
          // 네번째 페이지
          PageViewModel(
            titleWidget: const SizedBox(height: 1),
            bodyWidget: Image.asset(
              'assets/images/onboarding4.png',
              width: 340,
              // height: 4000,
              // fit: BoxFit.cover,
            ),
            decoration: const PageDecoration(
              titlePadding: EdgeInsets.all(0),
              contentMargin: EdgeInsets.all(0),
              bodyFlex: 100,
              // imageFlex: 10,
              // imageAlignment: Alignment.topCenter,
              bodyAlignment: Alignment.topCenter,
              fullScreen: true,
              titleTextStyle: TextStyle(
                color: Palette.mainPoint,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              bodyTextStyle: TextStyle(
                color: Colors.black,
                fontSize: 18,
              ),
            ),
          ),
          // 다섯번째 페이지
          PageViewModel(
            titleWidget: const SizedBox(height: 1),
            bodyWidget: Image.asset(
              'assets/images/onboarding5.png',
              width: 340,
              // height: 4000,
              // fit: BoxFit.cover,
            ),
            decoration: const PageDecoration(
              titlePadding: EdgeInsets.all(0),
              contentMargin: EdgeInsets.all(0),
              bodyFlex: 100,
              // imageFlex: 10,
              // imageAlignment: Alignment.topCenter,
              bodyAlignment: Alignment.topCenter,
              fullScreen: true,
              titleTextStyle: TextStyle(
                color: Palette.mainPoint,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              bodyTextStyle: TextStyle(
                color: Colors.black,
                fontSize: 18,
              ),
            ),
          ),
        ],
        next: const Text("다음",
            style: TextStyle(
              color: Palette.gray33,
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.33,
            )),
        done: const Text("완료",
            style: TextStyle(
              color: Palette.gray33,
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.33,
            )),
        onDone: () {
          setState(() {
            flutterDialogAlarm(
                context, "카카오톡 알람설정을 완료하셨나요.?", alarmService, user!.uid);
            // print("백그라운드로 울립니까.??");
          });
        },
      ),
    );
  }
}

void flutterDialogAlarm(context, bodytext, service, userid) {
  showDialog(
      context: context,
      //barrierDismissible - Dialog를 제외한 다른 화면 터치 x
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          // RoundedRectangleBorder - Dialog 화면 모서리 둥글게 조절
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          //Dialog Main Title
          // title: Column(
          //   children: <Widget>[
          //     new Text("Dialog Title"),
          //   ],
          // ),
          //
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                bodytext,
              ),
            ],
          ),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  child: const Text("네"),
                  onPressed: () {
                    // Navigator.pop(context);
                    // Done 클릭시 isOnboarded = true로 저장
                    prefs.setBool("isOnboarded", true);

                    //amplitude
                    Amplitude.getInstance().logEvent('ONBOARDING_END',
                        eventProperties: {"Alarm Set": "OK"});

                    // 서버에 온보딩 정보 저장
                    service.updateOnboardChk(
                      uid: userid,
                      onBoarding: true,
                      onSuccess: () {},
                      onError: (err) {
                        // 에러 발생
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(err),
                        ));
                      },
                    );
                    // 서버에 알람체크 정보 저장
                    service.updateAlarmChk(
                      uid: userid,
                      alarmChk: true,
                      onSuccess: () {
                        // // Done 클릭시 페이지 이동
                        // Navigator.pushReplacement(
                        //   context,
                        //   MaterialPageRoute(
                        //       builder: (context) => const ArlamListPage()),
                        // );
                        //amplitude
                        Amplitude.getInstance().logEvent('ONBOARDING_END',
                            eventProperties: {"Alarm Set": "NO"});
                        Navigator.pushNamedAndRemoveUntil(
                            context, Routes.arlamList, (_) => false);
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
                const Spacer(),
                TextButton(
                  child: const Text("아니요. 다음에 할께요."),
                  onPressed: () {
                    // Navigator.pop(context);
                    // Done 클릭시 isOnboarded = true로 저장
                    prefs.setBool("isOnboarded", true);

                    // 서버에 온보딩 정보 저장
                    service.updateOnboardChk(
                      uid: userid,
                      onBoarding: true,
                      onSuccess: () {
                        // // Done 클릭시 페이지 이동
                        // Navigator.pushReplacement(
                        //   context,
                        //   MaterialPageRoute(
                        //       builder: (context) => const ArlamListPage()),
                        // );

                        Navigator.pushNamedAndRemoveUntil(
                            context, Routes.arlamList, (_) => false);
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
            ),
          ],
        );
      });
  // return void;
}
