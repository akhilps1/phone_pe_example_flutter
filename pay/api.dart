// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:developer';
import 'package:crypto/crypto.dart';
import 'package:daddypro/Widget/circular_progress.dart';
import 'package:daddypro/phone_pe/pay/models/phone_pe_keys.dart';
import 'package:daddypro/phone_pe/pay/models/request.dart';
import 'package:daddypro/phone_pe/pay/models/request_failure.dart';
import 'package:daddypro/phone_pe/pay/models/request_success.dart';
import 'package:daddypro/phone_pe/screens/pay_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../enum/payment_status_enum.dart';

class PhonePay {
  PhonePay({required PhonePeKeys phonePeKey, required Request request})
      : _phonePeKey = phonePeKey,
        _request = request;
  final PhonePeKeys _phonePeKey;
  final Request _request;

  final _apiEndPoint = '/pg/v1/pay';

  String _generateSha256(String input) {
    var bytes = utf8.encode(input);
    var digest = sha256.convert(bytes);

    return digest.toString();
  }

  String _convertToBase64(Request request) {
    return base64Encode(
      utf8.encode(
        jsonEncode(
          request.toMap(),
        ),
      ),
    );
  }

  String _createCheckSum(String base64Payloard, String saltkey) {
    return _generateSha256(base64Payloard + _apiEndPoint + saltkey);
  }

  Future<void> createPaymetRequest({
    required Function(RequestSuccess success) onSuccess,
    required Function(RequestFailure? failure, Object? error) onFailure,
  }) async {
    final base64 = _convertToBase64(_request);
    final Map<String, String> headers = {
      'accept': 'application/json',
      'Content-Type': 'application/json',
      'X-VERIFY':
          '${_createCheckSum(base64, _phonePeKey.saltKay)}###${_phonePeKey.saltIndex}'
    };

    // log('${_createCheckSum(base64, _phonePeKey.saltKay)}###${_phonePeKey.saltIndex}');
    // log(base64);

    print(_request.toMap().toString());
    log(_request.toMap().toString());

    final Map<String, dynamic> requestBody = {
      'request': base64,
    };

    // const prodUrl = 'https://api.phonepe.com/apis/hermes';
    // const sandboxUrl = 'https://api-preprod.phonepe.com/apis/pg-sandbox';

    final Uri url = _phonePeKey.isUAT
        ? Uri.parse(
            "https://api-preprod.phonepe.com/apis/pg-sandbox$_apiEndPoint")
        : Uri.parse("https://api.phonepe.com/apis/hermes$_apiEndPoint");

    try {
      final response =
          await http.post(url, headers: headers, body: jsonEncode(requestBody));

      log(response.body);

      if (response.statusCode == 200) {
        onSuccess.call(
          RequestSuccess.fromJson(
            jsonDecode(jsonEncode(response.body)),
          ),
        );
      } else {
        onFailure.call(
          RequestFailure.fromJson(
            jsonDecode(jsonEncode(response.body)),
          ),
          null,
        );
      }
    } catch (error) {
      onFailure.call(
        null,
        error,
      );
    }
  }

//   Future<PaymentStatus> _checkPaymentStatus(PhonePeKey _phonePeKey, PaymentRequest _request) async {
//   final url = _phonePeKey.isUAT
//       ? 'https://api-preprod.phonepe.com/apis/pg-sandbox/pg/v1/status/${_request.merchantId}/${_request.merchantTransactionId}'
//       : 'https://api.phonepe.com/apis/hermes/pg/v1/status/${_request.merchantId}/${_request.merchantTransactionId}';

//   final checkSum = _generateSha256(
//       '/pg/v1/status/${_request.merchantId}/${_request.merchantTransactionId}${_phonePeKey.saltKay}');

//   final headers = {
//     'Content-Type': 'application/json',
//     'X-VERIFY': '$checkSum###${_phonePeKey.saltIndex}',
//     'X-MERCHANT-ID': 'PHONEONLINE',
//   };

//   try {
//     final response = await http.get(Uri.parse(url), headers: headers);

//     if (response.statusCode == 200) {

//       final jsonResponse = json.decode(response.body);

//         final code = jsonResponse['code'];
//         switch (code) {
//           case 'PAYMENT_SUCCESS':
//             return PaymentStatus.PAYMENT_SUCCESS;
//           case 'PAYMENT_PENDING':
//             return PaymentStatus.PAYMENT_PENDING;
//           case 'PAYMENT_DECLINED':
//             return PaymentStatus.PAYMENT_DECLINED;

//           default:
//             return PaymentStatus.PAYMENT_ERROR;
//         }

//     } else {
//       return PaymentStatus.INTERNAL_SERVER_ERROR;
//     }
//   } catch (e) {
//     print('Status checking error: $e');
//     return PaymentStatus.PAYMENT_ERROR;
//   }
// }

  Future<void> _checkPaymetStatus(
      {required Function(
              {required PaymentStatus paymentStatus,
              dynamic response,
              Object? error})
          onCompleted}) async {
    final url =
        'https://api.phonepe.com/apis/hermes/pg/v1/status/${_request.merchantId}/${_request.merchantTransactionId}';

    final checkSum = _generateSha256(
        '/pg/v1/status/${_request.merchantId}/${_request.merchantTransactionId}${_phonePeKey.saltKay}');

    //log(checkSum);

    final headers = {
      'Content-Type': 'application/json',
      'X-VERIFY': '$checkSum###${_phonePeKey.saltIndex}',
      'X-MERCHANT-ID': _request.merchantId,
    };

    try {
      final response = await http.get(Uri.parse(url), headers: headers);
      final jsonResponse = json.decode(response.body);

      log(response.body);

      if (jsonResponse['code'] == "AUTHORIZATION_FAILED") {
        onCompleted(
          paymentStatus: PaymentStatus.AUTHORIZATION_FAILED,
          response: jsonResponse,
          error: null,
        );
      } else if (jsonResponse['code'] == "BAD_REQUEST") {
        onCompleted(
          paymentStatus: PaymentStatus.BAD_REQUEST,
          response: jsonResponse,
          error: null,
        );
      } else if (jsonResponse['code'] == "INTERNAL_SERVER_ERROR") {
        onCompleted(
          paymentStatus: PaymentStatus.INTERNAL_SERVER_ERROR,
          response: jsonResponse,
          error: null,
        );
      } else if (jsonResponse['code'] == "PAYMENT_DECLINED") {
        onCompleted(
          paymentStatus: PaymentStatus.PAYMENT_DECLINED,
          response: jsonResponse,
          error: null,
        );
      } else if (jsonResponse['code'] == "PAYMENT_ERROR") {
        onCompleted(
          paymentStatus: PaymentStatus.PAYMENT_ERROR,
          response: jsonResponse,
          error: null,
        );
      } else if (jsonResponse['code'] == "PAYMENT_PENDING") {
        onCompleted(
          paymentStatus: PaymentStatus.PAYMENT_PENDING,
          response: jsonResponse,
          error: null,
        );
      } else if (jsonResponse['code'] == "PAYMENT_SUCCESS") {
        onCompleted(
          paymentStatus: PaymentStatus.PAYMENT_SUCCESS,
          response: jsonResponse,
          error: null,
        );
      } else if (jsonResponse['code'] == "TIMED_OUT") {
        onCompleted(
          paymentStatus: PaymentStatus.TIMED_OUT,
          response: jsonResponse,
          error: null,
        );
      } else if (jsonResponse['code'] == "TRANSACTION_NOT_FOUND") {
        onCompleted(
          paymentStatus: PaymentStatus.TRANSACTION_NOT_FOUND,
          response: jsonResponse,
          error: null,
        );
      } else {
        onCompleted(
          paymentStatus: PaymentStatus.UNKNOWN_ERROR,
          response: jsonResponse,
          error: null,
        );
      }
    } catch (e) {
      onCompleted(
        paymentStatus: PaymentStatus.UNKNOWN_ERROR,
        response: null,
        error: e,
      );
    }
  }

  Future<void> openPay({
    required BuildContext context,
    required RequestSuccess requestSuccess,
    required Function(
            {PaymentStatus? paymentStatus, dynamic response, Object? error})
        onCompleted,
  }) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PayPage(
          requestSuccess: requestSuccess,
          redirectUrl: _request.redirectUrl,
          onStatusChanged: () async {
            await _checkPaymetStatus(onCompleted: onCompleted);
            // ignore: use_build_context_synchronously
          },
        ),
      ),
    );
  }
}

// {"success":true,"code":"PAYMENT_INITIATED","message":"Payment initiated","data":{"merchantId":"PHONEONLINE","merchantTransactionId":"1695194628344","instrumentResponse":{"type":"PAY_PAGE","redirectInfo":{"url":"https://mercury-t2.phonepe.com/transact/pg?token=YWQ4M2UyYzk3YjgwMmFjODg2NWUxNzQzNDA2YTg1ODFkM2UyMDhmMjQ5YTlhYzhkZmFhMDk1OTlhZjcyODdkMWZmOGMxNzQzN2U4NzEwZDY4MTowYmFlMzBhMTFlOTVjMWVkOTk5ZTUwMWUyNmRjMjQ4ZQ","method":"GET"}}}}


// {merchantId: PHONEONLINE, merchantTransactionId: 1695194628344, merchantUserId: 1695194628344, amount: 100, redirectUrl: https://webhook.site/callback-url, redirectMode: REDIRECT, callbackUrl: , mobileNumber: 95670404214, paymentInstrument: {type: PAY_PAGE}}



  // Future<void> testCheckPaymetStatus() async {
  //   final url =
  //       _phonePeKey.isUAT?
  //       'https://api-preprod.phonepe.com/apis/pg-sandbox/pg/v1/status/${_request.merchantId}/${_request.merchantTransactionId}':
  //       "https://api.phonepe.com/pg/v1/status/${_request.merchantId}/${_request.merchantTransactionId}";
         
  //   final checkSum = _generateSha256(
  //       '/pg/v1/status/PHONEONLINE/169519462834427b097a5-a789-420a-a169-2adb5b9d50e4');
      

  //     log(checkSum);

  //   final headers = {
  //     'Content-Type': 'application/json',
  //     'X-VERIFY': '$checkSum###${_phonePeKey.saltIndex}',
  //     'X-MERCHANT-ID': 'PHONEONLINE',
  //   };

  //   try {
  //     final response = await http.get(Uri.parse('https://api.phonepe.com/apis/hermes/pg/v1/status/PHONEONLINE/1695194628344'), headers: headers);

  //     log(response.body);
  //   //   if (response.statusCode == 200) {
        
  //   //     onPaymentSuccess.call(response.body);
  //   //   } else {
  //   //     onFailure(error: null, onPaymentFaild:response.body);
  //   //   }
  //   } catch (e) {
  //     log('status checking error $e');
  //     // onFailure(error: e, onPaymentFaild: null );
  //   }
  // }