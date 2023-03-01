import 'package:amplitude_flutter/amplitude.dart';
import 'package:classmatch/main.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter/material.dart';
import 'color.dart';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

class OpenchatGuidePage extends StatefulWidget {
  const OpenchatGuidePage({Key? key}) : super(key: key);

  @override
  State<OpenchatGuidePage> createState() => _OpenchatGuidePageState();
}

class _OpenchatGuidePageState extends State<OpenchatGuidePage> {
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
              "카카오톡 오픈채팅방 안내",
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
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
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
                        Amplitude.getInstance().logEvent(
                            'BTN_CLK : OPNCHAT_ENT',
                            eventProperties: {"AREA": "서울"});
                        html.window.open(
                            'https://open.kakao.com/o/g7mDXV5e', 'new tab');
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
                    height: 50,
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
                        Amplitude.getInstance().logEvent(
                            'BTN_CLK : OPNCHAT_ENT',
                            eventProperties: {"AREA": "경기"});

                        html.window.open(
                            'https://open.kakao.com/o/gMXiLn6e', 'new tab');
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
                    height: 50,
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
                        Amplitude.getInstance().logEvent(
                            'BTN_CLK : OPNCHAT_ENT',
                            eventProperties: {"AREA": "인천"});
                        html.window.open(
                            'https://open.kakao.com/o/ggS2Op6e', 'new tab');
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
                    height: 50,
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
                        Amplitude.getInstance().logEvent(
                            'BTN_CLK : OPNCHAT_ENT',
                            eventProperties: {"AREA": "기타"});
                        html.window.open(
                            'https://open.kakao.com/o/g2vOPp6e', 'new tab');
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
            ],
          ),
        ),
      ),
    );
  }
}

class GrayInkwellButton extends StatefulWidget {
  const GrayInkwellButton({
    Key? key,
    required this.label,
    required this.customFunctionOnTap,
  }) : super(key: key);

  final String label;
  final Function customFunctionOnTap;

  @override
  State<GrayInkwellButton> createState() => _GrayInkwellButtonState();
}

class _GrayInkwellButtonState extends State<GrayInkwellButton> {
  bool _toggle = false;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      width: double.infinity,
      child: Material(
        borderRadius: BorderRadius.circular(10),
        color: Palette.grayEE,
        child: InkWell(
          onTapDown: (details) {
            setState(() {
              _toggle = true;
            });
          },
          onTapUp: (details) {
            setState(() {
              _toggle = false;
            });
          },
          borderRadius: BorderRadius.circular(10),
          onTap: () {
            widget.customFunctionOnTap();
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                widget.label,
                style: const TextStyle(
                  fontSize: 14,
                  color: Palette.gray66,
                  letterSpacing: -0.33,
                ),
              ),
              const SizedBox(width: 4),
              const Icon(
                Icons.add_circle_outline,
                color: Palette.gray66,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    ).animate(target: _toggle ? 0.5 : 0).scaleXY(end: 0.9);
  }
}
