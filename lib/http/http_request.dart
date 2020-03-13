import 'dart:convert';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:wanandroidflutter/http/api.dart';
import 'package:wanandroidflutter/http/base_response.dart';
import 'package:wanandroidflutter/utils/cookieutil.dart';
import 'package:wanandroidflutter/utils/eventbus.dart';

import 'error_event.dart';

class HttpRequest {
  Dio _dio;
  static String _baseUrl = Api.BASE_URL;
  HttpRequest._internal() {
    _dio = new Dio(BaseOptions(
      baseUrl: _baseUrl,
      connectTimeout: 10000,
      receiveTimeout: 3000,
    ));
    dio.interceptors.add(InterceptorsWrapper(onError: (DioError e) {
      EventUtil.eventBus.fire(e);
      return e;
    }));
  }

  static HttpRequest singleton = HttpRequest._internal();

  factory HttpRequest() => singleton;

  CookieManager _cookieManager;

  get dio {
    return _dio;
  }

  Future<BaseResponse> get(url , {data, options, cancelToken}) async {
    Response response;
    BaseResponse baseResponse;
    String path = await CookieUtil.getCookiePath();
    if (_cookieManager == null) {
      _cookieManager = CookieManager(PersistCookieJar(dir: path));
      _dio.interceptors.add(_cookieManager);
    }
    try {
      response = await dio.get(
        url,
        queryParameters: data,
        options: options,
        cancelToken: cancelToken,
      );
      print('get请求成功!response.data：${response.data}');
      baseResponse = BaseResponse.fromJson(
          response.data is String ? json.decode(response.data) : response.data);
      if (baseResponse.errorCode < 0) {
        EventUtil.eventBus.fire(ErrorEvent(baseResponse.errorCode, baseResponse.errorMessage));
        baseResponse = null;
      }
    } on DioError catch (e) {
      if (CancelToken.isCancel(e)) {
        print('get请求取消! ' + e.message);
      }
      print('get请求发生错误：$e');
    }
    return baseResponse;
  }

  Future<BaseResponse> post(url, {data, options, cancelToken}) async {
    Response response;
    BaseResponse baseResponse;
    String path = await CookieUtil.getCookiePath();
    if (_cookieManager == null) {
      _cookieManager = CookieManager(PersistCookieJar(dir: path));
      _dio.interceptors.add(_cookieManager);
    }
    try {
      response = await dio.post(
        url,
        queryParameters: data,
        options: options,
        cancelToken: cancelToken,
      );
      print('post请求成功!response.data:${response.data}');
      baseResponse = BaseResponse.fromJson(
          response.data is String ? json.decode(response.data) : response.data);
      if (baseResponse.errorCode < 0) {
        EventUtil.eventBus.fire(ErrorEvent(baseResponse.errorCode, baseResponse.errorMessage));
        baseResponse = null;
      }
    } on DioError catch (e) {
      if (CancelToken.isCancel(e)) {
        print('post请求取消! ' + e.message);
      }
      print('post请求发生错误：$e');
    }
    return baseResponse;
  }
}
