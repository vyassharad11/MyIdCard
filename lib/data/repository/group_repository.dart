import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../localStorage/storage.dart';
import '../../models/card_get_model.dart';
import '../../models/card_list.dart';
import '../../models/company_type_model.dart';
import '../../models/group_member_model.dart';
import '../../models/group_response.dart';
import '../../models/login_dto.dart';
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
    return _apiClient.apiCreateGroup(dto,token2,body);
  }

  Future<HttpResponse<UtilityDto>> apiUpdateGroup(body,id) async {
    token = await Storage().getToken() ?? "";
    var token2 = "Bearer $token";
    var dto = await Network.baseUrl;
    return _apiClient.apiUpdateGroup(dto,token2,body,id);
  }

  Future<HttpResponse<GroupDataModel>> apiGetGroup() async {
    token = await Storage().getToken() ?? "";
    var token2 = "Bearer $token";
    var dto = await Network.baseUrl;
    return _apiClient.apiGetMyGroup(dto,token2);
  }

  Future<HttpResponse<GroupDataModel>> apiGetGroupDetails(id) async {
    token = await Storage().getToken() ?? "";
    var token2 = "Bearer $token";
    var dto = await Network.baseUrl;
    return _apiClient.apiGetGroupDetails(dto,token2,id);
  }

  Future<HttpResponse<GroupMember>> apiGetGroupMember(id) async {
    token = await Storage().getToken() ?? "";
    var token2 = "Bearer $token";
    var dto = await Network.baseUrl;
    return _apiClient.apiGetGroupMember(dto,token2,id);
  }

  Future<HttpResponse<GroupDataModel>> apiGetGroupByTeam(id) async {
    token = await Storage().getToken() ?? "";
    var token2 = "Bearer $token";
    var dto = await Network.baseUrl;
    return _apiClient.apiGetGroupByTeam(dto,token2,id);
  }

  Future<HttpResponse<GroupMember>> apiGetActiveMemberForGroup() async {
    token = await Storage().getToken() ?? "";
    var token2 = "Bearer $token";
    var dto = await Network.baseUrl;
    return _apiClient.apiGetActiveMemberForGroup(dto,token2);
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
