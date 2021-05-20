import 'package:dio/dio.dart';
import 'package:restaurant_rider/data/model/response/userinfo_model.dart';
import 'package:restaurant_rider/utill/images.dart';
import 'package:flutter/foundation.dart';
import 'package:restaurant_rider/data/datasource/remote/dio/dio_client.dart';
import 'package:restaurant_rider/data/datasource/remote/exception/api_error_handler.dart';
import 'package:restaurant_rider/data/model/response/base/api_response.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileRepo {
  final DioClient dioClient;
  final SharedPreferences sharedPreferences;

  ProfileRepo({@required this.dioClient, @required this.sharedPreferences});

  Future<ApiResponse> getUserInfo() async {
    try {
      UserInfoModel _userInfo = UserInfoModel(id: 1, fName: 'John', lName: 'Doe', image: Images.user, phone: '12345678', email: 'john@email.com');
      final response = Response(requestOptions: RequestOptions(path: ''), data: _userInfo, statusCode: 200);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
}
