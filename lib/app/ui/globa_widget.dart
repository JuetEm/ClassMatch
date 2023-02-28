import 'package:flutter/material.dart';
import 'color.dart';

AppBar mainAppBarMethod(BuildContext context, String pageName) {
  return AppBar(
    elevation: 0,
    backgroundColor: Palette.mainBackground,
    title: Text(
      pageName,
      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            color: Palette.gray00,
            letterSpacing: -0.33,
          ),
    ),
    centerTitle: true,
    // leading: IconButton(
    //   onPressed: () {},
    //   icon: Icon(Icons.calendar_month),
    // ),
    actions: [
      IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () => Scaffold.of(context).openDrawer()),

      // TextButton(
      //   child: const Text(
      //     "로그아웃",
      //     style: TextStyle(
      //       color: Colors.black,
      //     ),
      //   ),
      //   onPressed: () {
      //     // 로그아웃
      //     context.read<AuthService>().signOut();

      //     // 로그인 페이지로 이동
      //     Navigator.pushReplacement(
      //       context,
      //       MaterialPageRoute(builder: (context) => const LoginPage()),
      //     );
      //   },
      // ),
      // const SizedBox(width: 10),
      // TextButton(
      //   child: const Text(
      //     "온보딩초기화",
      //     style: TextStyle(
      //       color: Colors.black,
      //     ),
      //   ),
      //   onPressed: () {
      //     prefs.clear();
      //   },
      // ),

      // IconButton(
      //   onPressed: () {
      //     print('profile');
      //     // 로그인 페이지로 이동
      //     Navigator.pushReplacement(
      //       context,
      //       MaterialPageRoute(builder: (context) => LoginPage()),
      //     );
      //   },
      //   color: Palette.gray33,
      //   icon: Icon(Icons.account_circle),
      // ),
      // IconButton(
      //   onPressed: () {
      //     _openEndDrawer();
      //   },
      //   icon: Icon(Icons.menu),
      // ),
    ],
  );
}

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}
