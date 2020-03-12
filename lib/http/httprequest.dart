import 'dart:convert';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wanandroidflutter/constant/Constants.dart';
import 'package:wanandroidflutter/http/api.dart';
import 'package:wanandroidflutter/http/baseresponse.dart';
import 'package:wanandroidflutter/login/LoginFragment.dart';

class HttpRequest {
  static String _baseUrl = Api.BASE_URL;
  static HttpRequest instance;

  Dio dio;
  BaseOptions options;

  CancelToken cancelToken = CancelToken();

  static HttpRequest getInstance() {
    if (instance == null) {
      instance = HttpRequest();
    }
    return instance;
  }

  HttpRequest() {
    options = BaseOptions(
      baseUrl: _baseUrl,
      connectTimeout: 5000,
      receiveTimeout: 15000,
      headers: {"version": "1.0.0"},
      responseType: ResponseType.plain,
    );
    dio = Dio(options);
    dio.interceptors.add(CookieManager(CookieJar()));
  }

  get(url,
      {data,
      options,
      cancelToken,
      BuildContext context,
      Function successCallBack,
      Function errorCallBack}) async {
    Response response;
    try {
      response = await dio.get(url,
          queryParameters: data, options: options, cancelToken: cancelToken);
    } on DioError catch (e) {
      handlerError(e);
    }
    if (response.data != null) {
      BaseResponse baseResponse =
          BaseResponse.fromJson(json.decode(response.data));
      if (baseResponse != null) {
        switch (baseResponse.errorCode) {
          case 0:
            successCallBack(jsonEncode(baseResponse.data));
            break;
          case -1001:
            /// 返回-1001跳转到登录页
            errorCallBack(baseResponse.errorCode, baseResponse.errorMessage);
            if (context != null) {
              Navigator.of(context)
                  .push(new MaterialPageRoute(builder: (context) {
                return new Scaffold(
                  body: new LoginFragment(),
                );
              }));
            }
            break;
          default:
            errorCallBack(baseResponse.errorCode, baseResponse.errorMessage);
            break;
        }
      } else {
        errorCallBack(Constants.NETWORK_JSON_EXCEPTION, "网络数据问题");
      }
    } else {
      errorCallBack(Constants.NETWORK_ERROR, "网络出错啦，请稍后重试");
    }
  }

  post(url,
      {data,
      options,
      cancelToken,
      BuildContext context,
      Function successCallBack,
      Function errorCallBack}) async {
    Response response;
    try {
      response = await dio.post(url,
          queryParameters: data, options: options, cancelToken: cancelToken);
    } on DioError catch (e) {
      handlerError(e);
    }
    if (response.data != null) {
      BaseResponse baseResponse =
          BaseResponse.fromJson(json.decode(response.data));
      if (baseResponse != null) {
        switch (baseResponse.errorCode) {
          case 0:
            successCallBack(jsonEncode(baseResponse.data));
            break;
          case -1001:
            errorCallBack(baseResponse.errorCode, baseResponse.errorMessage);
            if (context != null) {
              Navigator.of(context)
                  .push(new MaterialPageRoute(builder: (context) {
                return new Scaffold(
                  body: new LoginFragment(),
                );
              }));
            }
            break;
          default:
            errorCallBack(baseResponse.errorCode, baseResponse.errorMessage);
            break;
        }
      } else {
        errorCallBack(Constants.NETWORK_JSON_EXCEPTION, "网络数据问题");
      }
    } else {
      errorCallBack(Constants.NETWORK_ERROR, "网络出错啦，请稍后重试");
    }
  }

  handlerError(DioError e) {
    if (e.type == DioErrorType.CONNECT_TIMEOUT) {
      print("连接超时");
    } else if (e.type == DioErrorType.SEND_TIMEOUT) {
      print("请求超时");
    } else if (e.type == DioErrorType.RECEIVE_TIMEOUT) {
      print("响应超时");
    } else if (e.type == DioErrorType.RESPONSE) {
      print("响应异常");
    } else if (e.type == DioErrorType.CANCEL) {
      print("请求取消");
    } else {
      print("未知错误");
    }
  }
}
