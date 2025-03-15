import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_di_card/data/repository/card_repository.dart';
import 'package:my_di_card/data/repository/contact_repository.dart';
import 'package:my_di_card/data/repository/team_repository.dart';
import 'package:my_di_card/models/my_contact_model.dart';
import 'package:my_di_card/models/tag_model.dart';
import 'package:retrofit/retrofit.dart';
import '../../data/network/server_error.dart';
import '../../data/repository/auth_repository.dart';
import '../../models/card_get_model.dart';
import '../../models/card_list.dart';
import '../../models/company_type_model.dart';
import '../../models/login_dto.dart';
import '../../models/meeting_details_model.dart';
import '../../models/my_meetings_model.dart';
import '../../models/social_data.dart';
import '../../models/team_member.dart';
import '../../models/team_response.dart';
import '../../models/user_data_model.dart';
import '../../models/utility_dto.dart';
import '../api_resp_state.dart';
import 'package:dio/dio.dart';

class ContactCubit extends Cubit<ResponseState> {
  final ContactRepository contactRepository;

  ContactCubit(this.contactRepository) : super(ResponseStateInitial());



  Future<void> apiGetMyContact(body) async {
    emit(ResponseStateLoading());
    HttpResponse httpResponse;
    MyContactDto dto;
    try {
      httpResponse = await contactRepository.apiGetMyContact(body);
      dto = httpResponse.data as MyContactDto;
      emit(ResponseStateSuccess(dto));
    } on DioError catch (error) {
      emit(ServerError.mapDioErrorToState(error));
    }
  }

  Future<void> apiGetRecentContact() async {
    emit(ResponseStateLoading());
    HttpResponse httpResponse;
    MyContactDto dto;
    try {
      httpResponse = await contactRepository.apiGetRecentContact();
      dto = httpResponse.data as MyContactDto;
      emit(ResponseStateSuccess(dto));
    } on DioError catch (error) {
      emit(ServerError.mapDioErrorToState(error));
    }
  }


  Future<void> apiGetContactDetail(id) async {
    emit(ResponseStateLoading());
    HttpResponse httpResponse;
    ContactDatum dto;
    try {
      httpResponse = await contactRepository.apiGetContactDetail(id);
      dto = httpResponse.data as ContactDatum;
      emit(ResponseStateSuccess(dto));
    } on DioError catch (error) {
      emit(ServerError.mapDioErrorToState(error));
    }
  }

  Future<void> apiAddContact(body) async {
    emit(ResponseStateLoading());
    HttpResponse httpResponse;
    UtilityDto dto;
    try {
      httpResponse = await contactRepository.apiAddContact(body);
      dto = httpResponse.data as UtilityDto;
      emit(ResponseStateSuccess(dto));
    } on DioError catch (error) {
      emit(ServerError.mapDioErrorToState(error));
    }
  }

  Future<void> apiAddPhysicalCard(body) async {
    emit(ResponseStateLoading());
    HttpResponse httpResponse;
    UtilityDto dto;
    try {
      httpResponse = await contactRepository.apiAddPhysicalCard(body);
      dto = httpResponse.data as UtilityDto;
      emit(ResponseStateSuccess(dto));
    } on DioError catch (error) {
      emit(ServerError.mapDioErrorToState(error));
    }
  }

  Future<void> apiDeleteContact(id) async {
    emit(ResponseStateLoading());
    HttpResponse httpResponse;
    UtilityDto dto;
    try {
      httpResponse = await contactRepository.apiDeleteContact(id);
      dto = httpResponse.data as UtilityDto;
      emit(ResponseStateSuccess(dto));
    } on DioError catch (error) {
      emit(ServerError.mapDioErrorToState(error));
    }
  }


  Future<void> apiCreateMeeting(body) async {
    emit(ResponseStateLoading());
    HttpResponse httpResponse;
    UtilityDto dto;
    try {
      httpResponse = await contactRepository.apiCreateMeeting(body);
      dto = httpResponse.data as UtilityDto;
      emit(ResponseStateSuccess(dto));
    } on DioError catch (error) {
      emit(ServerError.mapDioErrorToState(error));
    }
  }

  Future<void> apiUpdateMeeting(body,id) async {
    emit(ResponseStateLoading());
    HttpResponse httpResponse;
    UtilityDto dto;
    try {
      httpResponse = await contactRepository.apiUpdateMeeting(body,id);
      dto = httpResponse.data as UtilityDto;
      emit(ResponseStateSuccess(dto));
    } on DioError catch (error) {
      emit(ServerError.mapDioErrorToState(error));
    }
  }

  Future<void> apiDeleteMeeting(id) async {
    emit(ResponseStateLoading());
    HttpResponse httpResponse;
    UtilityDto dto;
    try {
      httpResponse = await contactRepository.apiDeleteMeeting(id);
      dto = httpResponse.data as UtilityDto;
      emit(ResponseStateSuccess(dto));
    } on DioError catch (error) {
      emit(ServerError.mapDioErrorToState(error));
    }
  }


  Future<void> apiGetMyMeetings(body) async {
    emit(ResponseStateLoading());
    HttpResponse httpResponse;
    MyMeetingModel dto;
    try {
      httpResponse = await contactRepository.apiGetMyMeetings(body);
      dto = httpResponse.data as MyMeetingModel;
      emit(ResponseStateSuccess(dto));
    } on DioError catch (error) {
      emit(ServerError.mapDioErrorToState(error));
    }
  }

  Future<void> apiGetMeetingDetails(id) async {
    emit(ResponseStateLoading());
    HttpResponse httpResponse;
    MeetingDetailsModel dto;
    try {
      httpResponse = await contactRepository.apiGetMeetingDetails(id);
      dto = httpResponse.data as MeetingDetailsModel;
      emit(ResponseStateSuccess(dto));
    } on DioError catch (error) {
      emit(ServerError.mapDioErrorToState(error));
    }
  }


  Future<void> apiGetCardTag(body) async {
    emit(ResponseStateLoading());
    HttpResponse httpResponse;
    TagModel dto;
    try {
      httpResponse = await contactRepository.apiGetCardTag(body);
      dto = httpResponse.data as TagModel;
      emit(ResponseStateSuccess(dto));
    } on DioError catch (error) {
      emit(ServerError.mapDioErrorToState(error));
    }
  }


  Future<void> apiAddCardTag(body) async {
    emit(ResponseStateLoading());
    HttpResponse httpResponse;
    UtilityDto dto;
    try {
      httpResponse = await contactRepository.apiAddCardTag(body);
      dto = httpResponse.data as UtilityDto;
      emit(ResponseStateSuccess(dto));
    } on DioError catch (error) {
      emit(ServerError.mapDioErrorToState(error));
    }
  }


  Future<void> apiUpdateCardTag(body,id) async {
    emit(ResponseStateLoading());
    HttpResponse httpResponse;
    UtilityDto dto;
    try {
      httpResponse = await contactRepository.apiUpdateCardTag(body,id);
      dto = httpResponse.data as UtilityDto;
      emit(ResponseStateSuccess(dto));
    } on DioError catch (error) {
      emit(ServerError.mapDioErrorToState(error));
    }
  }

  Future<void> apiDeleteCardTag(id) async {
    emit(ResponseStateLoading());
    HttpResponse httpResponse;
    UtilityDto dto;
    try {
      httpResponse = await contactRepository.apiDeleteCardTag(id);
      dto = httpResponse.data as UtilityDto;
      emit(ResponseStateSuccess(dto));
    } on DioError catch (error) {
      emit(ServerError.mapDioErrorToState(error));
    }
  }

  Future<void> apiAddTagInContact(body) async {
    emit(ResponseStateLoading());
    HttpResponse httpResponse;
    UtilityDto dto;
    try {
      httpResponse = await contactRepository.apiAddTagInContact(body);
      dto = httpResponse.data as UtilityDto;
      emit(ResponseStateSuccess(dto));
    } on DioError catch (error) {
      emit(ServerError.mapDioErrorToState(error));
    }
  }


  Future<void> apiContactHideUnHide(id,body) async {
    emit(ResponseStateLoading());
    HttpResponse httpResponse;
    UtilityDto dto;
    try {
      httpResponse = await contactRepository.apiContactHideUnHide(id,body);
      dto = httpResponse.data as UtilityDto;
      emit(ResponseStateSuccess(dto));
    } on DioError catch (error) {
      emit(ServerError.mapDioErrorToState(error));
    }
  }

  Future<void> apiContactFavUnFav(id,body) async {
    emit(ResponseStateLoading());
    HttpResponse httpResponse;
    UtilityDto dto;
    try {
      httpResponse = await contactRepository.apiContactFavUnFav(id,body);
      dto = httpResponse.data as UtilityDto;
      emit(ResponseStateSuccess(dto));
    } on DioError catch (error) {
      emit(ServerError.mapDioErrorToState(error));
    }
  }



}