import 'package:classmatch/app/controller/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'color.dart';

class ServiceOverPage extends StatelessWidget {
  const ServiceOverPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    context.read<AuthService>().signOut();
    debugPrint("로그아웃");

    return SafeArea(
      child: TooltipVisibility(
        visible: false,
        child: Scaffold(
          //drawer제스쳐로 열지 않도록 처리
          drawerEnableOpenDragGesture: false,
          //endDrawer: NavBar(),
          backgroundColor: Palette.secondaryBackground,
          appBar: AppBar(
            iconTheme: const IconThemeData(color: Palette.gray66),
            elevation: 0,
            backgroundColor: Palette.mainBackground,
            title: Text(
              "무료 체험 종료 안내",
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Palette.gray00,
                    letterSpacing: -0.33,
                  ),
            ),
            centerTitle: true,
          ),

          body: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  // Spacer(),
                  Text("무료 체험이 종료되었습니다."),
                  // Spacer(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
