import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/dio.dart' hide Headers;
import 'package:flutter/material.dart';
import 'package:my_di_card/models/utility_dto.dart';
import 'package:retrofit/retrofit.dart';

import '../../models/login_dto.dart';
import '../../models/user_data_model.dart';
import '../../utils/widgets/network.dart';
part 'rest_client.g.dart';

@RestApi(baseUrl: Network.baseUrl)
abstract class RestClient {
  factory RestClient(Dio dio, {String baseUrl}) = _RestClient;

  static const header = [
    "Accept: application/json",
    "Content-Type: application/json"
  ];
  static const headerValue = "Accept: application/json";
  static const headerContentType = "Content-Type: application/json";
  static const authorization = "Authorization";

  // @GET("base.json")
  // @Header(headerValue)
  // Future<HttpResponse<BaseUrlDto>> apiBaseUrl();

  @POST("{url}auth/signup")
  @Header(headerValue)
  @Header(headerContentType)
  @FormUrlEncoded()
  Future<HttpResponse<UtilityDto>> apiSignUp(@Path("url") url,
       @Body() body);


  @POST("{url}oauth/google/login/callback")
  @Header(headerValue)
  @Header(headerContentType)
  @FormUrlEncoded()
  Future<HttpResponse<LoginDto>> apiSignupGoogle(@Path("url") url,
       @Body() body);


@POST("{url}oauth/apple/login/callback")
  @Header(headerValue)
  @Header(headerContentType)
  @FormUrlEncoded()
  Future<HttpResponse<LoginDto>> apiSignupApple(@Path("url") url,
       @Body() body);

@POST("{url}auth/verify-code")
  @Header(headerValue)
  @Header(headerContentType)
  @FormUrlEncoded()
  Future<HttpResponse<LoginDto>> otpRegisterApi(@Path("url") url,
       @Body() body);


@POST("{url}auth/resend-verify-code")
  @Header(headerValue)
  @Header(headerContentType)
  @FormUrlEncoded()
  Future<HttpResponse<UtilityDto>> otpResendApi(@Path("url") url,);


  @POST("{url}user/complete-profile")
  @Header(headerValue)
  @Header(headerContentType)
  @FormUrlEncoded()
  Future<HttpResponse<LoginDto>> completeProfileApi(@Path("url") url,
      @Body() body, @Header(authorization) token,@Part() File part);

 @POST("{url}card/update/{id}")
  @Header(headerValue)
  @Header(headerContentType)
  @FormUrlEncoded()
  Future<HttpResponse<UtilityDto>> cardUpdateApi(@Path("url") url,
      @Body() body, @Header(authorization) token,  @Path("id") id,);


}
