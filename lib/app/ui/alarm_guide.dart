import 'package:classmatch/app/ui/globa_widget.dart';
import 'package:flutter/material.dart';
import 'color.dart';

class AlarmGuidePage extends StatelessWidget {
  const AlarmGuidePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
              "카카오톡 알림 설정 안내",
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Palette.gray00,
                    letterSpacing: -0.33,
                  ),
            ),
            centerTitle: true,
          ),

          body: ScrollConfiguration(
            behavior: MyBehavior(),
            child: SingleChildScrollView(
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/onboarding5.png',
                        width: 340,
                        // height: 4000,
                        // fit: BoxFit.cover,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
