import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:api_cache_manager/models/cache_db_model.dart';
import 'package:api_cache_manager/utils/cache_manager.dart';
import 'package:dio/dio.dart';
import 'package:wethree_flutter_core/wethree_flutter_core.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

typedef ErrorToastCustomWidget = ToastMessage Function(http.Response response);

enum Env { local, hosted }

class CustomUri {
  static Env env =
      GlobalConfiguration().getValue('env') == 'local' ? Env.local : Env.hosted;

  static Uri parse(String url, Map<String, String> params) {
    if (env == Env.local) {
      return Uri.http(
        GlobalConfiguration().getValue('coreDomain'),
        GlobalConfiguration().getValue<String>('baseUri') + url,
        params,
      );
    } else
      return Uri.https(
        GlobalConfiguration().getValue('coreDomain'),
        GlobalConfiguration().getValue<String>('baseUri') + url,
        params,
      );
  }
}

class DataService {
  static _debug(message) {
    if (debugMessage != null) {
      debugMessage!(message);
    }
  }

  static _handleError({String url = "", dynamic response}) {
    if (handleError != null) {
      handleError!(url: url, response: response);
    }
  }

  static _handleException(
      {String url = "", Exception? exception, StackTrace? stackTrace}) {
    if (handleException != null) {
      handleException!(url: url, exception: exception, stackTrace: stackTrace);
    }
  }

  static Function? debugMessage;
  static Function? handleError;
  static Function? handleException;
  static bool isButtonDisabled = false;
  static Env env =
      GlobalConfiguration().getValue('env') == 'local' ? Env.local : Env.hosted;
  static Future<Map<String, String>> getHeaders() async {
    final accessToken = await AuthService.getAccessToken();
    Map<String, String> headers =
        GlobalConfiguration().getValue<Map<String, String>>('httpHeaders') ??
            {};
    headers[HttpHeaders.acceptHeader] = 'application/json';
    headers[HttpHeaders.contentTypeHeader] = 'application/json';
    if (accessToken != null)
      headers[HttpHeaders.authorizationHeader] = 'Bearer $accessToken';
    return headers;
  }

  static Future<Map> get(String url,
      {Map<String, String>? params,
      bool enableCache = false,
      ErrorToastCustomWidget? customToast,
      bool showToast = true}) async {
    //Method to check actual internet connection
    Future<bool> checkIsInternetConnected() async {
      try {
        return true;
      } on SocketException catch (_) {
        return false;
      }
      return false;
    }

    bool isConnected = await checkIsInternetConnected();

    Future<Map> getResponse() async {
      http.Response response = await http.get(
        CustomUri.parse(url, params ?? {}),
        headers: await DataService.getHeaders(),
      );
      _debug(url);
      if (response.statusCode != 200 && response.statusCode != 201) {
        _debug(response.body);
        try {
          _handleError(url: url, response: response);
          if (json.decode(response.body).containsKey('error') && showToast) {
            Fluttertoast.showToast(
                msg: json.decode(response.body)['error'].toString());
          } else if (customToast != null) {
            customToast(response);
          }
        } on FormatException catch (e, stack) {
          _handleException(url: url, exception: e, stackTrace: stack);
          if (showToast)
            Fluttertoast.showToast(
              msg: 'Failed to fetch data',
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
            );
        } on Exception catch (e, stack) {
          _handleException(url: url, exception: e, stackTrace: stack);
        }
        return {'error': "Failed to fetch data"};
      } else {
        if (enableCache) {
          APICacheDBModel cacheDBModel =
              APICacheDBModel(key: url, syncData: response.body);
          await APICacheManager().addCacheData(cacheDBModel);
        }
        return response.body.isNotEmpty
            ? (json.decode(response.body) is List)
                ? {'data': json.decode(response.body)}
                : json.decode(response.body)
            : {"item": []};
      }
    }

    if (enableCache && !isConnected) {
      var data = await getCache(url);
      if (data != null)
        return data;
      else
        return getResponse();
    } else
      return getResponse();
  }

  static Future<Map?> getCache(
    String key,
  ) async {
    var isCacheExists = await APICacheManager().isAPICacheKeyExist(key);
    if (!isCacheExists) {
      return null;
    } else {
      var cacheData = await APICacheManager().getCacheData(key);

      return cacheData.syncData.isNotEmpty
          ? (json.decode(cacheData.syncData) is List)
              ? {'data': json.decode(cacheData.syncData)}
              : json.decode(cacheData.syncData)
          : null;
    }
  }

  static Future<void> emptyCache() async {
    await APICacheManager().emptyCache();
  }

  static Future<Map> post(String url, Map data,
      {bool showToast = true,
      Map<String, String>? params,
      ErrorToastCustomWidget? customToast}) async {
    var result;
    try {
      var fullUrl = CustomUri.parse(url, params ?? {});
      http.Response response = await http.post(
        fullUrl,
        body: json.encode(data),
        headers: await DataService.getHeaders(),
      );
      if (response.statusCode != 200 && response.statusCode != 201) {
        _handleError(url: url, response: response);
        if (showToast && customToast == null)
          Fluttertoast.showToast(
            msg: response.body.isNotEmpty
                ? jsonDecode(response.body)['message']?.toString() ??
                    'Failed to create data'
                : "Failed to create a data",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
          );
        else if (customToast != null) {
          customToast(response);
        }
        result = json.decode(response.body);
      } else {
        result = json.decode(response.body);
      }
    } catch (e, stack) {
      _handleException(exception: e as Exception?, stackTrace: stack, url: url);
    }
    return result;
  }

  static Future<Map> postRaw(String url, data) async {
    var result;
    try {
      isButtonDisabled = true;
      Response response = await Dio().post(
        (env == Env.local ? "http://" : "https://") +
            GlobalConfiguration().getValue<String>('coreDomain') +
            GlobalConfiguration().getValue<String>('baseUri') +
            url,
        data: data,
        options: Options(
          headers: await DataService.getHeaders(),
        ),
      );
      isButtonDisabled = false;
      if (response.statusCode != 200) {
        _handleError(url: url, response: response);
        Fluttertoast.showToast(
          msg: "Failed to create a data",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );
      } else {
        var dataList = response.data.values.toList();
        result = dataList[0];
      }
    } catch (e, stack) {
      _handleException(url: url, exception: e as Exception?, stackTrace: stack);
    }
    return result;
  }

  static Future<Map> put(String url, Map data,
      {Map<String, String>? params,
      bool showToast = true,
      ErrorToastCustomWidget? customToast}) async {
    var result;
    try {
      isButtonDisabled = true;
      var fullUrl = CustomUri.parse(url, params ?? {});
      http.Response response = await http.put(
        fullUrl,
        body: json.encode(data),
        headers: await DataService.getHeaders(),
      );
      isButtonDisabled = false;
      if (response.statusCode != 200 && response.statusCode != 201) {
        _debug(response.body);
        _debug(response.statusCode);
        try {
          _handleError(url: url, response: response);
          if (json.decode(response.body).containsKey('error') && showToast)
            Fluttertoast.showToast(
                msg: json.decode(response.body)['error'].toString());
          else if (customToast != null) {
            customToast(response);
          }
        } on FormatException catch (e, stack) {
          _handleException(url: url, exception: e, stackTrace: stack);
          if (showToast)
            Fluttertoast.showToast(
              msg: 'Failed to update data',
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
            );
        } catch (e, stack) {
          _handleException(
              url: url, exception: e as Exception, stackTrace: stack);
        }
      } else {
        result = json.decode(response.body);
      }
    } catch (e, stack) {
      _handleException(url: url, exception: e as Exception, stackTrace: stack);
    }
    return result;
  }

  static Future<Map> delete(String url,
      {bool showToast = true, ErrorToastCustomWidget? customToast}) async {
    var result;
    try {
      isButtonDisabled = true;
      var fullUrl = CustomUri.parse(url, {});
      http.Response response = await http.delete(
        fullUrl,
        headers: await DataService.getHeaders(),
      );
      isButtonDisabled = false;
      if (response.statusCode != 200) {
        _debug(response.body);
        _debug(response.statusCode);
        _handleError(url: url, response: response);
        if (showToast) {
          Fluttertoast.showToast(
            msg: "Failed to delete",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
          );
        } else if (customToast != null) {
          customToast(response);
        }
      } else {
        result = json.decode(response.body);
      }
    } catch (e, stack) {
      _handleException(url: url, exception: e as Exception, stackTrace: stack);
    }
    return result;
  }

  static Future<Map> patch(String url, Map data,
      {ErrorToastCustomWidget? customToast}) async {
    var result;
    try {
      isButtonDisabled = true;
      var fullUrl = CustomUri.parse(url, {});
      http.Response response = await http.patch(
        fullUrl,
        body: json.encode(data),
        headers: await DataService.getHeaders(),
      );
      isButtonDisabled = false;
      if (response.statusCode != 200) {
        _handleError(url: url, response: response);
        Fluttertoast.showToast(
          msg: response.body.isNotEmpty
              ? jsonDecode(response.body)['error'] ?? 'Failed to update'
              : "Failed to update",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );
      } else {
        if (customToast != null) {
          customToast(response);
        }
        result = json.decode(response.body);
      }
    } catch (e, stack) {
      _handleException(url: url, exception: e as Exception, stackTrace: stack);
    }
    return result;
  }
}
