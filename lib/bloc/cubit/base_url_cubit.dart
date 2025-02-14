// import 'package:dio/dio.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_skeleton/dto/base_url_dto.dart';
// import 'package:flutter_skeleton/data/local/app_session.dart';
// import 'package:retrofit/retrofit.dart';
// import '../../data/network/server_error.dart';
// import '../../data/repository/auth_repository.dart';
// import '../api_resp_state.dart';
//
// class BaseUrlCubit extends Cubit<ResponseState> {
//   final AuthRepository authRepository;
//
//   BaseUrlCubit(this.authRepository) : super(ResponseStateInitial());
//
//   Future<void> apiBaseUrl() async {
//     emit(ResponseStateLoading());
//     HttpResponse httpResponse;
//     BaseUrlDto dto;
//     try {
//       httpResponse = await authRepository.apiBaseUrl();
//       dto = httpResponse.data as BaseUrlDto;
//       AppSession().storeBaseUrlDetail(dto);
//       emit(ResponseStateSuccess(dto));
//     }
//     on DioException catch (error) {
//       emit(ServerError.mapDioErrorToState(error));
//     }
//   }
//
// }