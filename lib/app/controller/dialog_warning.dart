import 'package:get/get.dart';

class DialogWarning extends GetxController {
  // ignore: prefer_final_fields
  RxString _message = "".obs;
  RxString get message => _message;

  // var count1 = 0;
  // var count2 = 0.obs;
  // var count2 = Rx<int>(0);
  // var count2 = RxInt(0);

  // @override
  // void onInit() {
  //   super.onInit();

  //   once(count2, (_) {
  //     print('$_이 처음으로 변경되었습니다.');
  //   });
  //   ever(count2, (_) {
  //     print('$_이 변경되었습니다.');
  //   });
  // }
}
