import 'package:flutter/material.dart';
import 'package:restaurant_rider/localization/language_constrants.dart';
import 'package:restaurant_rider/utill/dimensions.dart';
import 'package:restaurant_rider/utill/images.dart';
import 'package:restaurant_rider/view/base/custom_button.dart';
import 'package:restaurant_rider/view/screens/dashboard/dashboard_screen.dart';

class OrderPlaceScreen extends StatelessWidget {
  final String orderID;

  OrderPlaceScreen({this.orderID});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                Images.done_with_full_background,
                color: Theme.of(context).primaryColor,
              ),
              SizedBox(height: 20),
              Text(
                'Order Successfully Delivered',
                style: Theme.of(context).textTheme.headline3.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE, color: Theme.of(context).accentColor),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    getTranslated('order_id', context),
                    style: Theme.of(context).textTheme.headline2.copyWith(color: Theme.of(context).accentColor),
                  ),
                  Text(
                    ' #$orderID',
                    style: Theme.of(context).textTheme.headline3.copyWith(color: Theme.of(context).accentColor),
                  ),
                ],
              ),
              SizedBox(height: 30),
              CustomButton(
                btnTxt: getTranslated('back_home', context),
                onTap: () {
                  Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (_) => DashboardScreen()), (route) => false);
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
