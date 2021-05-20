import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:restaurant_rider/localization/language_constrants.dart';
import 'package:restaurant_rider/provider/auth_provider.dart';
import 'package:restaurant_rider/provider/splash_provider.dart';
import 'package:restaurant_rider/utill/images.dart';
import 'package:restaurant_rider/view/screens/dashboard/dashboard_screen.dart';
import 'package:restaurant_rider/view/screens/language/choose_language_screen.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();

    _route();
  }

  void _route() {
    Provider.of<SplashProvider>(context, listen: false).initSharedData();
    Timer(Duration(seconds: 2), () async {
      if (Provider.of<AuthProvider>(context, listen: false).isLoggedIn()) {
        _checkPermission(DashboardScreen());
      } else {
        _checkPermission(ChooseLanguageScreen());
      }

    });
  }

  void _checkPermission(Widget navigateTo) async {
    LocationPermission permission = await Geolocator.checkPermission();
    if(permission == LocationPermission.denied) {
      showDialog(context: context, barrierDismissible: false, builder: (_) => AlertDialog(
        title: Text(getTranslated('alert', context)),
        content: Text(getTranslated('allow_for_all_time', context)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        actions: [ElevatedButton(
          onPressed: () async {
            Navigator.pop(context);
            await Geolocator.requestPermission();
            _checkPermission(navigateTo);
          },
          child: Text(getTranslated('ok', context)),
        )],
      ));
    }else if(permission == LocationPermission.deniedForever) {
      await Geolocator.openLocationSettings();
    }else {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => navigateTo));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(Images.efood_bike, height: 165),
            SizedBox(height: 45),
            Image.asset(Images.efood, height: 33,color: Theme.of(context).primaryColor,),
          ],
        ),
      ),
    );
  }
}
