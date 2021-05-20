import 'package:dio/dio.dart';
import 'package:restaurant_rider/data/model/response/order_details_model.dart';
import 'package:restaurant_rider/utill/images.dart';
import 'package:restaurant_rider/data/model/response/base/api_response.dart';
import 'package:restaurant_rider/data/model/response/order_model.dart';
import 'package:restaurant_rider/helper/date_converter.dart';
import 'package:flutter/foundation.dart';
import 'package:restaurant_rider/data/datasource/remote/dio/dio_client.dart';
import 'package:restaurant_rider/data/datasource/remote/exception/api_error_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderRepo {
  final DioClient dioClient;
  final SharedPreferences sharedPreferences;
  OrderRepo({@required this.dioClient, @required this.sharedPreferences});

  Future<ApiResponse> getAllOrders() async {
    try {
      List<OrderModel> _orderList = [
        OrderModel(id: 1, userId: 1, deliveryAddressId: 1, orderAmount: 500, couponDiscountTitle: '', couponDiscountAmount: 10, orderStatus: 'processing', totalTaxAmount: 20, updatedAt: DateConverter.localDateToIsoString(DateTime.now().toUtc()), createdAt: DateConverter.localDateToIsoString(DateTime.now().toUtc()), paymentStatus: 'unpaid', paymentMethod: 'digital_payment', deliveryCharge: 10, customer: Customer(id: 1, image: Images.user, fName: 'John', lName: 'Abraham', phone: '123456789', email: 'john@gmail.com'), deliveryAddress: DeliveryAddress(latitude: '22.844737', longitude: '91.379468', address: 'Dhaka, Bangladesh'), orderType: 'delivery'),
        OrderModel(id: 2, userId: 1, deliveryAddressId: 1, orderAmount: 500, couponDiscountTitle: '', couponDiscountAmount: 10, deliveryManId: 1, orderStatus: 'processing', totalTaxAmount: 20, updatedAt: DateConverter.localDateToIsoString(DateTime.now().toUtc()), createdAt: DateConverter.localDateToIsoString(DateTime.now().toUtc()), paymentStatus: 'paid', paymentMethod: 'digital_payment', deliveryCharge: 10, customer: Customer(id: 1, image: Images.user, fName: 'John', lName: 'Abraham', phone: '123456789', email: 'john@gmail.com'), deliveryAddress: DeliveryAddress(latitude: '38.101527', longitude: '-102.825170', address: 'New York, USA'), orderType: 'take_away'),
      ];
      return ApiResponse.withSuccess(Response(requestOptions: RequestOptions(path: ''), data: _orderList, statusCode: 200));
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getOrderDetails({String orderID}) async {
    try {
      List<OrderDetailsModel> _orderDetailsList = [
        OrderDetailsModel(id: 1, addOnIds: [1], addOnQtys: [2], productId: 1, price: 100, discountType: 'percent', discountOnProduct: 10, orderId: 100001, productDetails: ProductDetails(name: 'Product 1', id: 1, image: Images.product_1, discountType: 'percent', discount: 5, addOns: [AddOns(id: 1, name: 'Chese', price: 5), AddOns(id: 2, name: 'Drinks', price: 5)], description: '* Rice', price: 100, tax: 2, taxType: 'percent', choiceOptions: [ChoiceOptions(name: 'size', title: 'Size', options: ['10', '12']), ChoiceOptions(name: 'type', title: 'Type', options: ['Small', 'Large'])], variations: [Variations(type: '10-Small', price: 100), Variations(type: '10-Large', price: 110), Variations(type: '12-Small', price: 120), Variations(type: '12-Large', price: 130)], availableTimeStarts: '00:01:00', availableTimeEnds: '23:59:00', attributes: [], categoryIds: []), quantity: 2, taxAmount: 20, variant: '', variation: [], createdAt: DateConverter.localDateToIsoString(DateTime.now().toUtc()), updatedAt: DateConverter.localDateToIsoString(DateTime.now().toUtc())),
      ];
      final response = Response(requestOptions: RequestOptions(path: ''), data: _orderDetailsList, statusCode: 200);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getAllOrderHistory() async {
    try {
      List<OrderModel> _orderList = [
        OrderModel(id: 1, userId: 1, deliveryAddressId: 1, orderAmount: 500, couponDiscountTitle: '', couponDiscountAmount: 10, orderStatus: 'pending', totalTaxAmount: 20, updatedAt: DateConverter.localDateToIsoString(DateTime.now().toUtc()), createdAt: DateConverter.localDateToIsoString(DateTime.now().toUtc()), paymentStatus: 'unpaid', paymentMethod: 'digital_payment', deliveryCharge: 10, customer: Customer(id: 1, image: Images.user, fName: 'John', lName: 'Abraham', phone: '123456789', email: 'john@gmail.com'), orderType: 'take_away'),
        OrderModel(id: 2, userId: 1, deliveryAddressId: 1, orderAmount: 500, couponDiscountTitle: '', couponDiscountAmount: 10, deliveryManId: 1, orderStatus: 'delivered', totalTaxAmount: 20, updatedAt: DateConverter.localDateToIsoString(DateTime.now().toUtc()), createdAt: DateConverter.localDateToIsoString(DateTime.now().toUtc()), paymentStatus: 'paid', paymentMethod: 'digital_payment', deliveryCharge: 10, customer: Customer(id: 1, image: Images.user, fName: 'John', lName: 'Abraham', phone: '123456789', email: 'john@gmail.com'), orderType: 'delivery'),
      ];
      return ApiResponse.withSuccess(Response(requestOptions: RequestOptions(path: ''), data: _orderList, statusCode: 200));
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

}
