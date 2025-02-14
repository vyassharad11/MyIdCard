import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:retrofit/retrofit.dart';
import '../../data/network/server_error.dart';
import '../../data/repository/auth_repository.dart';
import '../../models/login_dto.dart';
import '../../models/user_data_model.dart';
import '../../models/utility_dto.dart';
import '../api_resp_state.dart';
import 'package:dio/dio.dart';

class AuthCubit extends Cubit<ResponseState> {
  final AuthRepository authRepository;

  AuthCubit(this.authRepository) : super(ResponseStateInitial());

  Future<void> apiSignUp(body) async {
    emit(ResponseStateLoading());
    HttpResponse httpResponse;
    UtilityDto dto;
    try {
      httpResponse = await authRepository.apiSignUp(body);
      dto = httpResponse.data as UtilityDto;
      // await AppSession().storeAccessToken(dto.token ?? "");
      emit(ResponseStateSuccess(dto));
    } on DioError catch (error) {
      emit(ServerError.mapDioErrorToState(error));
    }
  }


  Future<void> apiSignupGoogle(body) async {
    emit(ResponseStateLoading());
    HttpResponse httpResponse;
    LoginDto dto;
    try {
      httpResponse = await authRepository.apiSignupGoogle(body);
      dto = httpResponse.data as LoginDto;
      // await AppSession().storeAccessToken(dto.token ?? "");
      emit(ResponseStateSuccess(dto));
    } on DioError catch (error) {
      emit(ServerError.mapDioErrorToState(error));
    }
  }


  Future<void> apiSignupApple(body) async {
    emit(ResponseStateLoading());
    HttpResponse httpResponse;
    LoginDto dto;
    try {
      httpResponse = await authRepository.apiSignupApple(body);
      dto = httpResponse.data as LoginDto;
      // await AppSession().storeAccessToken(dto.token ?? "");
      emit(ResponseStateSuccess(dto));
    } on DioError catch (error) {
      emit(ServerError.mapDioErrorToState(error));
    }
  }


  Future<void> otpRegisterApi(body) async {
    emit(ResponseStateLoading());
    HttpResponse httpResponse;
    LoginDto dto;
    try {
      httpResponse = await authRepository.otpRegisterApi(body);
      dto = httpResponse.data as LoginDto;
      // await AppSession().storeAccessToken(dto.token ?? "");
      emit(ResponseStateSuccess(dto));
    } on DioError catch (error) {
      emit(ServerError.mapDioErrorToState(error));
    }
  }

  Future<void> otpResendApi() async {
    emit(ResponseStateLoading());
    HttpResponse httpResponse;
    UtilityDto dto;
    try {
      httpResponse = await authRepository.otpResendApi();
      dto = httpResponse.data as UtilityDto;
      emit(ResponseStateSuccess(dto));
    } on DioError catch (error) {
      emit(ServerError.mapDioErrorToState(error));
    }
  }



  Future<void> completeProfileApi(body,file) async {
    emit(ResponseStateLoading());
    HttpResponse httpResponse;
    LoginDto dto;
    try {
      httpResponse = await authRepository.completeProfileApi(body,file);
      dto = httpResponse.data as LoginDto;
      // await AppSession().storeAccessToken(dto.token ?? "");
      emit(ResponseStateSuccess(dto));
    } on DioError catch (error) {
      emit(ServerError.mapDioErrorToState(error));
    }
  }

}