import 'package:amplitude_flutter/amplitude.dart';
import 'package:classmatch/app/controller/alarm_service.dart';
import 'package:classmatch/app/controller/auth_service.dart';
import 'package:classmatch/app/ui/alarmlist.dart';
import 'package:classmatch/app/ui/globa_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'color.dart';

bool initDropdown = true;
String selectedDropdown = "서울";

class FavareaSelectPage extends StatefulWidget {
  const FavareaSelectPage({Key? key}) : super(key: key);

  @override
  State<FavareaSelectPage> createState() => _FavareaSelectPageState();
}

class _FavareaSelectPageState extends State<FavareaSelectPage> {
  List<String> dropdownList = [
    "서울",
    "경기",
    "인천",
    "기타",
  ];

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AreaSelectController>();
    final alarmService = context.read<AlarmService>();

    if (initDropdown) {
      selectedDropdown = controller.selectedAreaList[0];
      initDropdown = false;
      debugPrint("초기값 $selectedDropdown");
    }

    return SafeArea(
      child: TooltipVisibility(
        visible: false,
        child: Scaffold(
          //drawer제스쳐로 열지 않도록 처리
          drawerEnableOpenDragGesture: false,
          //endDrawer: NavBar(),
          backgroundColor: Palette.secondaryBackground,
          appBar: AppBar(
            leading: CupertinoNavigationBarBackButton(
              color: Palette.gray66,
              // icon: const Icon(CupertinoIcons.back),
              onPressed: () => Navigator.of(context).pop(),
            ),
            iconTheme: const IconThemeData(color: Palette.gray66),
            elevation: 0,
            backgroundColor: Palette.mainBackground,
            title: Text(
              "관심 지역 등록",
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 30),
                  Row(
                    // mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 200,
                        height: 50,
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        decoration: BoxDecoration(
                            border: Border.all(color: Palette.grayB4, width: 1),
                            borderRadius: BorderRadius.circular(10)),
                        child: DropdownButton(
                          focusColor: Palette.grayFF,
                          dropdownColor: Palette.grayFF,
                          icon: const Icon(Icons.arrow_drop_down),
                          iconSize: 20,
                          isExpanded: true,
                          underline: const SizedBox(),
                          style: const TextStyle(
                            color: Palette.gray66,
                            fontSize: 15,
                          ),
                          value: selectedDropdown,
                          items: dropdownList.map((String item) {
                            return DropdownMenuItem<String>(
                              // ignore: sort_child_properties_last
                              child: Text(
                                item,
                              ),
                              value: item,
                            );
                          }).toList(),
                          onChanged: (dynamic value) {
                            setState(() {
                              selectedDropdown = value;
                            });
                          },
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Container(
                        width: 100,
                        height: 50,
                        decoration: BoxDecoration(
                            border: Border.all(color: Palette.grayB4, width: 1),
                            borderRadius: BorderRadius.circular(10)),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: const EdgeInsets.all(0),
                            elevation: 0,
                            backgroundColor: Palette.grayFA,

                            // minimumSize: const Size.fromHeight(50), // NEW
                          ),
                          onPressed: () {
                            controller.selectedAreaList.clear();
                            controller.selectedAreaList.add(selectedDropdown);
                            // areaList.clear();
                            // areaList.add(selectedDropdown);
                            debugPrint(
                                '지역변경 : ${controller.selectedAreaList[0].toString()}');
                            // 서버에서 한번 읽어 와야함.
                            final user =
                                context.read<AuthService>().currentUser();

                            //amplitude
                            Amplitude.getInstance().logEvent(
                                'BTN_CLK : AREA_SERECT',
                                eventProperties: {"AREA": selectedDropdown});

                            alarmService.updateFavArea(
                              uid: user!.uid,
                              areaList: controller.selectedAreaList
                                  .map((e) => e.toString())
                                  .toList(),
                              onSuccess: () {
                                // // Done 클릭시 페이지 이동
                                // Navigator.pushReplacement(
                                //   context,
                                //   MaterialPageRoute(
                                //       builder: (context) => const ArlamListPage()),
                                // );
                                // Navigator.of(context)
                                //     .pushReplacementNamed(Routes.arlamList);
                                flutterDialog(context, "정상 등록 되었습니다.");
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
                            child: Text("등록",
                                style: TextStyle(
                                  color: Palette.gray33,
                                  fontSize: 14,
                                  letterSpacing: -0.33,
                                )),
                          ),
                        ),
                      )
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

void flutterDialog(context, bodytext) {
  showDialog(
      context: context,
      //barrierDismissible - Dialog를 제외한 다른 화면 터치 x
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          // RoundedRectangleBorder - Dialog 화면 모서리 둥글게 조절
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),

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
                  child: const Text("확인"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                // const Spacer(),
                // TextButton(
                //   child: const Text("아니요. 다음에 할께요."),
                //   onPressed: () {},
                // ),
              ],
            ),
          ],
        );
      });
  // return void;
}
