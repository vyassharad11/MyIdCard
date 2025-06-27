import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_di_card/data/repository/card_repository.dart';
import 'package:retrofit/retrofit.dart';
import '../../data/network/server_error.dart';
import '../../data/repository/auth_repository.dart';
import '../../models/background_image_model.dart';
import '../../models/card_get_model.dart';
import '../../models/card_list.dart';
import '../../models/company_type_model.dart';
import '../../models/login_dto.dart';
import '../../models/social_data.dart';
import '../../models/user_data_model.dart';
import '../../models/utility_dto.dart';
import '../api_resp_state.dart';
import 'package:dio/dio.dart';

class CardCubit extends Cubit<ResponseState> {
  final CardRepository authRepository;

  CardCubit(this.authRepository) : super(ResponseStateInitial());



  Future<void> cardUpdateApi(body,id) async {
    emit(ResponseStateLoading());
    HttpResponse httpResponse;
    UtilityDto dto;
    try {
      httpResponse = await authRepository.cardUpdateApi(body,id);
      dto = httpResponse.data as UtilityDto;
      emit(ResponseStateSuccess(dto));
    } on DioError catch (error) {
      emit(ServerError.mapDioErrorToState(error));
    }
  }
  Future<void> cardUpdateApiOld(body,id) async {
    emit(ResponseStateLoading());
    HttpResponse httpResponse;
    UtilityDto dto;
    try {
      httpResponse = await authRepository.cardUpdateApiOld(body,id);
      dto = httpResponse.data as UtilityDto;
      emit(ResponseStateSuccess(dto));
    } on DioError catch (error) {
      emit(ServerError.mapDioErrorToState(error));
    }
  }




  Future<void> apiGetCompanyType() async {
    emit(ResponseStateLoading());
    HttpResponse httpResponse;
    CompanyTypeModel dto;
    try {
      httpResponse = await authRepository.apiGetCompanyType();
      dto = httpResponse.data as CompanyTypeModel;
      emit(ResponseStateSuccess(dto));
    } on DioError catch (error) {
      emit(ServerError.mapDioErrorToState(error));
    }
  }


  Future<void> apiGetCard(id) async {
    emit(ResponseStateLoading());
    HttpResponse httpResponse;
    GetCardModel dto;
    try {
      httpResponse = await authRepository.apiGetCard(id);
      dto = httpResponse.data as GetCardModel;
      emit(ResponseStateSuccess(dto));
    } on DioError catch (error) {
      emit(ServerError.mapDioErrorToState(error));
    }
  }

  Future<void> apiGetMyCard() async {
    emit(ResponseStateLoading());
    HttpResponse httpResponse;
    CardListModel dto;
    try {
      httpResponse = await authRepository.apiGetMyCard();
      dto = httpResponse.data as CardListModel;
      emit(ResponseStateSuccess(dto));
    } on DioError catch (error) {
      emit(ServerError.mapDioErrorToState(error));
    }
  }

  Future<void> apiGetSocials() async {
    emit(ResponseStateLoading());
    HttpResponse httpResponse;
    SocialForCard dto;
    try {
      httpResponse = await authRepository.apiGetSocials();
      dto = httpResponse.data as SocialForCard;
      emit(ResponseStateSuccess(dto));
    } on DioError catch (error) {
      emit(ServerError.mapDioErrorToState(error));
    }
  }

  Future<void> apiDeleteCard(id) async {
    emit(ResponseStateLoading());
    HttpResponse httpResponse;
    UtilityDto dto;
    try {
      httpResponse = await authRepository.apiDeleteCard(id);
      dto = httpResponse.data as UtilityDto;
      emit(ResponseStateSuccess(dto));
    } on DioError catch (error) {
      emit(ServerError.mapDioErrorToState(error));
    }
  }

Future<void> apiGetBackgroundImage() async {
    emit(ResponseStateLoading());
    HttpResponse httpResponse;
    BackgroundImageModel dto;
    try {
      httpResponse = await authRepository.apiGetBackgroundImage();
      dto = httpResponse.data as BackgroundImageModel;
      emit(ResponseStateSuccess(dto));
    } on DioError catch (error) {
      emit(ServerError.mapDioErrorToState(error));
    }
  }

}