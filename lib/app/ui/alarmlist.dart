import 'package:amplitude_flutter/amplitude.dart';
import 'package:classmatch/app/config/analytics_config.dart';
import 'package:classmatch/app/routes/routes.dart';
import 'package:classmatch/app/ui/globa_widget.dart';
import 'package:classmatch/app/ui/navBar.dart';
import 'package:classmatch/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/date_symbol_data_local.dart';
import '../controller/alarm_service.dart';
import '../controller/auth_service.dart';
import '../controller/notification_controller.dart';
import 'color.dart';

bool init = true;
List<dynamic> gSelectedAreaFromServer = [];
List<String> favselectedArea = prefs.getStringList("favselectedArea") ?? ["서울"];
// bool initArea = true;
// int initCount = 0;

/// 홈페이지
class ArlamListPage extends StatefulWidget {
  const ArlamListPage({Key? key}) : super(key: key);

  @override
  State<ArlamListPage> createState() => _ArlamListPageState();
}

class _ArlamListPageState extends State<ArlamListPage> {
  @override
  Widget build(BuildContext context) {
    Get.put(AreaSelectController());
    final controller = Get.find<AreaSelectController>();

    final authService = context.read<AuthService>();
    final alarmService = context.read<AlarmService>();
    final user = authService.currentUser();

    //amplitude
    // Set user Id
    Analytics_config.analytics.setUserId(user!.uid);

    if (init == true) {
      // 토큰 업데이트
      alarmService.updateToken(user.uid, tokenFCM);

      // 종료결과 불러오기
      final getUserInfoFromServer = alarmService.getUserInfo(user.uid);
      getUserInfoFromServer.then((val) {
        // int가 나오면 해당 값을 출력
        // debugPrint('val: $val');
        isExpired = val;
        prefs.setBool("isExpired", isExpired);
        if (isExpired == true) {
          // 로그인 성공
          // Navigator.pushReplacement(
          //   context,
          //   MaterialPageRoute(builder: (context) => const ServiceOver()),
          // );
          Navigator.of(context).pushReplacementNamed(Routes.serviceOver);
        }

        debugPrint('isExpired: ${isExpired.toString()}');
      }).catchError((error) {
        // error가 해당 에러를 출력
        debugPrint('error: $error');
      });

      // 지역 불러오기
      final selectedAreaFromServer = alarmService.findFavArea(user.uid);
      selectedAreaFromServer.then((val) {
        // int가 나오면 해당 값을 출력
        debugPrint('처음서버값: $val');
        //해당 함수는 빌드가 끝난 다음 수행 된다.
        //https://velog.io/@jun7332568/%ED%94%8C%EB%9F%AC%ED%84%B0flutter-setState-or-markNeedsBuild-called-during-build.-%EC%98%A4%EB%A5%98-%ED%95%B4%EA%B2%B0
        // WidgetsBinding.instance!.addPostFrameCallback((_) {
        if (val.isNotEmpty) {
          controller.selectedAreaList.value =
              val.map((e) => e.toString()).toList();
          // debugPrint('val2: $gSelectedAreaFromServer');
          // _refreshMemberCount();
        }
        // });
      }).catchError((error) {
        // error가 해당 에러를 출력
        debugPrint('error: $error');
      });

      // print(selectedAreafromServer.toString());

      init = false;
    }

    return Consumer<AlarmService>(
      builder: (context, alarmService, child) {
        //amplitude
        Amplitude.getInstance().logEvent('PAGE_VIEW : LIST_BUILD');
        return SafeArea(
          child: TooltipVisibility(
            visible: false,
            child: Scaffold(
              //drawer제스쳐로 열지 않도록 처리
              drawerEnableOpenDragGesture: false,
              endDrawer: const NavBar(),
              backgroundColor: Palette.secondaryBackground,
              appBar: AppBar(
                automaticallyImplyLeading: false,

                iconTheme: const IconThemeData(color: Palette.gray66),
                elevation: 0,
                backgroundColor: Palette.mainBackground,
                title: Text(
                  '대강 알림',
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Palette.gray00,
                        letterSpacing: -0.33,
                      ),
                ),
                centerTitle: true,
                actions: [
                  Builder(
                    builder: (context) => IconButton(
                      icon: const Icon(CupertinoIcons.bars),
                      onPressed: () => Scaffold.of(context).openEndDrawer(),
                      tooltip: MaterialLocalizations.of(context)
                          .openAppDrawerTooltip,
                    ),
                  ),
                ],
                // leading: IconButton(
                //   onPressed: () {},
                //   icon: Icon(Icons.calendar_month),
                // ),
                // leading: Builder(
                //   builder: (context) => // Ensure Scaffold is in context
                //       IconButton(
                //           icon: Icon(Icons.menu),
                //           color: Palette.gray66,
                //           onPressed: () => Scaffold.of(context).openDrawer()),
                // ),

                // actions: [
                //   Builder(
                //     builder: (context) => // Ensure Scaffold is in context
                //         IconButton(
                //             icon: Icon(Icons.menu),
                //             onPressed: () => Scaffold.of(context).openDrawer()),
                //   ),
                // IconButton(
                //     icon: Icon(Icons.menu),
                //     color: Palette.gray66,
                //     onPressed: () => Scaffold.of(context).openDrawer()),
                // ],
              ),
              // appBar: AppBar(
              //   leading: Builder(
              //     builder: (context) => // Ensure Scaffold is in context
              //         IconButton(
              //             icon: Icon(Icons.menu),
              //             onPressed: () => Scaffold.of(context).openDrawer()),
              //   ),
              // ),
              // appBar: mainAppBarMethod(context, "대강 알림"),
              /// widget behind panel
              body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                // stream: alarmService.read(user.uid),
                stream: FirebaseFirestore.instance
                    .collection('inprogress2')
                    .limit(100)
                    .orderBy('startTime', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  // final documents = snapshot.data?.docs ?? []; // 문서들 가져오기
                  // final documents = snapshot.data; // 문서들 가져오기
                  List<DocumentSnapshot> documents = snapshot.data?.docs ?? [];

                  // List<DocumentSnapshot> documents = snapshot.data!.docs;
                  if (snapshot.hasError) {
                    return const Center(child: Text("회원 목록을 준비 중입니다."));
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(child: Text("회원 목록을 준비 중입니다."));
                  } else if (!snapshot.hasData) {
                    return const Center(child: Text("회원 목록을 준비 중입니다."));
                  }
                  // if (documents.isEmpty) {
                  //   return Center(child: Text("회원 목록을 준비 중입니다."));
                  // }

                  return ScrollConfiguration(
                    behavior: MyBehavior(),
                    child: Column(
                      children: [
                        Expanded(
                          child: ListView.builder(
                            reverse: true,
                            physics: const RangeMaintainingScrollPhysics(),
                            itemCount: documents.length,
                            itemBuilder: (context, index) => Obx(
                              () {
                                final doc = documents[index];
                                String area = doc.get('area');
                                String status = doc.get('status');
                                bool areaFiltersflag = false;

                                // //최초1번 서버에서 불러온 지역 값을 반영한다.
                                // if (controller.initSelcetedArea.value) {
                                //   controller.selectedAreaList.value =
                                //       gSelectedAreaFromServer
                                //           .map((e) => e.toString())
                                //           .toList();
                                //   controller.initSelcetedArea.value = false;
                                //   debugPrint(
                                //       '서버값 : ${controller.selectedAreaList}');
                                // }

                                if (controller.selectedAreaList
                                    .contains("전국")) {
                                  areaFiltersflag = true;
                                } else if (controller.selectedAreaList
                                    .contains("기타")) {
                                  List<String> areaFilters = [
                                    "부산",
                                    "대전",
                                    "대구",
                                    "광주",
                                    "울산산",
                                    "세종",
                                    "전남",
                                    "충북",
                                    "충남",
                                    "전북",
                                    "제주",
                                  ];
                                  for (int i = 0; i < areaFilters.length; i++) {
                                    if (area.contains(areaFilters[i]) == true) {
                                      areaFiltersflag = true;
                                    }
                                  }
                                } else {
                                  List<dynamic> areaFilters =
                                      controller.selectedAreaList;
                                  for (int i = 0; i < areaFilters.length; i++) {
                                    if (area.contains(areaFilters[i]) == true) {
                                      areaFiltersflag = true;
                                    }
                                  }
                                }

                                // 지역 필터링 된 것들만 출력 하도록 설정
                                if (areaFiltersflag) {
                                  String title = doc.get('title');
                                  String date = doc.get('date');
                                  String author = doc.get('author');
                                  String shop = doc.get('shop');
                                  String fee = doc.get('fee');
                                  // print(doc.get('content'));
                                  // print(doc.get('content').runtimeType);
                                  String content = doc.get('content');
                                  // String contentStr = jsonDecode(content).join(",");

                                  initializeDateFormatting();
                                  DateFormat dateFormat =
                                      DateFormat('aa hh:mm', 'ko');
                                  DateFormat dateFormatGroup =
                                      DateFormat('yyyy년 M월 d일 E요일', 'ko');

                                  String startTime = dateFormat
                                      .format(
                                          doc.get('startTime').toDate().toUtc())
                                      .toString();
                                  String startTimeGroup = dateFormatGroup
                                      .format(
                                          doc.get('startTime').toDate().toUtc())
                                      .toString();

                                  bool isSameDate = true;

                                  // print(index);

                                  if (index == 0) {
                                    isSameDate = false;
                                  } else {
                                    String preStartTimeGroup = dateFormatGroup
                                        .format(documents[index - 1]
                                            .get('startTime')
                                            .toDate()
                                            .toUtc())
                                        .toString();
                                    if (preStartTimeGroup != startTimeGroup) {
                                      isSameDate = false;
                                    }
                                  }

                                  if ((index != 0) && (isSameDate == false)) {
                                    // 날짜와 같이 출력
                                    // print("날짜 변경");
                                    return Column(
                                      children: [
                                        MessageBubble(
                                          title: title,
                                          area: area,
                                          date: date,
                                          author: author,
                                          shop: shop,
                                          fee: fee,
                                          startTime: startTime,
                                          content: content,
                                          status: status,
                                        ),
                                        const SizedBox(
                                          height: 15,
                                        ),
                                        Text(
                                          startTimeGroup,
                                          overflow: TextOverflow.clip,
                                          maxLines: 1,
                                          style: const TextStyle(
                                            fontSize: 10,
                                            color: Color(0xFF737373),
                                            letterSpacing: -0.33,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 31,
                                        ),
                                      ],
                                    );
                                  } else {
                                    // 메시지 버블만 출력
                                    return MessageBubble(
                                      title: title,
                                      area: area,
                                      date: date,
                                      author: author,
                                      shop: shop,
                                      fee: fee,
                                      startTime: startTime,
                                      content: content,
                                      status: status,
                                    );
                                  }
                                } else {
                                  if ((index == 0)) {
                                    // 그냥 무조건 한번 뿌려줌
                                    // print("그냥 무조건 한번 뿌려줌");
                                    // initializeDateFormatting();
                                    // DateFormat dateFormat =
                                    //     DateFormat('aa hh:mm', 'ko');
                                    // DateFormat dateFormatGroup =
                                    //     DateFormat('yyyy년 M월 d일 E요일', 'ko');

                                    // String startTime = dateFormat
                                    //     .format(doc
                                    //         .get('startTime')
                                    //         .toDate()
                                    //         .toUtc())
                                    //     .toString();
                                    // String startTimeGroup = dateFormatGroup
                                    //     .format(doc
                                    //         .get('startTime')
                                    //         .toDate()
                                    //         .toUtc())
                                    //     .toString();

                                    // return Column(
                                    //   children: [
                                    //     SizedBox(
                                    //       height: 31,
                                    //     ),
                                    //     Text(
                                    //       startTimeGroup,
                                    //       overflow: TextOverflow.clip,
                                    //       maxLines: 1,
                                    //       style: TextStyle(
                                    //           fontSize: 10,
                                    //           color: Color(0xFF737373)),
                                    //     ),
                                    //     SizedBox(
                                    //       height: 31,
                                    //     ),
                                    //   ],
                                    // );
                                    return const SizedBox(width: 0, height: 0);
                                  } else {
                                    // print("날짜변경은 언제.??");
                                    return const SizedBox(width: 0, height: 0);
                                  }
                                }
                              },
                            ),
                          ),
                        ),
                        //const SizedBox(height: 110)
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}

class MessageBubble extends StatelessWidget {
  const MessageBubble({
    Key? key,
    required this.title,
    required this.area,
    required this.date,
    required this.author,
    required this.shop,
    required this.fee,
    required this.startTime,
    required this.content,
    required this.status,
  }) : super(key: key);

  final String title;
  final String area;
  final String date;
  final String author;
  final String shop;
  final String fee;
  final String startTime;
  final String content;
  final String status;

  @override
  Widget build(BuildContext context) {
    // String contentStr = content.join(",");

    if (status == "진행중") {
      return Column(
        children: [
          SizedBox(
            //color: Palette.gray33,
            width: double.infinity,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(width: 8),
                // 서클 아이콘
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: const [
                    CircleAvatar(
                      radius: 15,
                      backgroundColor: Palette.grayFF,
                      backgroundImage:
                          AssetImage("assets/images/bettercoach_icon.png"),
                    ),
                    //Spacer(flex: 1)
                  ],
                ),
                //SizedBox(width: 30),
                const SizedBox(width: 7),
                // 메시지 버블
                // Image.asset("assets/images/bettercoach_icon.png", width: 30),
                Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(15),
                      width: 233,
                      decoration: BoxDecoration(
                        border: Border.all(color: Palette.grayFF, width: 1),
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(10),
                          topLeft: Radius.circular(10),
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                        ),
                        color: Palette.grayFF,
                      ),
                      child: Column(
                        children: [
                          //SizedBox(height: 4),
                          SizedBox(
                            width: 203,
                            child: Text(
                              title,
                              overflow: TextOverflow.clip,
                              maxLines: 3,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Color(0xFF737373),
                                letterSpacing: -0.33,
                              ),
                            ),
                          ),
                          const SizedBox(height: 14),
                          Container(
                            decoration: const BoxDecoration(
                              color: Color(0xFFE1E1E1),
                            ),
                            child: const SizedBox(
                              width: 203,
                              height: 1,
                            ),
                          ),
                          const SizedBox(height: 9),
                          SizedBox(
                            width: 203,
                            child: Text(
                              // '${area}  | ',
                              '$area  |  $shop',
                              overflow: TextOverflow.clip,
                              maxLines: 3,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFF000000),
                                letterSpacing: -0.33,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 203,
                            child: Text(
                              '$date  |  페이 : $fee',
                              overflow: TextOverflow.clip,
                              maxLines: 3,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFF000000),
                                letterSpacing: -0.33,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            decoration: const BoxDecoration(
                              color: Color(0xFFE1E1E1),
                            ),
                            child: const SizedBox(
                              width: 203,
                              height: 1,
                            ),
                          ),
                          const SizedBox(height: 11),
                          SizedBox(
                            width: 203,
                            child: Text(
                              content,
                              overflow: TextOverflow.clip,
                              maxLines: 30,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Color(0xFF737373),
                                letterSpacing: -0.33,
                              ),
                            ),
                          ),
                          //SizedBox(height: 1),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  // mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      startTime,
                      overflow: TextOverflow.clip,
                      maxLines: 1,
                      style: const TextStyle(
                        fontSize: 10,
                        letterSpacing: -0.33,
                        // color: isDone ? Colors.grey : Colors.black,
                        // decoration: isDone
                        //     ? TextDecoration.lineThrough
                        //     : TextDecoration.none,
                      ),
                    ),
                  ],
                ),
                const Spacer(flex: 1)
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],
      );
    } else {
      return Column(
        children: [
          SizedBox(
            //color: Palette.gray33,
            width: double.infinity,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(width: 8),
                // 서클 아이콘
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: const [
                    CircleAvatar(
                      radius: 15,
                      backgroundColor: Palette.grayFF,
                      backgroundImage:
                          AssetImage("assets/images/bettercoach_icon.png"),
                    ),
                    //Spacer(flex: 1)
                  ],
                ),
                //SizedBox(width: 30),
                const SizedBox(width: 7),
                // 메시지 버블
                // Image.asset("assets/images/bettercoach_icon.png", width: 30),
                Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(15),
                      width: 233,
                      decoration: BoxDecoration(
                        border: Border.all(color: Palette.grayFF, width: 1),
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(10),
                          topLeft: Radius.circular(10),
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                        ),
                        color: Palette.grayFF,
                      ),
                      child: Column(
                        children: [
                          //SizedBox(height: 4),
                          const SizedBox(
                            width: 203,
                            child: Text(
                              '완료된 모집 공고입니다.',
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xFFBABABA),
                                letterSpacing: -0.33,
                              ),
                            ),
                          ),
                          const SizedBox(height: 14),
                          SizedBox(
                            width: 203,
                            child: Text(
                              title,
                              overflow: TextOverflow.clip,
                              maxLines: 3,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Color(0xFFBABABA),
                                letterSpacing: -0.33,
                              ),
                            ),
                          ),
                          const SizedBox(height: 14),
                          SizedBox(
                            width: 203,
                            child: Text(
                              '$area  |  $shop',
                              overflow: TextOverflow.clip,
                              maxLines: 3,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFFBABABA),
                                letterSpacing: -0.33,
                              ),
                            ),
                          ),

                          //SizedBox(height: 8),

                          //SizedBox(height: 1),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  // mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      startTime,
                      overflow: TextOverflow.clip,
                      maxLines: 1,
                      style: const TextStyle(
                        fontSize: 10,
                        letterSpacing: -0.33,
                        // color: isDone ? Colors.grey : Colors.black,
                        // decoration: isDone
                        //     ? TextDecoration.lineThrough
                        //     : TextDecoration.none,
                      ),
                    ),
                  ],
                ),
                const Spacer(flex: 1)
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],
      );
    }
  }
}

class AreaSelectController {
  final RxList<String> _areaList = [
    "전국",
    "서울",
    "경기",
    "인천",
    "기타",
  ].obs;
  RxList<String> get areaList => _areaList;

  // ignore: prefer_final_fields
  RxList<dynamic> _selectedAreaList = [""].obs;

  RxList<dynamic> get selectedAreaList => _selectedAreaList;

  final RxList _customTileColorList = [].obs;
  RxList get customTileColorList => _customTileColorList;

  final RxList _customBorderColorList = [].obs;
  RxList get customBorderColorList => _customBorderColorList;

  RxBool _initArea = true.obs;
  RxBool get initArea => _initArea;

  // ignore: prefer_final_fields
  RxBool _initSelcetedArea = true.obs;
  RxBool get initSelcetedArea => _initSelcetedArea;

  final RxInt _initCount = 0.obs;
  RxInt get initCount => _initCount;

  void initAreaColor(value) {
    // print(value);
    // print(_selectedAreaList);
    if (_selectedAreaList.contains(value)) {
      _customTileColorList.add(Palette.backgroundBlue);
      _customBorderColorList.add(Colors.transparent);
      // print("언제 울리니? 1 ");
    } else {
      _customTileColorList.add(Colors.transparent);
      _customBorderColorList.add(Palette.grayEE);
      // print("언제 울리니? 2 ");
    }
  }

  void updateArea(value, index) {
    if (value == '전국') {
      if (_selectedAreaList.contains(value)) {
        // 기존값 전국일 경우, 변화없음
        // print('기존값 전국일 경우, 변화없음');
      } else {
        // 기존값 일반 지역일 경우, 다빼고 전국을 넣기
        _customTileColorList.clear();
        _customBorderColorList.clear();
        _selectedAreaList.clear();
        // 전국 넣기
        _selectedAreaList.add(value);
        _initArea = true.obs;
        // print('기존값 일반 지역일 경우, 다빼고 전국을 넣기');
      }
    } else {
      // 전국이 아닐 경우
      if (_selectedAreaList.contains('전국')) {
        // 기존 전국이 있었을 경우, 전국을 빼고, 선택한 걸 넣기
        int totalIndex = _selectedAreaList.indexOf('전국');
        _customTileColorList[totalIndex] = Colors.transparent;
        _customBorderColorList[totalIndex] = Palette.grayEE;
        _selectedAreaList.remove('전국');

        _customTileColorList[index] = Palette.backgroundBlue;
        _customBorderColorList[index] = Colors.transparent;
        _selectedAreaList.add(value);
        // print('기존 전국이 있었을 경우, 전국을 빼고, 선택한 걸 넣기');
      } else {
        // 기존 전국이 없을 경우 스위치역할수행
        // 혼자만 있을 경우는 변경되지 않음
        if ((_selectedAreaList.length == 1) &&
            _selectedAreaList.contains(value)) {
          // print('한개만 남았다.');
        } else {
          if (_selectedAreaList.contains(value)) {
            _customTileColorList[index] = Colors.transparent;
            _customBorderColorList[index] = Palette.grayEE;
            _selectedAreaList.remove(value);
            // [지역설정] 서버에서도 지우기
          } else {
            _customTileColorList[index] = Palette.backgroundBlue;
            _customBorderColorList[index] = Colors.transparent;
            _selectedAreaList.add(value);
            // [지역설정] 서버에 추가하기
          }
          // print('기존 전국이 없을 경우 스위치역할수행');
        }
      }
    }
    // print(value);
    // print(index);
    // print(_selectedAreaList);
    // print(_customTileColorList);
    // print(_customBorderColorList);
  }
}

// void flutterDialog(context, bodytext) {
//   showDialog(
//       context: context,
//       //barrierDismissible - Dialog를 제외한 다른 화면 터치 x
//       barrierDismissible: false,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           // RoundedRectangleBorder - Dialog 화면 모서리 둥글게 조절
//           shape:
//               RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
//           //Dialog Main Title
//           // title: Column(
//           //   children: <Widget>[
//           //     new Text("Dialog Title"),
//           //   ],
//           // ),
//           //
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: <Widget>[
//               Text(
//                 bodytext,
//               ),
//             ],
//           ),
//           actions: <Widget>[
//             TextButton(
//               child: const Text("확인"),
//               onPressed: () {
//                 Navigator.pop(context);
//               },
//             ),
//           ],
//         );
//       });
// }

// void flutterDialogImage(context, bodytext) {
//   showDialog(
//       context: context,
//       //barrierDismissible - Dialog를 제외한 다른 화면 터치 x
//       barrierDismissible: false,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           // RoundedRectangleBorder - Dialog 화면 모서리 둥글게 조절
//           shape:
//               RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
//           //Dialog Main Title
//           // title: Column(
//           //   children: <Widget>[
//           //     new Text("Dialog Title"),
//           //   ],
//           // ),
//           //
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: <Widget>[
//               Image.asset(
//                 'assets/images/GuideAlarm.png',
//                 width: 340,
//                 // height: 4000,
//                 // fit: BoxFit.cover,
//               ),
//             ],
//           ),
//           actions: <Widget>[
//             TextButton(
//               child: const Text("확인"),
//               onPressed: () {
//                 Navigator.pop(context);
//               },
//             ),
//           ],
//         );
//       });
// }
