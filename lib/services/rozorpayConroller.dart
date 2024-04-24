import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:pizza/constants.dart';
import 'package:pizza/model/createRazorPayOrderModel.dart';
import 'package:pizza/model/razorpayKeyModel.dart';
import 'package:pizza/userPrefrence.dart';

class RazorPayController {
  Future<CreateRazorPayOrderModel?> createOrderRazorPay(
      {required int amount, bool isTopup = false}) async {
    final String orderId =
        isTopup ? UserPreference.getPaymentId() : UserPreference.getOrderId();
    RazorPayModel razorPayData = UserPreference.getRazorPayData();
    debugPrint(razorPayData.razorpayKey);
    debugPrint("we Enter In");
    final url = "${GlobalURL}payments/razorpay/createorder";
    debugPrint(orderId);
    final response = await http.post(
      Uri.parse(url),
      body: {
        "amount": (amount * 100).toString(),
        "receipt_id": orderId,
        "currency": currencyModel?.code,
        "razorpaykey": razorPayData.razorpayKey,
        "razorPaySecret": razorPayData.razorpaySecret,
        "isSandBoxEnabled": razorPayData.isSandboxEnabled.toString(),
      },
    );
    debugPrint(response.toString());

    if (response.statusCode == 500) {
      return null;
    } else {
      final data = jsonDecode(response.body);
      debugPrint(data.toString());

      return CreateRazorPayOrderModel.fromJson(data);
    }
  }
}
