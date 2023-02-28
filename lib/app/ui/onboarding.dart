import 'package:amplitude_flutter/amplitude.dart';
import 'package:classmatch/app/controller/auth_service.dart';
import 'package:classmatch/app/routes/routes.dart';
import 'package:classmatch/app/ui/color.dart';
import 'package:classmatch/main.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:provider/provider.dart';

import '../controller/alarm_service.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({Key? key}) : super(key: key);

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
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
