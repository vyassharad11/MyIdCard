import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';

import 'dart:async';

class LoggingInterceptor extends Interceptor {
  // @override
  // void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
  //   print('REQUEST[${options.method}] => PATH: ${options.path}');
  //   return super.onRequest(options, handler);
  // }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    logPrint('***** API Request - Start *****');

    printKV('URI', options.uri);
    printKV('METHOD', options.method);
    logPrint('HEADERS:');
    options.headers.forEach((key, v) => printKV(' - $key', v));
    logPrint('BODY:');
    printAll(options.data ?? "");

    logPrint('***** API Request - End *****');

    return super.onRequest(options, handler);
  }

  // @override
  // void onResponse(Response response, ResponseInterceptorHandler handler) {
  //   print(
  //     'RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions
  //         .path}',
  //   );
  //   return super.onResponse(response, handler);
  // }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    logPrint('***** Api Response - Start *****');

    printKV('URI', response.requestOptions.uri);
    printKV('STATUS CODE', response.statusCode);
    printKV('REDIRECT', response.isRedirect);
    logPrint('BODY:');
    printAll(response.data ?? "");

    logPrint('***** Api Response - End *****');

    return super.onResponse(response, handler);
  }

  // @override
  // void onError(DioError err, ErrorInterceptorHandler handler) {
  //   print(
  //     'ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}',
  //   );
  //   return super.onError(err, handler);
  // }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    logPrint('***** Api Error - Start *****:');

    logPrint('URI: ${err.requestOptions.uri}');
    if (err.response != null) {
      logPrint('STATUS CODE: ${err.response?.statusCode?.toString()}');
    }
    logPrint('$err');
    if (err.response != null) {
      printKV('REDIRECT', err.response?.realUri);
      logPrint('BODY:');
      printAll(err.response?.toString());
    }

    logPrint('***** Api Error - End *****:');
    return super.onError(err, handler);
  }

  void printKV(String key, dynamic v) {
    logPrint('$key: $v');
  }

  void printAll(msg) {
    const JsonEncoder encoder = JsonEncoder.withIndent(' ');
    final dynamic prettyString = encoder.convert(msg);
    // prettyString.split('\n').forEach((dynamic element) => print(element));
    print(msg);
  }

  void logPrint(String? s) {
    print(s);
  }
}