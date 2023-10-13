import 'dart:convert';

class PaymentSuccessResponse {
  bool success;
  String code;
  String message;
  PhonePeCheckStatusData data;

  PaymentSuccessResponse({
    required this.success,
    required this.code,
    required this.message,
    required this.data,
  });

  factory PaymentSuccessResponse.fromJson(Map<String, dynamic> json) {
    return PaymentSuccessResponse(
      success: json['success'],
      code: json['code'],
      message: json['message'],
      data: PhonePeCheckStatusData.fromMap(json['data']),
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'success': success,
      'code': code,
      'message': message,
      'data': data.toMap(),
    };
  }

  factory PaymentSuccessResponse.fromMap(Map<String, dynamic> map) {
    return PaymentSuccessResponse(
      success: map['success'] as bool,
      code: map['code'] as String,
      message: map['message'] as String,
      data: PhonePeCheckStatusData.fromMap(map['data'] as Map<String, dynamic>),
    );
  }

  String toJson() => json.encode(toMap());
}

class PhonePeCheckStatusData {
  String merchantId;
  String merchantTransactionId;
  String transactionId;
  int amount;
  String state;
  String responseCode;
  PhonePePaymentInstrument paymentInstrument;

  PhonePeCheckStatusData({
    required this.merchantId,
    required this.merchantTransactionId,
    required this.transactionId,
    required this.amount,
    required this.state,
    required this.responseCode,
    required this.paymentInstrument,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'merchantId': merchantId,
      'merchantTransactionId': merchantTransactionId,
      'transactionId': transactionId,
      'amount': amount,
      'state': state,
      'responseCode': responseCode,
      'paymentInstrument': paymentInstrument.toMap(),
    };
  }

  factory PhonePeCheckStatusData.fromMap(Map<String, dynamic> map) {
    return PhonePeCheckStatusData(
      merchantId: map['merchantId'] as String,
      merchantTransactionId: map['merchantTransactionId'] as String,
      transactionId: map['transactionId'] as String,
      amount: map['amount'] as int,
      state: map['state'] as String,
      responseCode: map['responseCode'] as String,
      paymentInstrument: PhonePePaymentInstrument.fromMap(
          map['paymentInstrument'] as Map<String, dynamic>),
    );
  }

  String toJson() => json.encode(toMap());
}

class PhonePePaymentInstrument {
  String type;
  String? utr;
  String? unmaskedAccountNumber;
  String? cardType;
  String? pgTransactionId;
  String? bankTransactionId;
  String? pgAuthorizationCode;
  String? arn;
  String? bankId;
  String? brn;
  String? pgServiceTransactionId;

  PhonePePaymentInstrument({
    required this.type,
    //UPI
    this.utr,
    this.unmaskedAccountNumber,
    //CARD
    this.cardType,
    this.pgAuthorizationCode,
    this.arn,
    this.brn,
    //NETBANKING
    this.pgServiceTransactionId,

    ///
    ///USE CART AND NETBANKING
    this.bankId,
    this.bankTransactionId,
    this.pgTransactionId,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'type': type,
      'utr': utr,
      'unmaskedAccountNumber': unmaskedAccountNumber,
      'cardType': cardType,
      'pgTransactionId': pgTransactionId,
      'bankTransactionId': bankTransactionId,
      'pgAuthorizationCode': pgAuthorizationCode,
      'arn': arn,
      'bankId': bankId,
      'brn': brn,
      'pgServiceTransactionId': pgServiceTransactionId,
    };
  }

  factory PhonePePaymentInstrument.fromMap(Map<String, dynamic> map) {
    return PhonePePaymentInstrument(
      type: map['type'] as String,
      utr: map['utr'] != null ? map['utr'] as String : null,
      unmaskedAccountNumber: map['unmaskedAccountNumber'] != null
          ? map['unmaskedAccountNumber'] as String
          : null,
      cardType: map['cardType'] != null ? map['cardType'] as String : null,
      pgTransactionId: map['pgTransactionId'] != null
          ? map['pgTransactionId'] as String
          : null,
      bankTransactionId: map['bankTransactionId'] != null
          ? map['bankTransactionId'] as String
          : null,
      pgAuthorizationCode: map['pgAuthorizationCode'] != null
          ? map['pgAuthorizationCode'] as String
          : null,
      arn: map['arn'] != null ? map['arn'] as String : null,
      bankId: map['bankId'] != null ? map['bankId'] as String : null,
      brn: map['brn'] != null ? map['brn'] as String : null,
      pgServiceTransactionId: map['pgServiceTransactionId'] != null
          ? map['pgServiceTransactionId'] as String
          : null,
    );
  }

  String toJson() => json.encode(toMap());
}
