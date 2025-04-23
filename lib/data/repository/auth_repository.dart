import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../localStorage/storage.dart';
import '../../models/login_dto.dart';
import '../../models/signup_dto.dart';
import '../../models/user_data_model.dart';
import '../../models/utility_dto.dart';
import '../../utils/widgets/network.dart';
import '../network/logging_interceptor.dart';
import '../network/rest_client.dart';

class AuthRepository {
  final Dio _dio = Dio();
  late RestClient _apiClient;
  // AppSession? appSession;
  String token = "";

  AuthRepository() {
    _dio.interceptors.add(LoggingInterceptor());
    _apiClient = RestClient(_dio);
    // appSession = AppSession();
  }

  // Future<HttpResponse<NotificationListDto>> apiyogaVideoList() async {
  //   SharedPreferences sharedUser = await SharedPreferences.getInstance();
  //   var user = sharedUser.getString("user");
  //   if (user != null && user.isNotEmpty) {
  //     var jsonObj = jsonDecode(sharedUser.getString('user').toString());
  //     UserDto u = UserDto.fromJson(jsonObj);
  //     token = "Bearer " + u.result!.token.toString();
  //   }
  //   print("token : ${token}");
  //   return _apiClient.apiNotificationList(token,limit,offset);
  // }

  // Future<HttpResponse<BaseUrlDto>> apiBaseUrl() async {
  //   return _apiClient.apiBaseUrl();
  // }

  Future<HttpResponse<UtilityDto>> apiSignUp(body) async {
    var dto = await Network.baseUrl;
    return _apiClient.apiSignUp(dto, body);
  }

  Future<HttpResponse<LoginDto>> apiSignIn(body) async {
    var dto = await Network.baseUrl;
    return _apiClient.apiSignIn(dto, body);
  }

  Future<HttpResponse<User>> apiUserProfile() async {
    token = await Storage().getToken() ?? "";
    var token2 = "Bearer $token";
    var dto = await Network.baseUrl;
    return _apiClient.apiUserProfile(dto, token2);
  }


  Future<HttpResponse<LoginDto>> apiSignupGoogle(body) async {
    var dto = await Network.baseUrl;
    return _apiClient.apiSignupGoogle(dto, body);
  }


  Future<HttpResponse<LoginDto>> apiSignupApple(body) async {
    var dto = await Network.baseUrl;
    return _apiClient.apiSignupApple(dto, body);
  }

  Future<HttpResponse<LoginDto>> otpRegisterApi(body) async {
    var dto = await Network.baseUrl;
    return _apiClient.otpRegisterApi(dto, body);
  }

  Future<HttpResponse<UtilityDto>> otpResendApi(body) async {
    var dto = await Network.baseUrl;
    return _apiClient.otpResendApi(dto,body);
  }

  Future<HttpResponse<LoginDto>> completeProfileApi(body,) async {
    token = await Storage().getToken() ?? "";
    var token2 = "Bearer $token";
    var dto = await Network.baseUrl;
    return _apiClient.completeProfileApi(dto,body,token2,);
  }
  Future<HttpResponse<SignupDto>> completeProfileApiNew(body,) async {
    token = await Storage().getToken() ?? "";
    var token2 = "Bearer $token";
    var dto = await Network.baseUrl;
    var headers = {
      'Accept': 'application/json',
      'Authorization': token2
    };
    var dio = Dio();
    var response = await dio.request(
      dto+"user/complete-profile",
      options: Options(
        method: 'POST',
        headers: headers,
      ),
      data: body,
    );

    // if (response.statusCode == 200) {
    print(" responce "+ json.encode(response.data));
    late SignupDto _value;
    try {
      _value = SignupDto.fromJson(response.data!);
    } on Object catch (e, s) {
      // errorLogger?.logError(e, s,);
      print(" error "+ json.encode(response.statusMessage));
      rethrow;
    }
    final httpResponse = HttpResponse(_value, response);
    return httpResponse;


     // return _apiClient.completeProfileApi(dto,body,token2,);
  }

  Future<HttpResponse<UtilityDto>> apiSetPlan(body,) async {
    token = await Storage().getToken() ?? "";
    var token2 = "Bearer $token";
    var dto = await Network.baseUrl;
    return _apiClient.apiSetPlan(dto,body,token2,);
  }

  Future<HttpResponse<UtilityDto>> apiSupport(body,) async {
    token = await Storage().getToken() ?? "";
    var token2 = "Bearer $token";
    var dto = await Network.baseUrl;
    return _apiClient.apiSupport(dto,token2,body,);
  }

  Future<HttpResponse<UtilityDto>> apiGetTerms() async {
    token = await Storage().getToken() ?? "";
    var token2 = "Bearer $token";
    var dto = await Network.baseUrl;
    return _apiClient.apiGetTerms(dto,token2,);
  }

 Future<HttpResponse<UtilityDto>> apiGetPrivacy() async {
    token = await Storage().getToken() ?? "";
    var token2 = "Bearer $token";
    var dto = await Network.baseUrl;
    return _apiClient.apiGetPrivacy(dto,token2,);
  }


}
