import 'package:amplitude_flutter/amplitude.dart';
import 'package:classmatch/app/controller/auth_service.dart';
import 'package:classmatch/app/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'color.dart';

class NavBar extends StatelessWidget {
  const NavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Palette.grayFA,
      child: ListView(
        // Remove padding
        padding: EdgeInsets.zero,
        children: [
          // UserAccountsDrawerHeader(
          //   accountName: Text('Oflutter.com'),
          //   accountEmail: Text('example@gmail.com'),
          //   currentAccountPicture: CircleAvatar(
          //     child: ClipOval(
          //       child: Image.network(
          //         'https://oflutter.com/wp-content/uploads/2021/02/girl-profile.png',
          //         fit: BoxFit.cover,
          //         width: 90,
          //         height: 90,
          //       ),
          //     ),
          //   ),
          //   decoration: BoxDecoration(
          //     color: Colors.blue,
          //     image: DecorationImage(
          //         fit: BoxFit.fill,
          //         image: NetworkImage(
          //             'https://oflutter.com/wp-content/uploads/2021/02/profile-bg3.jpg')),
          //   ),
          // ),
          // ListTile(
          //   // leading: const Icon(Icons.favorite),
          //   title: Text(
          //     "",
          //     style: Theme.of(context).textTheme.bodyLarge!.copyWith(
          //           fontSize: 14.0,
          //           fontWeight: FontWeight.bold,
          //           color: Palette.gray00,
          //         ),
          //   ),
          //   // onTap: () => null,
          // ),
          ListTile(
              // leading: const Icon(Icons.favorite),
              title: Text(
                "관심 지역 등록",
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                      color: Palette.gray00,
                      letterSpacing: -0.33,
                    ),
              ),

              // title: Text(
              //   "관심 지역 등록",
              //   style: Theme.of(context).textTheme.bodyLarge!.copyWith(
              //         fontSize: 14.0,
              //         fontWeight: FontWeight.bold,
              //         color: Palette.gray00,
              //       ),
              // ),
              // ignore: avoid_returning_null_for_void
              onTap: () {
                //amplitude
                Amplitude.getInstance().logEvent('PAGE_VIEW : AREASELECT');
                Navigator.of(context).pushNamed(Routes.favareaSelect);
              }),
          // ListTile(
          //   // leading: const Icon(Icons.favorite),
          //   title: Text(
          //     "지역별 알림 창 : 경기 남부",
          //     style: Theme.of(context).textTheme.bodyLarge!.copyWith(
          //           fontSize: 14.0,
          //           fontWeight: FontWeight.bold,
          //           color: Palette.gray00,
          //         ),
          //   ),
          //   // ignore: avoid_returning_null_for_void
          //   onTap: () => null,
          // ),
          // ListTile(
          //   // leading: const Icon(Icons.favorite),
          //   title: Text(
          //     "지역별 알림 창 : 경기 북부",
          //     style: Theme.of(context).textTheme.bodyLarge!.copyWith(
          //           fontSize: 14.0,
          //           fontWeight: FontWeight.bold,
          //           color: Palette.gray00,
          //         ),
          //   ),
          //   // ignore: avoid_returning_null_for_void
          //   onTap: () => null,
          // ),
          // ListTile(
          //   // leading: const Icon(Icons.favorite),
          //   title: Text(
          //     "지역별 알림 창 : 인천",
          //     style: Theme.of(context).textTheme.bodyLarge!.copyWith(
          //           fontSize: 14.0,
          //           fontWeight: FontWeight.bold,
          //           color: Palette.gray00,
          //         ),
          //   ),
          //   // ignore: avoid_returning_null_for_void
          //   onTap: () => null,
          // ),
          // ListTile(
          //   // leading: const Icon(Icons.favorite),
          //   title: Text(
          //     "지역별 알림 창 : 기타 지역",
          //     style: Theme.of(context).textTheme.bodyLarge!.copyWith(
          //           fontSize: 14.0,
          //           fontWeight: FontWeight.bold,
          //           color: Palette.gray00,
          //         ),
          //   ),
          //   // ignore: avoid_returning_null_for_void
          //   onTap: () => null,
          // ),
          const Divider(),
          ListTile(
            // leading: const Icon(Icons.settings),
            title: Text(
              "이용안내",
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold,
                    color: Palette.gray00,
                    letterSpacing: -0.33,
                  ),
            ),
            onTap: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) => const UseGuide()),
              // );
              //amplitude
              Amplitude.getInstance().logEvent('PAGE_VIEW : USE_GUIDE');
              Navigator.of(context).pushNamed(Routes.useGuide);
            },
          ),
          ListTile(
            // leading: const Icon(Icons.notifications),
            title: Text(
              "카카오톡 알림 설정 안내",
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold,
                    color: Palette.gray00,
                  ),
            ),
            onTap: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) => const AlarmGuidePage()),
              // );
              //amplitude
              Amplitude.getInstance().logEvent('PAGE_VIEW : ALARM_GUIDE');

              Navigator.of(context).pushNamed(Routes.alarmGuide);
            },
          ),
          const Divider(),
          ListTile(
            // leading: const Icon(Icons.person),
            title: Text(
              "오픈 채팅방 입장",
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold,
                    color: Palette.gray00,
                    letterSpacing: -0.33,
                  ),
            ),
            onTap: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //       builder: (context) => const OpenchatGuidePage()),
              // );
              //amplitude
              Amplitude.getInstance().logEvent('PAGE_VIEW : OPEN_CHAT');
              Navigator.of(context).pushNamed(Routes.openchatGuide);
            },
          ),
          const Divider(),
          ListTile(
            title: Text(
              "로그아웃",
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold,
                    color: Palette.gray00,
                    letterSpacing: -0.33,
                  ),
            ),
            // leading: const Icon(Icons.exit_to_app),
            onTap: () {
              // 로그아웃
              context.read<AuthService>().signOut();
              //amplitude
              Amplitude.getInstance().logEvent('EVENT : LOGOUT');
              debugPrint("로그아웃");
              Amplitude.getInstance().uploadEvents();
              // 로그인 페이지로 이동
              // Navigator.pushReplacement(
              //   context,
              //   MaterialPageRoute(builder: (context) => const LoginPage()),
              // );
              Navigator.of(context).pushReplacementNamed(Routes.login);
            },
          ),

          // ListTile(
          //   // leading: const Icon(Icons.description),
          //   title: Text(
          //     "온 보딩 초기화 (개발용)",
          //     style: Theme.of(context).textTheme.bodyLarge!.copyWith(
          //           fontSize: 14.0,
          //           fontWeight: FontWeight.bold,
          //           color: Palette.gray00,
          //           letterSpacing: -0.33,
          //         ),
          //   ),
          //   onTap: () async {
          //     await prefs.setBool('isOnboarded', false);
          //   },
          // ),
        ],
      ),
    );
  }
}
