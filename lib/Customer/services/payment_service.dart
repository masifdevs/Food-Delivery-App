import 'package:flutter/services.dart';
import 'package:stripe_payment/stripe_payment.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class StripeTransactionResponse {
  String message;
  bool success;
  StripeTransactionResponse({this.message, this.success});
}

class StripeService {
  static String apiBase = 'https://api.stripe.com/v1';
  static String paymentApiUrl = '${StripeService.apiBase}/payment_intents';
  static String secret = 'sk_test_51HFzU6DX5gOp1yZIb7lw9Z9v6x4F8tN6FJu8WDIKZU0vNoh2hB089Tx4mO8mGc06HdSTPSkClWPXu34a1Fig002I0G5XQU';
  static Map<String, String> headers = {
    'Authorization': 'Bearer ${StripeService.secret}',
    'Content-Type': 'application/x-www-form-urlencoded'
  };

  static init() {
    StripePayment.setOptions(StripeOptions(
        publishableKey: "pk_test_51HFzU6DX5gOp1yZI4Jre2PbZ1y1EkCHZRc1Yob6XGYaF4TLQrkA39nUctvZUA3vCrAEqONsY65TMtTk7mj00DSbVOwsn",
        merchantId: "Test",
        androidPayMode: 'test'));
  }

  //nothing to change only create a new method like below with required parameter
  static Future<StripeTransactionResponse> payViaExistingCard(
      String amount, String currency, CreditCard card) async {
    try {
      PaymentMethod paymentMethod = await StripePayment.createPaymentMethod(
          PaymentMethodRequest(card: card));

      return intentResponse(paymentMethod, amount, currency);
    } on PlatformException catch (err) {
      //handle if use back press
      return StripeService.getPlatformExceptionErrorResult(err);
    } catch (e) {
      return StripeTransactionResponse(
          message: "transaction failed: ${e.toString()}", success: false);
    }
  }

  static Future<StripeTransactionResponse> payFromNewCard(
      String amount, String currency) async {
    try {
      PaymentMethod paymentMethod =
          await StripePayment.paymentRequestWithCardForm(
              CardFormPaymentRequest());

      return intentResponse(paymentMethod, amount, currency);
    } on PlatformException catch (err) {
      //handle if use back press
      return StripeService.getPlatformExceptionErrorResult(err);
    } catch (e) {
      return StripeTransactionResponse(
          message: "transaction failed: ${e.toString()}", success: false);
    }
  }

//no change
  static getPlatformExceptionErrorResult(err) {
    //handle if use back press
    String message = 'Something went wrong';
    if (err.code == 'cancelled') {
      message = 'Transaction cancelled';
    }

    return new StripeTransactionResponse(message: message, success: false);
  }

  //step-2 create payment intent   //no change
  static Future<Map<String, dynamic>> createPaymentIntent(
      String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': amount,
        'currency': currency,
        'payment_method_types[]': 'card'
      };
      var response = await http.post(StripeService.paymentApiUrl,
          body: body, headers: StripeService.headers);
      return jsonDecode(response.body);
    } catch (err) {
      print('err charging user: ${err.toString()}');
    }
    return null;
  }

//no change
  static Future<StripeTransactionResponse> intentResponse(
      PaymentMethod paymentMethod, String amount, String currency) async {
    try {
      //call payment intent
      Map<String, dynamic> paymentIntent =
          await StripeService.createPaymentIntent(amount, currency);
      //payment confirmation here
      PaymentIntentResult response = await StripePayment.confirmPaymentIntent(
        PaymentIntent(
            clientSecret: paymentIntent['client_secret'],
            paymentMethodId: paymentMethod.id),
      );
      if (response.status == 'succeeded') {
        return StripeTransactionResponse(
            message: "transaction successful", success: true);
      } else {
        return StripeTransactionResponse(
            message: "transaction failed", success: false);
      }
    } catch (e) {
      return StripeTransactionResponse(
          message: "transaction failed: ${e.toString()}", success: false);
    }
  }
}
