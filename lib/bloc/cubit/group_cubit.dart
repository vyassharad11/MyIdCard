import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_di_card/data/repository/card_repository.dart';
import 'package:my_di_card/data/repository/group_repository.dart';
import 'package:my_di_card/data/repository/team_repository.dart';
import 'package:retrofit/retrofit.dart';
import '../../data/network/server_error.dart';
import '../../data/repository/auth_repository.dart';
import '../../models/card_get_model.dart';
import '../../models/card_list.dart';
import '../../models/company_type_model.dart';
import '../../models/group_member_model.dart';
import '../../models/group_response.dart';
import '../../models/login_dto.dart';
import '../../models/social_data.dart';
import '../../models/team_member.dart';
import '../../models/team_response.dart';
import '../../models/user_data_model.dart';
import '../../models/utility_dto.dart';
import '../api_resp_state.dart';
import 'package:dio/dio.dart';

class GroupCubit extends Cubit<ResponseState> {
  final GroupRepository groupRepository;

  GroupCubit(this.groupRepository) : super(ResponseStateInitial());


  Future<void> apiCreateGroup(body) async {
    emit(ResponseStateLoading());
    HttpResponse httpResponse;
    UtilityDto dto;
    try {
      httpResponse = await groupRepository.apiCreateGroup(body);
      dto = httpResponse.data as UtilityDto;
      emit(ResponseStateSuccess(dto));
    } on DioError catch (error) {
      emit(ServerError.mapDioErrorToState(error));
    }
  }


 Future<void> apiUpdateGroup(body,id) async {
    emit(ResponseStateLoading());
    HttpResponse httpResponse;
    UtilityDto dto;
    try {
      httpResponse = await groupRepository.apiUpdateGroup(body,id);
      dto = httpResponse.data as UtilityDto;
      emit(ResponseStateSuccess(dto));
    } on DioError catch (error) {
      emit(ServerError.mapDioErrorToState(error));
    }
  }

 Future<void> apiGetGroup() async {
    emit(ResponseStateLoading());
    HttpResponse httpResponse;
    GroupDataModel dto;
    try {
      httpResponse = await groupRepository.apiGetGroup();
      dto = httpResponse.data as GroupDataModel;
      emit(ResponseStateSuccess(dto));
    } on DioError catch (error) {
      emit(ServerError.mapDioErrorToState(error));
    }
  }


 Future<void> apiGetGroupDetails(id) async {
    emit(ResponseStateLoading());
    HttpResponse httpResponse;
    GroupDataModel dto;
    try {
      httpResponse = await groupRepository.apiGetGroupDetails(id);
      dto = httpResponse.data as GroupDataModel;
      emit(ResponseStateSuccess(dto));
    } on DioError catch (error) {
      emit(ServerError.mapDioErrorToState(error));
    }
  }


Future<void> apiGetGroupMember(id) async {
    emit(ResponseStateLoading());
    HttpResponse httpResponse;
    GroupMember dto;
    try {
      httpResponse = await groupRepository.apiGetGroupMember(id);
      dto = httpResponse.data as GroupMember;
      emit(ResponseStateSuccess(dto));
    } on DioError catch (error) {
      emit(ServerError.mapDioErrorToState(error));
    }
  }

Future<void> apiGetGroupByTeam(id) async {
    emit(ResponseStateLoading());
    HttpResponse httpResponse;
    GroupDataModel dto;
    try {
      httpResponse = await groupRepository.apiGetGroupByTeam(id);
      dto = httpResponse.data as GroupDataModel;
      emit(ResponseStateSuccess(dto));
    } on DioError catch (error) {
      emit(ServerError.mapDioErrorToState(error));
    }
  }

Future<void> apiGetActiveMemberForGroup() async {
    emit(ResponseStateLoading());
    HttpResponse httpResponse;
    GroupMember dto;
    try {
      httpResponse = await groupRepository.apiGetActiveMemberForGroup();
      dto = httpResponse.data as GroupMember;
      emit(ResponseStateSuccess(dto));
    } on DioError catch (error) {
      emit(ServerError.mapDioErrorToState(error));
    }
  }

Future<void> apiRemoveGroupMember(body) async {
    emit(ResponseStateLoading());
    HttpResponse httpResponse;
    UtilityDto dto;
    try {
      httpResponse = await groupRepository.apiRemoveGroupMember(body);
      dto = httpResponse.data as UtilityDto;
      emit(ResponseStateSuccess(dto));
    } on DioError catch (error) {
      emit(ServerError.mapDioErrorToState(error));
    }
  }

  Future<void> apiSwitchGroupMemberRole(body) async {
    emit(ResponseStateLoading());
    HttpResponse httpResponse;
    UtilityDto dto;
    try {
      httpResponse = await groupRepository.apiSwitchGroupMemberRole(body);
      dto = httpResponse.data as UtilityDto;
      emit(ResponseStateSuccess(dto));
    } on DioError catch (error) {
      emit(ServerError.mapDioErrorToState(error));
    }
  }


  Future<void> apiAddGroupMember(body) async {
    emit(ResponseStateLoading());
    HttpResponse httpResponse;
    UtilityDto dto;
    try {
      httpResponse = await groupRepository.apiAddGroupMember(body);
      dto = httpResponse.data as UtilityDto;
      emit(ResponseStateSuccess(dto));
    } on DioError catch (error) {
      emit(ServerError.mapDioErrorToState(error));
    }
  }

  Future<void> apiAddTag(body) async {
    emit(ResponseStateLoading());
    HttpResponse httpResponse;
    UtilityDto dto;
    try {
      httpResponse = await groupRepository.apiAddTag(body);
      dto = httpResponse.data as UtilityDto;
      emit(ResponseStateSuccess(dto));
    } on DioError catch (error) {
      emit(ServerError.mapDioErrorToState(error));
    }
  }

  Future<void> apiGetTag(id) async {
    emit(ResponseStateLoading());
    HttpResponse httpResponse;
    UtilityDto dto;
    try {
      httpResponse = await groupRepository.apiGetTag(id);
      dto = httpResponse.data as UtilityDto;
      emit(ResponseStateSuccess(dto));
    } on DioError catch (error) {
      emit(ServerError.mapDioErrorToState(error));
    }
  }

  Future<void> apiUpdateTag(body,id) async {
    emit(ResponseStateLoading());
    HttpResponse httpResponse;
    UtilityDto dto;
    try {
      httpResponse = await groupRepository.apiUpdateTag(body,id);
      dto = httpResponse.data as UtilityDto;
      emit(ResponseStateSuccess(dto));
    } on DioError catch (error) {
      emit(ServerError.mapDioErrorToState(error));
    }
  }

  Future<void> apiDeleteTag(id) async {
    emit(ResponseStateLoading());
    HttpResponse httpResponse;
    UtilityDto dto;
    try {
      httpResponse = await groupRepository.apiDeleteTag(id);
      dto = httpResponse.data as UtilityDto;
      emit(ResponseStateSuccess(dto));
    } on DioError catch (error) {
      emit(ServerError.mapDioErrorToState(error));
    }
  }

}