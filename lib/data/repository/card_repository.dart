import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../localStorage/storage.dart';
import '../../models/background_image_model.dart';
import '../../models/card_get_model.dart';
import '../../models/card_list.dart';
import '../../models/company_type_model.dart';
import '../../models/login_dto.dart';
import '../../models/social_data.dart';
import '../../models/user_data_model.dart';
import '../../models/utility_dto.dart';
import '../../utils/widgets/network.dart';
import '../network/logging_interceptor.dart';
import '../network/rest_client.dart';

class CardRepository {
  final Dio _dio = Dio();
  late RestClient _apiClient;
  String token = "";

  CardRepository() {
    _dio.interceptors.add(LoggingInterceptor());
    _apiClient = RestClient(_dio);
  }


  Future<HttpResponse<UtilityDto>> cardUpdateApi(body,id) async {
    token = await Storage().getToken() ?? "";
    var token2 = "Bearer $token";
    var dto = await Network.baseUrl;

    var headers = {
      'Accept': 'application/json',
      'Authorization': token2
    };
    var dio = Dio();
    var response = await dio.request(
      dto+"card/update/"+id.toString(),
      options: Options(
        method: 'POST',
        headers: headers,
      ),
      data: body,
    );

    // if (response.statusCode == 200) {
    print(" responce "+ json.encode(response.data));
    late UtilityDto _value;
    try {
      _value = UtilityDto.fromJson(response.data!);
    } on Object catch (e, s) {
      // errorLogger?.logError(e, s,);
      print(" error "+ json.encode(response.statusMessage));
      rethrow;
    }
    final httpResponse = HttpResponse(_value, response);
    return httpResponse;


    return _apiClient.cardUpdateApi(dto,body,token2,id);
  }
  Future<HttpResponse<UtilityDto>> cardUpdateApiOld(body,id) async {
    token = await Storage().getToken() ?? "";
    var token2 = "Bearer $token";
    var dto = await Network.baseUrl;
    return _apiClient.cardUpdateApi(dto,body,token2,id);
  }

  Future<HttpResponse<CompanyTypeModel>> apiGetCompanyType() async {
    var url = await Network.baseUrl;
    token = await Storage().getToken() ?? "";
    var token2 = "Bearer $token";
    return _apiClient.apiGetCompanyType(url, token2);
  }

  Future<HttpResponse<GetCardModel>> apiGetCard(id) async {
    var url = await Network.baseUrl;
    token = await Storage().getToken() ?? "";
    var token2 = "Bearer $token";
    return _apiClient.apiGetCard(url, token2,id);
  }

  Future<HttpResponse<CardListModel>> apiGetMyCard() async {
    var url = await Network.baseUrl;
    token = await Storage().getToken() ?? "";
    var token2 = "Bearer $token";
    return _apiClient.apiGetMyCard(url, token2,);
  }

 Future<HttpResponse<SocialForCard>> apiGetSocials() async {
    var url = await Network.baseUrl;
    token = await Storage().getToken() ?? "";
    var token2 = "Bearer $token";
    return _apiClient.apiGetSocials(url, token2,);
  }


  Future<HttpResponse<UtilityDto>> apiDeleteCard(id) async {
    token = await Storage().getToken() ?? "";
    var token2 = "Bearer $token";
    var dto = await Network.baseUrl;
    return _apiClient.apiDeleteCard(dto,token2,id);
  }

  Future<HttpResponse<BackgroundImageModel>> apiGetBackgroundImage() async {
    token = await Storage().getToken() ?? "";
    var token2 = "Bearer $token";
    var dto = await Network.baseUrl;
    return _apiClient.apiGetBackgroundImage(dto,token2,);
  }

}
