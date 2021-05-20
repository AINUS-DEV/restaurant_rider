import 'package:flutter/material.dart';
import 'package:restaurant_rider/data/datasource/remote/dio/dio_client.dart';
import 'package:restaurant_rider/utill/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashRepo {
  final DioClient dioClient;
  final SharedPreferences sharedPreferences;
  SplashRepo({@required this.sharedPreferences, @required this.dioClient});

  Future<bool> initSharedData() {
    if(!sharedPreferences.containsKey(AppConstants.THEME)) {
      return sharedPreferences.setBool(AppConstants.THEME, false);
    }
    if(!sharedPreferences.containsKey(AppConstants.COUNTRY_CODE)) {
      return sharedPreferences.setString(AppConstants.COUNTRY_CODE, 'US');
    }
    if(!sharedPreferences.containsKey(AppConstants.LANGUAGE_CODE)) {
      return sharedPreferences.setString(AppConstants.LANGUAGE_CODE, 'en');
    }
    if(!sharedPreferences.containsKey(AppConstants.CART_LIST)) {
      return sharedPreferences.setStringList(AppConstants.CART_LIST, []);
    }
    return Future.value(true);
  }

  Future<bool> removeSharedData() {
    return sharedPreferences.clear();
  }
}
