import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:retrofit/retrofit.dart';
import '../../data/network/server_error.dart';
import '../../data/repository/auth_repository.dart';
import '../../models/login_dto.dart';
import '../../models/notification_model.dart';
import '../../models/signup_dto.dart';
import '../../models/subscription_model.dart';
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

  Future<void> apiSignIn(body) async {
    emit(ResponseStateLoading());
    HttpResponse httpResponse;
    LoginDto dto;
    try {
      httpResponse = await authRepository.apiSignIn(body);
      dto = httpResponse.data as LoginDto;
      // await AppSession().storeAccessToken(dto.token ?? "");
      emit(ResponseStateSuccess(dto));
    } on DioError catch (error) {
      emit(ServerError.mapDioErrorToState(error));
    }
  }

  Future<void> apiUserProfile() async {
    emit(ResponseStateLoading());
    HttpResponse httpResponse;
    User dto;
    try {
      httpResponse = await authRepository.apiUserProfile();
      dto = httpResponse.data as User;
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

  Future<void> otpResendApi(body) async {
    emit(ResponseStateLoading());
    HttpResponse httpResponse;
    UtilityDto dto;
    try {
      httpResponse = await authRepository.otpResendApi(body);
      dto = httpResponse.data as UtilityDto;
      emit(ResponseStateSuccess(dto));
    } on DioError catch (error) {
      emit(ServerError.mapDioErrorToState(error));
    }
  }



  Future<void> completeProfileApi(body,) async {
    emit(ResponseStateLoading());
    HttpResponse httpResponse;
    LoginDto dto;
    try {
      httpResponse = await authRepository.completeProfileApi(body,);
      dto = httpResponse.data as LoginDto;
      // await AppSession().storeAccessToken(dto.token ?? "");
      emit(ResponseStateSuccess(dto));
    } on DioError catch (error) {
      emit(ServerError.mapDioErrorToState(error));
    }
  }

  Future<void> completeProfileApiNew(body,) async {
    emit(ResponseStateLoading());
    HttpResponse httpResponse;
    SignupDto dto;
    try {
      httpResponse = await authRepository.completeProfileApiNew(body,);
      dto = httpResponse.data as SignupDto;
      // await AppSession().storeAccessToken(dto.token ?? "");
      emit(ResponseStateSuccess(dto));
    } on DioError catch (error) {
      emit(ServerError.mapDioErrorToState(error));
    }
  }


  Future<void> apiSetPlan(body,) async {
    emit(ResponseStateLoading());
    HttpResponse httpResponse;
    UtilityDto dto;
    try {
      httpResponse = await authRepository.apiSetPlan(body,);
      dto = httpResponse.data as UtilityDto;
      // await AppSession().storeAccessToken(dto.token ?? "");
      emit(ResponseStateSuccess(dto));
    } on DioError catch (error) {
      emit(ServerError.mapDioErrorToState(error));
    }
  }

  Future<void> apiSupport(body,) async {
    emit(ResponseStateLoading());
    HttpResponse httpResponse;
    UtilityDto dto;
    try {
      httpResponse = await authRepository.apiSupport(body,);
      dto = httpResponse.data as UtilityDto;
      // await AppSession().storeAccessToken(dto.token ?? "");
      emit(ResponseStateSuccess(dto));
    } on DioError catch (error) {
      emit(ServerError.mapDioErrorToState(error));
    }
  }

  Future<void> apiChangePassword(body,) async {
    emit(ResponseStateLoading());
    HttpResponse httpResponse;
    UtilityDto dto;
    try {
      httpResponse = await authRepository.apiChangePassword(body,);
      dto = httpResponse.data as UtilityDto;
      // await AppSession().storeAccessToken(dto.token ?? "");
      emit(ResponseStateSuccess(dto));
    } on DioError catch (error) {
      emit(ServerError.mapDioErrorToState(error));
    }
  }

 Future<void> apiGetTerms() async {
    emit(ResponseStateLoading());
    HttpResponse httpResponse;
    UtilityDto dto;
    try {
      httpResponse = await authRepository.apiGetTerms();
      dto = httpResponse.data as UtilityDto;
      // await AppSession().storeAccessToken(dto.token ?? "");
      emit(ResponseStateSuccess(dto));
    } on DioError catch (error) {
      emit(ServerError.mapDioErrorToState(error));
    }
  }

 Future<void> apiGetPrivacy() async {
    emit(ResponseStateLoading());
    HttpResponse httpResponse;
    UtilityDto dto;
    try {
      httpResponse = await authRepository.apiGetPrivacy();
      dto = httpResponse.data as UtilityDto;
      // await AppSession().storeAccessToken(dto.token ?? "");
      emit(ResponseStateSuccess(dto));
    } on DioError catch (error) {
      emit(ServerError.mapDioErrorToState(error));
    }
  }

 Future<void> apiGetNotification(limit,offset) async {
    emit(ResponseStateLoading());
    HttpResponse httpResponse;
    NotificationModel dto;
    try {
      httpResponse = await authRepository.apiGetNotification(limit,offset);
      dto = httpResponse.data as NotificationModel;
      // await AppSession().storeAccessToken(dto.token ?? "");
      emit(ResponseStateSuccess(dto));
    } on DioError catch (error) {
      emit(ServerError.mapDioErrorToState(error));
    }
  }

 Future<void> apiDeleteNotification(id) async {
    emit(ResponseStateLoading());
    HttpResponse httpResponse;
    UtilityDto dto;
    try {
      httpResponse = await authRepository.apiDeleteNotification(id);
      dto = httpResponse.data as UtilityDto;
      // await AppSession().storeAccessToken(dto.token ?? "");
      emit(ResponseStateSuccess(dto));
    } on DioError catch (error) {
      emit(ServerError.mapDioErrorToState(error));
    }
  }

 Future<void> apiGetPlan() async {
    emit(ResponseStateLoading());
    HttpResponse httpResponse;
    SubscriptionModel dto;
    try {
      httpResponse = await authRepository.apiGetPlan();
      dto = httpResponse.data as SubscriptionModel;
      // await AppSession().storeAccessToken(dto.token ?? "");
      emit(ResponseStateSuccess(dto));
    } on DioError catch (error) {
      emit(ServerError.mapDioErrorToState(error));
    }
  }

}