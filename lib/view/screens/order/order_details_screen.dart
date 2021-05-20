import 'dart:math';

import 'package:flutter/material.dart';
import 'package:restaurant_rider/data/model/body/TrackBody.dart';
import 'package:restaurant_rider/data/model/response/order_details_model.dart';
import 'package:restaurant_rider/data/model/response/order_model.dart';
import 'package:restaurant_rider/helper/date_converter.dart';
import 'package:restaurant_rider/helper/price_converter.dart';
import 'package:restaurant_rider/localization/language_constrants.dart';
import 'package:restaurant_rider/provider/auth_provider.dart';
import 'package:restaurant_rider/provider/localization_provider.dart';
import 'package:restaurant_rider/provider/location_provider.dart';
import 'package:restaurant_rider/provider/order_provider.dart';
import 'package:restaurant_rider/provider/theme_provider.dart';
import 'package:restaurant_rider/provider/tracker_provider.dart';
import 'package:restaurant_rider/utill/dimensions.dart';
import 'package:restaurant_rider/utill/images.dart';
import 'package:restaurant_rider/utill/styles.dart';
import 'package:restaurant_rider/view/base/custom_button.dart';
import 'package:restaurant_rider/view/screens/home/widget/order_widget.dart';
import 'package:restaurant_rider/view/screens/order/order_place_screen.dart';
import 'package:restaurant_rider/view/screens/order/widget/custom_divider.dart';
import 'package:restaurant_rider/view/screens/order/widget/delivery_dialog.dart';
import 'package:provider/provider.dart';
import 'package:slider_button/slider_button.dart';
import 'package:url_launcher/url_launcher.dart';

class OrderDetailsScreen extends StatelessWidget {
  final OrderModel orderModel;
  final int index;
  OrderDetailsScreen({this.orderModel, @required this.index});

  @override
  Widget build(BuildContext context) {
    Provider.of<OrderProvider>(context, listen: false).getOrderDetails(orderModel.id.toString(), context);
    double deliveryCharge = 0;
    if(orderModel.orderType == 'delivery') {
      deliveryCharge = orderModel.deliveryCharge;
    }

    return Scaffold(
      backgroundColor: Theme.of(context).cardColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).cardColor,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Theme.of(context).textTheme.bodyText1.color,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          getTranslated('order_details', context),
          style: Theme.of(context).textTheme.headline3.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE, color: Theme.of(context).textTheme.bodyText1.color),
        ),
      ),
      body: SafeArea(
        child: Consumer<OrderProvider>(
          builder: (context, order, child) {
            double _itemsPrice = 0;
            double _discount = 0;
            double _tax = 0;
            double _addOns = 0;
            if (order.orderDetails != null) {
              order.orderDetails.forEach((orderDetails) {
                int _index = 0;
                for(AddOns addOn in orderDetails.productDetails.addOns) {
                  if(orderDetails.addOnIds.contains(addOn.id)) {
                    _addOns = _addOns + (addOn.price * orderDetails.addOnQtys[_index]);
                    _index++;
                  }
                }
                _itemsPrice = _itemsPrice + (orderDetails.price * orderDetails.quantity);
                _discount = _discount + (orderDetails.discountOnProduct * orderDetails.quantity);
                _tax = _tax + (orderDetails.taxAmount * orderDetails.quantity);
              });
            }
            double _subTotal = _itemsPrice + _tax + _addOns;
            double totalPrice = _subTotal - _discount + deliveryCharge - orderModel.couponDiscountAmount;

            return order.orderDetails != null
                ? Column(
                  children: [
                    Expanded(
                      child: ListView(
                        physics: BouncingScrollPhysics(),
                        padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                        children: [
                          Row(children: [
                            Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text('${getTranslated('order_id', context)}', style: rubikRegular.copyWith(color: Theme.of(context).accentColor)),
                                  Text(' # ${orderModel.id}', style: rubikMedium.copyWith(color: Theme.of(context).accentColor)),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Icon(Icons.watch_later, size: 17),
                                  SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                  Text(DateConverter.isoStringToLocalDateOnly(orderModel.createdAt),
                                      style: rubikRegular.copyWith(color: Theme.of(context).accentColor)),
                                ],
                              ),
                            ),
                          ]),
                          SizedBox(height: 20),

                          Container(
                            padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColorDark,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [BoxShadow(
                                color: Colors.grey[Provider.of<ThemeProvider>(context).darkTheme ? 700 : 300],
                                blurRadius: 5, spreadRadius: 1,
                              )],
                            ),
                            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              Text(getTranslated('customer', context), style: rubikRegular.copyWith(
                                fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL,
                                color: Theme.of(context).accentColor,
                              )),
                              ListTile(
                                leading: ClipOval(
                                  child: Image.asset(
                                    orderModel.customer.image ?? Images.placeholder_image,
                                    height: 40, width: 40, fit: BoxFit.cover,
                                  ),
                                ),
                                title: Text(
                                  '${orderModel.customer.fName ?? ''} ${orderModel.customer.lName ?? ''}',
                                  style: rubikRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE, color: Theme.of(context).accentColor),
                                ),
                                trailing: InkWell(
                                  onTap: () {
                                    launch('tel:${orderModel.customer.phone}');
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                    decoration: BoxDecoration(shape: BoxShape.circle, color: Theme.of(context).shadowColor),
                                    child: Icon(Icons.call_outlined, color: Colors.black),
                                  ),
                                ),
                              ),
                            ]),
                          ),
                          SizedBox(height: 20),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(children: [
                                Text('${getTranslated('item', context)}:', style: rubikRegular.copyWith(color: Theme.of(context).accentColor)),
                                SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                Text(order.orderDetails.length.toString(), style: rubikMedium.copyWith(color: Theme.of(context).primaryColor)),
                              ]),
                              orderModel.orderStatus == 'processing' || orderModel.orderStatus == 'out_for_delivery'
                                  ? Row(children: [
                                      Text('${getTranslated('payment_status', context)}:',
                                          style: rubikRegular.copyWith(color: Theme.of(context).accentColor)),
                                      SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                      Text(getTranslated('${orderModel.paymentStatus}', context),
                                          style: rubikMedium.copyWith(color: Theme.of(context).primaryColor)),
                                    ])
                                  : SizedBox.shrink(),
                            ],
                          ),
                          Divider(height: 20),

                          ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: order.orderDetails.length,
                            itemBuilder: (context, index) {
                              List<AddOns> _addOns = [];
                              order.orderDetails[index].productDetails.addOns.forEach((addOn) {
                                if (order.orderDetails[index].addOnIds.contains(addOn.id)) {
                                  _addOns.add(addOn);
                                }
                              });
                              return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                Row(children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.asset(
                                      order.orderDetails[index].productDetails.image,
                                      height: 70,
                                      width: 80,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
                                  Expanded(
                                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              order.orderDetails[index].productDetails.name,
                                              style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL, color: Theme.of(context).accentColor),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          Text(getTranslated('amount', context), style: rubikRegular.copyWith(color: Theme.of(context).accentColor)),
                                        ],
                                      ),
                                      SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                        Row(
                                          children: [
                                            Text('${getTranslated('quantity', context)}:',
                                                style: rubikRegular.copyWith(color: Theme.of(context).accentColor)),
                                            Text(' ${order.orderDetails[index].quantity}',
                                                style: rubikMedium.copyWith(color: Theme.of(context).primaryColor)),
                                          ],
                                        ),
                                        Text(
                                          PriceConverter.convertPrice(context, order.orderDetails[index].price),
                                          style: rubikMedium.copyWith(color: Theme.of(context).primaryColor),
                                        ),
                                      ]),
                                      SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                                      Row(children: [
                                        Container(
                                            height: 10,
                                            width: 10,
                                            decoration: BoxDecoration(shape: BoxShape.circle, color: Theme.of(context).textTheme.bodyText1.color)),
                                        SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                        Text(
                                          '${getTranslated('order_at', context)}${DateConverter.isoStringToLocalDateOnly(order.orderDetails[index].updatedAt)}',
                                          style: rubikRegular.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL, color: Theme.of(context).accentColor),
                                        ),
                                      ]),
                                    ]),
                                  ),
                                ]),
                                _addOns.length > 0
                                    ? SizedBox(
                                        height: 30,
                                        child: ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          physics: BouncingScrollPhysics(),
                                          padding: EdgeInsets.only(top: Dimensions.PADDING_SIZE_SMALL),
                                          itemCount: _addOns.length,
                                          itemBuilder: (context, i) {
                                            return Padding(
                                              padding: EdgeInsets.only(right: Dimensions.PADDING_SIZE_SMALL),
                                              child: Row(children: [
                                                Text(_addOns[i].name, style: rubikRegular.copyWith(color: Theme.of(context).accentColor)),
                                                SizedBox(width: 2),
                                                Text(
                                                  PriceConverter.convertPrice(context, _addOns[i].price),
                                                  style: rubikMedium.copyWith(color: Theme.of(context).accentColor),
                                                ),
                                                SizedBox(width: 2),
                                                Text('(${order.orderDetails[index].addOnQtys[i]})', style: rubikRegular),
                                              ]),
                                            );
                                          },
                                        ),
                                      )
                                    : SizedBox(),
                                Divider(height: 20),
                              ]);
                            },
                          ),

                          // Total
                          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                            Text(getTranslated('items_price', context), style: rubikRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
                            Text(PriceConverter.convertPrice(context, _itemsPrice), style: rubikRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
                          ]),
                          SizedBox(height: 10),

                          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                            Text(getTranslated('tax', context),
                                style: rubikRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE, color: Theme.of(context).accentColor)),
                            Text('(+) ${PriceConverter.convertPrice(context, _tax)}',
                                style: rubikRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE, color: Theme.of(context).accentColor)),
                          ]),
                          SizedBox(height: 10),

                          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                            Text(getTranslated('addons', context),
                                style: rubikRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE, color: Theme.of(context).accentColor)),
                            Text('(+) ${PriceConverter.convertPrice(context, _addOns)}',
                                style: rubikRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE, color: Theme.of(context).accentColor)),
                          ]),

                          Padding(
                            padding: EdgeInsets.symmetric(vertical: Dimensions.PADDING_SIZE_SMALL),
                            child: CustomDivider(),
                          ),

                          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                            Text(getTranslated('subtotal', context),
                                style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE, color: Theme.of(context).accentColor)),
                            Text(PriceConverter.convertPrice(context, _subTotal),
                                style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE, color: Theme.of(context).accentColor)),
                          ]),
                          SizedBox(height: 10),

                          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                            Text(getTranslated('discount', context),
                                style: rubikRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE, color: Theme.of(context).accentColor)),
                            Text('(-) ${PriceConverter.convertPrice(context, _discount)}',
                                style: rubikRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE, color: Theme.of(context).accentColor)),
                          ]),
                          SizedBox(height: 10),

                          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                            Text(getTranslated('coupon_discount', context),
                                style: rubikRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE, color: Theme.of(context).accentColor)),
                            Text(
                              '(-) ${PriceConverter.convertPrice(context, orderModel.couponDiscountAmount)}',
                              style: rubikRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE, color: Theme.of(context).accentColor),
                            ),
                          ]),
                          SizedBox(height: 10),

                          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                            Text(getTranslated('delivery_fee', context),
                                style: rubikRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE, color: Theme.of(context).accentColor)),
                            Text('(+) ${PriceConverter.convertPrice(context, deliveryCharge)}',
                                style: rubikRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE, color: Theme.of(context).accentColor)),
                          ]),

                          Padding(
                            padding: EdgeInsets.symmetric(vertical: Dimensions.PADDING_SIZE_SMALL),
                            child: CustomDivider(),
                          ),

                          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                            Text(getTranslated('total_amount', context),
                                style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE, color: Theme.of(context).primaryColor)),
                            Text(
                              PriceConverter.convertPrice(context, totalPrice),
                              style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE, color: Theme.of(context).primaryColor),
                            ),
                          ]),
                          SizedBox(height: 30),

                          orderModel.orderStatus == 'processing' || orderModel.orderStatus == 'out_for_delivery'
                              ? Consumer<LocationProvider>(
                                  builder: (context, locationProvider, child) => CustomButton(
                                      btnTxt: getTranslated('direction', context),
                                      onTap: () {
                                        MapUtils.openMap(
                                            double.parse(orderModel.deliveryAddress.latitude) ?? 23.8103,
                                            double.parse(orderModel.deliveryAddress.longitude) ?? 90.4125,
                                            locationProvider.currentLocation.latitude ?? 23.81,
                                            locationProvider.currentLocation.longitude ?? 90.4125);
                                      }),
                                )
                              : SizedBox.shrink(),
                        ],
                      ),
                    ),

                    orderModel.orderStatus == 'processing' ? Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(Dimensions.PADDING_SIZE_SMALL),
                        border: Border.all(color: Theme.of(context).dividerColor.withOpacity(.05)),
                        color: Theme.of(context).backgroundColor,
                      ),
                      child: Transform.rotate(
                        angle: Provider.of<LocalizationProvider>(context).isLtr ? pi * 2 : pi, // in radians
                        child: Directionality(
                          textDirection: TextDirection.ltr,
                          child: SliderButton(
                            action: () {
                              String token = Provider.of<AuthProvider>(context, listen: false).getUserToken();
                              TrackBody trackBody = TrackBody(
                                  token: token,
                                  latitude: Provider.of<LocationProvider>(context, listen: false).currentLocation.latitude ?? 23.8103,
                                  longitude: Provider.of<LocationProvider>(context, listen: false).currentLocation.longitude ?? 90.4125,
                                  location: Provider.of<LocationProvider>(context, listen: false).address.toString() ?? 'demo',
                                  orderId: orderModel.id.toString());
                              Provider.of<TrackerProvider>(context, listen: false).updateTrackStart(true);

                              Provider.of<TrackerProvider>(context, listen: false).addTrack(trackBody: trackBody).then((value) {
                                Provider.of<OrderProvider>(context, listen: false)
                                    .updateOrderStatus(token: token, orderId: orderModel.id, status: 'out_for_delivery', index: index);
                                Navigator.pop(context);
                              });
                            },

                            ///Put label over here
                            label: Text(
                              getTranslated('swip_to_deliver_order', context),
                              style: Theme.of(context).textTheme.headline3.copyWith(color: Theme.of(context).primaryColor),
                            ),
                            dismissThresholds: 0.5,
                            icon: Center(
                                child: Icon(
                                  Icons.double_arrow_sharp,
                                  color: Colors.white,
                                  size: 20.0,
                                  semanticLabel: 'Text to announce in accessibility modes',
                                )),

                            ///Change All the color and size from here.
                            radius: 10,
                            boxShadow: BoxShadow(blurRadius: 0.0),
                            buttonColor: Theme.of(context).primaryColor,
                            backgroundColor: Theme.of(context).backgroundColor,
                            baseColor: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                    )
                        : orderModel.orderStatus == 'out_for_delivery'
                        ? Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(Dimensions.PADDING_SIZE_SMALL),
                        border: Border.all(color: Theme.of(context).dividerColor.withOpacity(.05)),
                        color: Theme.of(context).backgroundColor,
                      ),
                      child: Transform.rotate(
                        angle: Provider.of<LocalizationProvider>(context).isLtr ? pi * 2 : pi, // in radians
                        child: Directionality(
                          textDirection: TextDirection.ltr, // set it to rtl
                          child: SliderButton(
                            action: () {
                              String token = Provider.of<AuthProvider>(context, listen: false).getUserToken();

                              if (orderModel.paymentStatus == 'paid') {
                                Provider.of<OrderProvider>(context, listen: false)
                                    .updateOrderStatus(token: token, orderId: orderModel.id, status: 'delivered', index: index);
                                Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(builder: (_) => OrderPlaceScreen(orderID: orderModel.id.toString())));
                              } else {
                                showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (BuildContext context) {
                                      return Dialog(
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                                        child: DeliveryDialog(
                                          onTap: () {},
                                          index: index,
                                          totalPrice: totalPrice,
                                          orderModel: orderModel,
                                        ),
                                      );
                                    });
                              }
                            },

                            ///Put label over here
                            label: Text(
                              getTranslated('swip_to_confirm_order', context),
                              style: Theme.of(context).textTheme.headline3.copyWith(color: Theme.of(context).primaryColor),
                            ),
                            dismissThresholds: 0.5,
                            icon: Center(
                                child: Icon(
                                  Icons.double_arrow_sharp,
                                  color: Colors.white,
                                  size: 20.0,
                                  semanticLabel: 'Text to announce in accessibility modes',
                                )),

                            ///Change All the color and size from here.
                            radius: 10,
                            boxShadow: BoxShadow(blurRadius: 0.0),
                            buttonColor: Theme.of(context).primaryColor,
                            backgroundColor: Theme.of(context).backgroundColor,
                            baseColor: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                    )
                        : SizedBox.shrink(),
                  ],
                )
                : Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor)));
          },
        ),
      ),
    );
  }
}
