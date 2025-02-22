import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_di_card/data/repository/card_repository.dart';
import 'package:my_di_card/data/repository/team_repository.dart';
import 'package:retrofit/retrofit.dart';
import '../../data/network/server_error.dart';
import '../../data/repository/auth_repository.dart';
import '../../models/card_get_model.dart';
import '../../models/card_list.dart';
import '../../models/company_type_model.dart';
import '../../models/login_dto.dart';
import '../../models/social_data.dart';
import '../../models/team_member.dart';
import '../../models/team_response.dart';
import '../../models/user_data_model.dart';
import '../../models/utility_dto.dart';
import '../api_resp_state.dart';
import 'package:dio/dio.dart';

class TeamCubit extends Cubit<ResponseState> {
  final TeamRepository teamRepository;

  TeamCubit(this.teamRepository) : super(ResponseStateInitial());


  Future<void> apiCreateUpdateTeam(body,id) async {
    emit(ResponseStateLoading());
    HttpResponse httpResponse;
    UtilityDto dto;
    try {
      httpResponse = await teamRepository.apiCreateUpdateTeam(body,id);
      dto = httpResponse.data as UtilityDto;
      emit(ResponseStateSuccess(dto));
    } on DioError catch (error) {
      emit(ServerError.mapDioErrorToState(error));
    }
  }


  Future<void> apiGetMyTeam() async {
    emit(ResponseStateLoading());
    HttpResponse httpResponse;
    TeamResponse dto;
    try {
      httpResponse = await teamRepository.apiGetMyTeam();
      dto = httpResponse.data as TeamResponse;
      emit(ResponseStateSuccess(dto));
    } on DioError catch (error) {
      emit(ServerError.mapDioErrorToState(error));
    }
  }

  Future<void> apiGetTeamMember(body) async {
    emit(ResponseStateLoading());
    HttpResponse httpResponse;
    TeamMembersResponse dto;
    try {
      httpResponse = await teamRepository.apiGetTeamMember(body);
      dto = httpResponse.data as TeamMembersResponse;
      emit(ResponseStateSuccess(dto));
    } on DioError catch (error) {
      emit(ServerError.mapDioErrorToState(error));
    }
  }


  Future<void> apiRemoveTeamMember(body) async {
    emit(ResponseStateLoading());
    HttpResponse httpResponse;
    UtilityDto dto;
    try {
      httpResponse = await teamRepository.apiRemoveTeamMember(body);
      dto = httpResponse.data as UtilityDto;
      emit(ResponseStateSuccess(dto));
    } on DioError catch (error) {
      emit(ServerError.mapDioErrorToState(error));
    }
  }

  Future<void> apiApproveTeamMember(body) async {
    emit(ResponseStateLoading());
    HttpResponse httpResponse;
    UtilityDto dto;
    try {
      httpResponse = await teamRepository.apiApproveTeamMember(body);
      dto = httpResponse.data as UtilityDto;
      emit(ResponseStateSuccess(dto));
    } on DioError catch (error) {
      emit(ServerError.mapDioErrorToState(error));
    }
  }


  Future<void> apiGetUnApproveTeamMember(body) async {
    emit(ResponseStateLoading());
    HttpResponse httpResponse;
    TeamMembersResponse dto;
    try {
      httpResponse = await teamRepository.apiGetUnApproveTeamMember(body);
      dto = httpResponse.data as TeamMembersResponse;
      emit(ResponseStateSuccess(dto));
    } on DioError catch (error) {
      emit(ServerError.mapDioErrorToState(error));
    }
  }


  Future<void> apiDeleteTeam(id) async {
    emit(ResponseStateLoading());
    HttpResponse httpResponse;
    UtilityDto dto;
    try {
      httpResponse = await teamRepository.apiDeleteTeam(id);
      dto = httpResponse.data as UtilityDto;
      emit(ResponseStateSuccess(dto));
    } on DioError catch (error) {
      emit(ServerError.mapDioErrorToState(error));
    }
  }

}