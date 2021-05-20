import 'package:flutter/material.dart';
import 'package:restaurant_rider/utill/color_resources.dart';
import 'package:restaurant_rider/utill/dimensions.dart';

class CustomButton extends StatelessWidget {
  final Function onTap;
  final String btnTxt;
  final bool isShowBorder;

  CustomButton({this.onTap, @required this.btnTxt, this.isShowBorder = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(color: !isShowBorder ? Colors.grey.withOpacity(0.2) : Colors.transparent, spreadRadius: 1, blurRadius: 7, offset: Offset(0, 1))
          ],
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: isShowBorder ? ColorResources.COLOR_GREY_WHITE : Colors.transparent),
          color: !isShowBorder ? Theme.of(context).primaryColor : Colors.transparent),
      child: TextButton(
        style: TextButton.styleFrom(
          padding: EdgeInsets.all(0),
        ),
        onPressed: onTap,
        child: Text(btnTxt ?? "",
            style: Theme.of(context).textTheme.headline3.copyWith(
                color: isShowBorder ? Theme.of(context).textTheme.bodyText1.color : Theme.of(context).primaryColorDark, fontSize: Dimensions.FONT_SIZE_LARGE)),
      ),
    );
  }
}
