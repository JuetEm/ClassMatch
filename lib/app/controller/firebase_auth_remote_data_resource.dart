import 'package:http/http.dart' as http;

class FirebaseAuthRemoteDataSource {
  // final String url = "http://localhost:58903/auth/kakaoLogin";
  // final String url = "https://icanidevelop.com/auth/kakaoLogin";
  final String url =
      "https://us-central1-classmatch-f7175.cloudfunctions.net/createCustomToken";

  Future<String> createCustomToken(Map<String, dynamic> user) async {
    final customTokenResponse = await http.post(Uri.parse(url), body: user);
    // print("customTokenResponse.body : ${customTokenResponse.body}");

    return customTokenResponse.body;
  }
}
