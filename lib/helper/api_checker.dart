import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_rider/data/model/response/base/api_response.dart';
import 'package:restaurant_rider/provider/splash_provider.dart';
import 'package:restaurant_rider/view/screens/auth/login_screen.dart';

class ApiChecker {
  static void checkApi(BuildContext context, ApiResponse apiResponse) {
    if(apiResponse.error is! String && (apiResponse.error.errors[0].message == 'Unauthenticated.' || apiResponse.error.errors[0].message == 'Invalid token!')) {
      Provider.of<SplashProvider>(context, listen: false).removeSharedData();
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => LoginScreen()), (route) => false);
    }else {
      String _errorMessage;
      if (apiResponse.error is String) {
        _errorMessage = apiResponse.error.toString();
      } else {
        _errorMessage = apiResponse.error.errors[0].message;
      }
      print(_errorMessage);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(_errorMessage, style: TextStyle(color: Colors.white)), backgroundColor: Colors.red));
    }
  }
}
