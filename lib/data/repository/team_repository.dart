import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../localStorage/storage.dart';
import '../../models/card_get_model.dart';
import '../../models/card_list.dart';
import '../../models/company_type_model.dart';
import '../../models/login_dto.dart';
import '../../models/social_data.dart';
import '../../models/team_member.dart';
import '../../models/team_response.dart';
import '../../models/user_data_model.dart';
import '../../models/utility_dto.dart';
import '../../utils/widgets/network.dart';
import '../network/logging_interceptor.dart';
import '../network/rest_client.dart';

class TeamRepository {
  final Dio _dio = Dio();
  late RestClient _apiClient;
  String token = "";

  TeamRepository() {
    _dio.interceptors.add(LoggingInterceptor());
    _apiClient = RestClient(_dio);
  }



  Future<HttpResponse<UtilityDto>> apiCreateUpdateTeam(body,id) async {
    token = await Storage().getToken() ?? "";
    var token2 = "Bearer $token";
    var dto = await Network.baseUrl;
    var headers = {
      'Accept': 'application/json',
      'Authorization': token2
    };
    var dio = Dio();
    var response = await dio.request(
      dto+"team/update/"+id.toString(),
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
    }
    // else {
    //   print(response.statusMessage);
    // }
    //
    //  return _apiClient.apiCreateUpdateTeam(dto,token2,id,apiCreateUpdateTeam,body);


  Future<HttpResponse<TeamResponse>> apiGetMyTeam() async {
    token = await Storage().getToken() ?? "";
    var token2 = "Bearer $token";
    var dto = await Network.baseUrl;
    return _apiClient.apiGetMyTeam(dto,token2,);
  }

  Future<HttpResponse<TeamMembersResponse>> apiGetTeamMember(body) async {
    token = await Storage().getToken() ?? "";
    var token2 = "Bearer $token";
    var dto = await Network.baseUrl;
    return _apiClient.apiGetTeamMember(dto,token2,body);
  }

  Future<HttpResponse<UtilityDto>> apiRemoveTeamMember(body) async {
    token = await Storage().getToken() ?? "";
    var token2 = "Bearer $token";
    var dto = await Network.baseUrl;
    return _apiClient.apiRemoveTeamMember(dto,token2,body);
  }

  Future<HttpResponse<UtilityDto>> apiLeaveTeam() async {
    token = await Storage().getToken() ?? "";
    var token2 = "Bearer $token";
    var dto = await Network.baseUrl;
    return _apiClient.apiLeaveTeam(dto,token2,);
  }


  Future<HttpResponse<UtilityDto>> apiApproveTeamMember(body) async {
    token = await Storage().getToken() ?? "";
    var token2 = "Bearer $token";
    var dto = await Network.baseUrl;
    return _apiClient.apiApproveTeamMember(dto,token2,body);
  }

  Future<HttpResponse<TeamMembersResponse>> apiGetUnApproveTeamMember(body) async {
    token = await Storage().getToken() ?? "";
    var token2 = "Bearer $token";
    var dto = await Network.baseUrl;
    return _apiClient.apiGetUnApproveTeamMember(dto,token2,body);
  }

  Future<HttpResponse<UtilityDto>> apiDeleteTeam(body,) async {
    token = await Storage().getToken() ?? "";
    var token2 = "Bearer $token";
    var dto = await Network.baseUrl;
    return _apiClient.apiDeleteTeam(dto,token2,body,);
  }

}
