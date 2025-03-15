import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../localStorage/storage.dart';
import '../../models/card_get_model.dart';
import '../../models/card_list.dart';
import '../../models/company_type_model.dart';
import '../../models/contact_details_dto.dart';
import '../../models/group_member_model.dart';
import '../../models/group_response.dart';
import '../../models/login_dto.dart';
import '../../models/meeting_details_model.dart';
import '../../models/my_contact_model.dart';
import '../../models/my_group_list_model.dart';
import '../../models/my_meetings_model.dart';
import '../../models/recent_contact_mode.dart';
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


  Future<HttpResponse<MyContactDto>> apiGetMyContact(body) async {
    token = await Storage().getToken() ?? "";
    var token2 = "Bearer $token";
    var dto = await Network.baseUrl;
    return _apiClient.apiGetMyContact(dto,token2,body);
  }

  Future<HttpResponse<RecentContactDto>> apiGetRecentContact() async {
    token = await Storage().getToken() ?? "";
    var token2 = "Bearer $token";
    var dto = await Network.baseUrl;
    return _apiClient.apiGetRecentContact(dto,token2,);
  }


  Future<HttpResponse<ContactDetailsDto>> apiGetContactDetail(id) async {
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


  Future<HttpResponse<UtilityDto>> apiAddPhysicalCard(body,) async {
    token = await Storage().getToken() ?? "";
    var token2 = "Bearer $token";
    var dto = await Network.baseUrl;
    var headers = {
      'Accept': 'application/json',
      'Authorization': token2
    };
    var dio = Dio();
    var response = await dio.request(
      dto+"card/store-physical-card",
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

  Future<HttpResponse<UtilityDto>> apiDeleteContact(id) async {
    token = await Storage().getToken() ?? "";
    var token2 = "Bearer $token";
    var dto = await Network.baseUrl;
    return _apiClient.apiDeleteContact(dto,token2,id);
  }

  Future<HttpResponse<UtilityDto>> apiCreateMeeting(body) async {
    token = await Storage().getToken() ?? "";
    var token2 = "Bearer $token";
    var dto = await Network.baseUrl;
    return _apiClient.apiCreateMeeting(dto,token2,body);
  }

  Future<HttpResponse<UtilityDto>> apiUpdateMeeting(body,id) async {
    token = await Storage().getToken() ?? "";
    var token2 = "Bearer $token";
    var dto = await Network.baseUrl;
    return _apiClient.apiUpdateMeeting(dto,token2,body,id);
  }

  Future<HttpResponse<UtilityDto>> apiDeleteMeeting(id) async {
    token = await Storage().getToken() ?? "";
    var token2 = "Bearer $token";
    var dto = await Network.baseUrl;
    return _apiClient.apiDeleteMeeting(dto,token2,id);
  }

  Future<HttpResponse<MyMeetingModel>> apiGetMyMeetings(body) async {
    token = await Storage().getToken() ?? "";
    var token2 = "Bearer $token";
    var dto = await Network.baseUrl;
    return _apiClient.apiGetMyMeetings(dto,token2,body);
  }

  Future<HttpResponse<MeetingDetailsModel>> apiGetMeetingDetails(id) async {
    token = await Storage().getToken() ?? "";
    var token2 = "Bearer $token";
    var dto = await Network.baseUrl;
    return _apiClient.apiGetMeetingDetails(dto,token2,id);
  }


  Future<HttpResponse<TagModel>> apiGetCardTag(body) async {
    token = await Storage().getToken() ?? "";
    var token2 = "Bearer $token";
    var dto = await Network.baseUrl;
    return _apiClient.apiGetCardTag(dto,token2,body);
  }

  Future<HttpResponse<UtilityDto>> apiAddCardTag(body) async {
    token = await Storage().getToken() ?? "";
    var token2 = "Bearer $token";
    var dto = await Network.baseUrl;
    return _apiClient.apiAddCardTag(dto,token2,body);
  }


  Future<HttpResponse<UtilityDto>> apiUpdateCardTag(body,id) async {
    token = await Storage().getToken() ?? "";
    var token2 = "Bearer $token";
    var dto = await Network.baseUrl;
    return _apiClient.apiUpdateCardTag(dto,token2,body,id);
  }

  Future<HttpResponse<UtilityDto>> apiDeleteCardTag(id) async {
    token = await Storage().getToken() ?? "";
    var token2 = "Bearer $token";
    var dto = await Network.baseUrl;
    return _apiClient.apiDeleteCardTag(dto,token2,id);
  }

  Future<HttpResponse<UtilityDto>> apiAddTagInContact(body) async {
    token = await Storage().getToken() ?? "";
    var token2 = "Bearer $token";
    var dto = await Network.baseUrl;
    return _apiClient.apiAddTagInContact(dto,token2,body);
  }


  Future<HttpResponse<UtilityDto>> apiContactHideUnHide(id,body) async {
    token = await Storage().getToken() ?? "";
    var token2 = "Bearer $token";
    var dto = await Network.baseUrl;
    return _apiClient.apiContactHideUnHide(dto,token2,id,body);
  }

  Future<HttpResponse<UtilityDto>> apiContactFavUnFav(id,body) async {
    token = await Storage().getToken() ?? "";
    var token2 = "Bearer $token";
    var dto = await Network.baseUrl;
    return _apiClient.apiContactFavUnFav(dto,token2,id,body);
  }


  Future<HttpResponse<UtilityDto>> apiUpdateNotes(id,body) async {
    token = await Storage().getToken() ?? "";
    var token2 = "Bearer $token";
    var dto = await Network.baseUrl;
    return _apiClient.apiUpdateNotes(dto,token2,id,body);
  }


}
