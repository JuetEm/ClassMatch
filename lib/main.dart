import 'package:amplitude_flutter/identify.dart';
import 'package:classmatch/app/config/analytics_config.dart';
import 'package:classmatch/app/landing/landing_controller.dart';
import 'package:classmatch/app/routes/routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app/controller/auth_service.dart';
import 'app/controller/bucket_service.dart';
import 'app/controller/alarm_service.dart';
import 'app/ui/alarmlist.dart';
import 'app/ui/login.dart';
import 'firebase_options.dart';
import 'app/controller/notification_controller.dart';

late SharedPreferences prefs;
bool isLogInActiveChecked = false;
bool isExpired = prefs.getBool("isExpired") ?? false;
bool isOnboarded = prefs.getBool("isOnboarded") ?? false;

late TextEditingController emailController;
late TextEditingController passwordController;

late TextEditingController emailControllerDialog;
late TextEditingController passwordControllerDialog;

TextEditingController switchController =
    TextEditingController(text: "로그인 정보 기억하기");

String? userEmail;
String? userPassword;

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // main 함수에서 async 사용하기 위함
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // firebase 앱 시작

  // runApp() 호출 전 Flutter SDK 초기화
  KakaoSdk.init(
    nativeAppKey: '373f18bbec60b8e2d754cdb63ff12b32',
    javaScriptAppKey: '2ec57d1e5f1bdf8d161173e5086b828d',
  );

  prefs = await SharedPreferences.getInstance();

  isLogInActiveChecked = prefs.getBool("isLogInActiveChecked") ?? false;
  userEmail = prefs.getString("userEmail");
  userPassword = prefs.getString("userPassword");
  // print("prefs check isLogInActiveChecked : ${isLogInActiveChecked}");
  // print("prefs check userEmail : ${userEmail}");
  // print("prefs check userPassword : ${userPassword}");

  //amplitude
  Analytics_config().init(); //여기 선언

  final Identify identify = Identify();
  Analytics_config.analytics.identify(identify);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthService()),
        ChangeNotifierProvider(create: (context) => BucketService()),
        ChangeNotifierProvider(create: (context) => AlarmService()),
        ChangeNotifierProvider(create: (context) => LandingService()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = context.read<AuthService>().currentUser();

    return GetMaterialApp(
      title: '클래스매치 대강알림',
      routes: Routes.routes,
      theme: ThemeData(
        fontFamily: 'Noto_Sans',
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialBinding: BindingsBuilder(
        () {
          Get.put(NotificationController());
        },
      ),
      debugShowCheckedModeBanner: false,
      home: Obx(() {
        // 메시지를 받으면 새로운 화면으로 전화하는 조건문
        if (NotificationController.to.remoteMessage.value.messageId != null) {
          //message
          // print("메시지 출력");
          return const ArlamListPage();
        }
        return user == null ? const LoginPage() : const ArlamListPage();
        // return user == null ? LoginPage() : MessagePage();
      }),
    );
  }
}
