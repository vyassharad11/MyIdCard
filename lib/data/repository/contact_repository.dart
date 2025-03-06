import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../localStorage/storage.dart';
import '../../models/card_get_model.dart';
import '../../models/card_list.dart';
import '../../models/company_type_model.dart';
import '../../models/group_member_model.dart';
import '../../models/group_response.dart';
import '../../models/login_dto.dart';
import '../../models/my_contact_model.dart';
import '../../models/my_group_list_model.dart';
import '../../models/social_data.dart';
import '../../models/tag_model.dart';
import '../../models/team_member.dart';
import '../../models/team_response.dart';
import '../../models/user_data_model.dart';
import '../../models/utility_dto.dart';
import '../../utils/widgets/network.dart';
import '../network/logging_interceptor.dart';
import '../network/rest_client.dart';

class ContactRepository {
  final Dio _dio = Dio();
  late RestClient _apiClient;
  String token = "";

  ContactRepository() {
    _dio.interceptors.add(LoggingInterceptor());
    _apiClient = RestClient(_dio);
  }


  Future<HttpResponse<MyContactDto>> apiGetMyContact() async {
    token = await Storage().getToken() ?? "";
    var token2 = "Bearer $token";
    var dto = await Network.baseUrl;
    return _apiClient.apiGetMyContact(dto,token2,);
  }


  Future<HttpResponse<ContactDetailsDatum>> apiGetContactDetail(id) async {
    token = await Storage().getToken() ?? "";
    var token2 = "Bearer $token";
    var dto = await Network.baseUrl;
    return _apiClient.apiGetContactDetail(dto,token2,id);
  }

  Future<HttpResponse<UtilityDto>> apiAddContact(body) async {
    token = await Storage().getToken() ?? "";
    var token2 = "Bearer $token";
    var dto = await Network.baseUrl;
    return _apiClient.apiAddContact(dto,token2,body);
  }


}
