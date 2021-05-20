import 'package:flutter/material.dart';
import 'package:restaurant_rider/data/model/response/language_model.dart';
import 'package:restaurant_rider/utill/app_constants.dart';

class LanguageRepo {
  List<LanguageModel> getAllLanguages({BuildContext context}) {
    return AppConstants.languages;
  }
}
