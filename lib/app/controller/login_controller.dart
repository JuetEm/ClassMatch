import 'package:classmatch/app/controller/firebase_auth_remote_data_resource.dart';
import 'package:firebase_auth/firebase_auth.dart' as FA;
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';

class LoginController {
  bool isKakaoInstalled = false;

  final FA.FirebaseAuth _firebaseAuth = FA.FirebaseAuth.instance;
  late FA.User currentUser;

  String? email = "";
  String? url = "";
  String? name = "";

  Future<FA.User?> kakaoSignIn() async {
    final firebaseauthRemoteDataResource = FirebaseAuthRemoteDataSource();

    User? user;
    isKakaoInstalled = await isKakaoTalkInstalled();
    // print("isKakaoInstalled : $isKakaoInstalled");
    OAuthToken token = isKakaoInstalled
        ? await UserApi.instance.loginWithKakaoTalk()
        : await UserApi.instance.loginWithKakaoAccount();

    print("NATIVE - 카카오톡으로 로그인 성공 - token : $token");
    user = await UserApi.instance.me();

    /* final url = Uri.https('kapi.kakao.com', '/v2/user/me');
    final response = await http.get(
      url,
      headers: {HttpHeaders.authorizationHeader: 'Bearer ${token.accessToken}'},
    ); */

    // print("user.id : ${user.id}");
    // print("user.kakaoAccount?.email : ${user.kakaoAccount?.email}");
    // print(
    //     "user.kakaoAccount?.profile?.nickname : ${user.kakaoAccount?.profile?.nickname}");
    // print(
    //     "user?.kakaoAccount?.profile?.profileImageUrl : ${user.kakaoAccount?.profile?.profileImageUrl}");

    String? id = user.id.toString();
    String? email = user.kakaoAccount?.email.toString();
    String? name = user.kakaoAccount?.profile?.nickname.toString();
    String? photoURL = user.kakaoAccount?.profile?.profileImageUrl.toString();

    final customToken = await firebaseauthRemoteDataResource.createCustomToken({
      'uid': id,
      'displayName': name,
      'email': email ?? '',
      'photoURL': photoURL ?? '',
    });

    final FA.UserCredential userCredential =
        await FA.FirebaseAuth.instance.signInWithCustomToken(customToken);

    final FA.User? fUser = userCredential.user;

    currentUser = _firebaseAuth.currentUser!;
    // print(
    //     "kakao login : currentUser email : ${currentUser.email}, currentUser photoURL : ${currentUser.photoURL}, currentUser displayName : ${currentUser.displayName}");

    String? fEmail = fUser?.email;
    String? fUrl = fUser?.photoURL;
    String? fName = fUser?.displayName;

    print(
        "kakao login : fUser email : $fEmail, fUser url : $fUrl, fUser name : $fName");

    return fUser;
  }
}
