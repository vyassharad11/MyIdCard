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

class GroupRepository {
  final Dio _dio = Dio();
  late RestClient _apiClient;
  String token = "";

  GroupRepository() {
    _dio.interceptors.add(LoggingInterceptor());
    _apiClient = RestClient(_dio);
  }

  Future<HttpResponse<UtilityDto>> apiCreateGroup(body) async {
    token = await Storage().getToken() ?? "";
    var token2 = "Bearer $token";
    var dto = await Network.baseUrl;

    var headers = {
      'Accept': 'application/json',
      'Authorization': token2
    };
    var dio = Dio();
    var response = await dio.request(
      dto+"group/store",
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



     return _apiClient.apiCreateGroup(dto,token2,body);
  }

  Future<HttpResponse<UtilityDto>> apiUpdateGroup(body,id) async {
    token = await Storage().getToken() ?? "";
    var token2 = "Bearer $token";
    var dto = await Network.baseUrl;
    var headers = {
      'Accept': 'application/json',
      'Authorization': token2
    };
    var dio = Dio();
    // print(" requestOptions "+ (body));

    var response = await dio.request(
      dto+"group/update/"+id.toString(),
      options: Options(
        method: 'POST',
        headers: headers,
      ),
      data: body,
    );
    // print(" requestOptions "+ json.encode(response.requestOptions));

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


    return _apiClient.apiUpdateGroup(dto,token2,body,id);
  }

  Future<HttpResponse<UtilityDto>> apiDeleteGroup(id) async {
    token = await Storage().getToken() ?? "";
    var token2 = "Bearer $token";
    var dto = await Network.baseUrl;
    return _apiClient.apiDeleteGroup(dto,token2,id);
  }

  Future<HttpResponse<MyGroupListModel>> apiGetMyGroups() async {
    token = await Storage().getToken() ?? "";
    var token2 = "Bearer $token";
    var dto = await Network.baseUrl;
    return _apiClient.apiGetMyGroups(dto,token2);
  }

  Future<HttpResponse<GroupDataModel>> apiGetGroupDetails(id) async {
    token = await Storage().getToken() ?? "";
    var token2 = "Bearer $token";
    var dto = await Network.baseUrl;
    return _apiClient.apiGetGroupDetails(dto,token2,id);
  }

  Future<HttpResponse<GroupMember>> apiGetGroupMember(id,body) async {
    token = await Storage().getToken() ?? "";
    var token2 = "Bearer $token";
    var dto = await Network.baseUrl;
    return _apiClient.apiGetGroupMember(dto,token2,id,body);
  }

  Future<HttpResponse<GroupMember>> apiGetAllGroupMembers(body) async {
    token = await Storage().getToken() ?? "";
    var token2 = "Bearer $token";
    var dto = await Network.baseUrl;
    return _apiClient.apiGetAllGroupMembers(dto,token2,body);
  }

  Future<HttpResponse<GroupDataModel>> apiGetGroupByTeam(id) async {
    token = await Storage().getToken() ?? "";
    var token2 = "Bearer $token";
    var dto = await Network.baseUrl;
    return _apiClient.apiGetGroupByTeam(dto,token2,id);
  }

  Future<HttpResponse<GroupMember>> apiGetActiveMemberForGroup(body) async {
    token = await Storage().getToken() ?? "";
    var token2 = "Bearer $token";
    var dto = await Network.baseUrl;
    return _apiClient.apiGetActiveMemberForGroup(dto,token2,body);
  }


Future<HttpResponse<UtilityDto>> apiRemoveGroupMember(body) async {
    token = await Storage().getToken() ?? "";
    var token2 = "Bearer $token";
    var dto = await Network.baseUrl;
    return _apiClient.apiRemoveGroupMember(dto,token2,body);
  }

Future<HttpResponse<UtilityDto>> apiSwitchGroupMemberRole(body) async {
    token = await Storage().getToken() ?? "";
    var token2 = "Bearer $token";
    var dto = await Network.baseUrl;
    return _apiClient.apiSwitchGroupMemberRole(dto,token2,body);
  }

Future<HttpResponse<UtilityDto>> apiAddGroupMember(body) async {
    token = await Storage().getToken() ?? "";
    var token2 = "Bearer $token";
    var dto = await Network.baseUrl;
    return _apiClient.apiAddGroupMember(dto,token2,body);
  }

Future<HttpResponse<UtilityDto>> apiAddTag(body) async {
    token = await Storage().getToken() ?? "";
    var token2 = "Bearer $token";
    var dto = await Network.baseUrl;
    return _apiClient.apiAddTag(dto,token2,body);
  }

Future<HttpResponse<UtilityDto>> apiGetTag(id) async {
    token = await Storage().getToken() ?? "";
    var token2 = "Bearer $token";
    var dto = await Network.baseUrl;
    return _apiClient.apiGetTag(dto,token2,id);
  }

Future<HttpResponse<TagModel>> apiGetTeamTag() async {
    token = await Storage().getToken() ?? "";
    var token2 = "Bearer $token";
    var dto = await Network.baseUrl;
    return _apiClient.apiGetTeamTag(dto,token2,);
  }

Future<HttpResponse<UtilityDto>> apiUpdateTag(body,id) async {
    token = await Storage().getToken() ?? "";
    var token2 = "Bearer $token";
    var dto = await Network.baseUrl;
    return _apiClient.apiUpdateTag(dto,token2,body,id);
  }


Future<HttpResponse<UtilityDto>> apiDeleteTag(id) async {
    token = await Storage().getToken() ?? "";
    var token2 = "Bearer $token";
    var dto = await Network.baseUrl;
    return _apiClient.apiDeleteTag(dto,token2,id);
  }

}
