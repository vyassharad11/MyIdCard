import 'dart:developer';
import 'package:dio/dio.dart' hide Headers;
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../bloc/api_resp_state.dart';
import '../../localStorage/storage.dart';
import '../../models/error_dto.dart';

class ServerError implements Exception {
  int? _errorCode;
  String? _errorMessage;

  ServerError.withError({DioError? error}) {
    _handleError(error!);
  }

  int? getErrorCode() {
    return _errorCode;
  }

  String? getErrorMessage() {
    return _errorMessage;
  }

  _handleError(DioError error) {
    debugPrint(
        "===Path: ${error.requestOptions.baseUrl}${error.requestOptions.path}");
    debugPrint("===Params: ${error.requestOptions.queryParameters.toString()}");
    debugPrint("===error.type: ${error.type}");
    DioExceptionType.badResponse;
    switch (error.type) {
      case DioExceptionType.cancel:
        _errorMessage = "Request was cancelled";
        break;
      case DioExceptionType.connectionTimeout:
        _errorMessage = "Connection timeout";
        break;
      case DioExceptionType.unknown:
        _errorMessage = "Connection failed due to internet connection";
        break;
      case DioExceptionType.receiveTimeout:
        _errorMessage = "Receive timeout in connection";
        break;
      case DioExceptionType.badResponse:
        ErrorDto errorDto = ErrorDto.fromJson(error.response?.data);
        if (errorDto.message != null) {
          _errorMessage = errorDto.message;
        } else {
          _errorMessage = error.response?.statusMessage;
        }
        debugPrint("===errorBody ${error.response!.data.toString()}");
        _errorCode = error.response?.statusCode;
        break;
      case DioExceptionType.sendTimeout:
        _errorMessage = "Receive timeout in send request";
        break;
      case DioExceptionType.badCertificate:
      // TODO: Handle this case.
        break;
      case DioExceptionType.connectionError:
      // TODO: Handle this case.
        break;
    }
    return _errorMessage;
  }

  static ResponseState mapDioErrorToState(DioError dioError) {
    debugPrint("===dioError.message ${dioError.message}");
    debugPrint("===dioError.message ${dioError.type}");
    debugPrint("===dioError.message ${dioError.response?.statusCode}");
    switch (dioError.type) {
      case DioExceptionType.cancel:
        return const ResponseStateError("Request was cancelled");
      case DioExceptionType.connectionTimeout:
        return const ResponseStateNoInternet("Connection timeout");
      case DioExceptionType.receiveTimeout:
        return const ResponseStateNoInternet("Receive timeout in connection");
      case DioExceptionType.sendTimeout:
        return const ResponseStateNoInternet("Send timeout in request");
      case DioExceptionType.unknown:
        return const ResponseStateNoInternet(
            "Connection failed due to internet connection");
      case DioExceptionType.badResponse:
        try {
          if(dioError.response?.statusCode == 502 || dioError.response?.statusCode == 503 || dioError.response?.statusCode == 401 || dioError.response?.statusCode?.toInt() == 302 || dioError.response?.statusCode?.toInt() == 500) {
            return const ResponseStateError("Service unavailable");
          }
          ErrorDto errorDto = ErrorDto.fromJson(dioError.response?.data);
          if(dioError.response?.statusCode == 404) {
            return ResponseStateEmpty(errorDto.message ?? "");
          }
          if(dioError.response?.statusCode == 403) {
            log("===errorMessage ${errorDto.message}");
            Storage().removeUserFromPreferences();
            // Navigator.of(NavigationService.navigatorKey.currentContext!).pushAndRemoveUntil(
            //     MaterialPageRoute(builder: (_) => const SignInPage()),
            //         (Route<dynamic> route) => false);
            // return const ResponseStateEmpty("Session Expired\n\nYour session has expired. Please re-login to renew your session.");
          }
          if (errorDto.message != null) {
            log("===errorMessage ${errorDto.message}");
            return ResponseStateEmpty(errorDto.message.toString());
          } else {
            log("===errorCode ${dioError.response?.statusCode}");
            log("===errorBody ${dioError.response!.data.toString()}");
            return ResponseStateEmpty(dioError.response?.statusMessage ?? "");
          }
        } on Exception catch (e) {
          debugPrint("Exception ===== $e");
          return ResponseStateEmpty(dioError.response?.data);
        }
      default:
        return const ResponseStateError("Something went wrong");
    }
  }
}