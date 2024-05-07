import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:wethree_flutter_core/src/core/storage.service.dart';
import 'package:wethree_flutter_core/src/models/user.model.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:intl/intl.dart';
import '../toast.dart';
import 'data.service.dart';
import 'package:http/http.dart' as http;

class AuthService {
  static User? user;
static Env env =
      GlobalConfiguration().getValue('env') == 'local' ? Env.local : Env.hosted;
  static Future authenticate(String accessToken,
      {int? expiresIn, String? expiresAtDate}) async {
    await StorageService.store(
        GlobalConfiguration().getValue<String>('accessTokenKey'), accessToken);
    await setUser();
    int expiresAt=0;

    if (expiresIn != null)
      expiresAt =
          new DateTime.now().millisecondsSinceEpoch + (expiresIn * 1000);

    if (expiresAtDate != null){
      expiresAt = DateFormat('yyyy-MM-dd').parse(expiresAtDate).millisecondsSinceEpoch;
   }
    return StorageService.store(
        GlobalConfiguration().getValue<String>('expiryTsKey'), expiresAt);
  }

  static Future<void> setUser() async {
    var data = await DataService.get("api/user/current");
    await StorageService.store(
        GlobalConfiguration().getValue<String>('userStoreKey'),
        jsonEncode(data['user']));
  }

  static Future<User> getCurrentUser([reload = false]) async {
    if (user != null && !reload) {
      return user??User();
    }
    String? data = await StorageService.read(
        GlobalConfiguration().getValue<String>('userStoreKey'));
    user = User.fromJson(jsonDecode(data??''));
    return user??User();
  }

  static Future<bool> isLoggedIn() async {
    var expiresAt = await StorageService.read(
        GlobalConfiguration().getValue<String>('expiryTsKey'));
    print(expiresAt);
    if (expiresAt == null) {
      return false;
    }
    int now = new DateTime.now().millisecondsSinceEpoch;
    print(now);
    return (int.parse(expiresAt) > now);
  }

  static Future<String?> getAccessToken() async {
    var token = await StorageService.read(
        GlobalConfiguration().getValue<String>('accessTokenKey'));
    return token;
  }

  static Future<bool> logout() async {
    await StorageService.clear();
    return true;
  }

  Future<bool> login(String email, String password, Function loading) async {
    try {
      loading();
      var data = {
        "client_id": GlobalConfiguration().getValue<int>('apiClientId'),
        "client_secret":
            GlobalConfiguration().getValue<String>('apiClientSecret'),
        "grant_type": GlobalConfiguration().getValue<String>('apiGrantType'),
        "username": email,
        "password": password,
      };

      final url = (env == Env.local ? "http://" : "https://")  +
          GlobalConfiguration().getValue<String>('coreDomain') +
          GlobalConfiguration().getValue<String>('baseUri') +
          'oauth/token';

      final http.Response response = await http.post(
        Uri.parse(url),
        body: json.encode(data),
        headers: {HttpHeaders.contentTypeHeader: 'application/json'},
      );

      final responseData = json.decode(response.body);
      log(responseData.toString());
      if (response.statusCode != 200) {
        loading();
        ToastMessage(message: 'Incorrect email or password, please try again');
        return false;
      }
      ToastMessage(message: "Successfully logged in");

      await AuthService.authenticate(
        responseData['access_token'],
        expiresIn: responseData['expires_in'],
      );
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
