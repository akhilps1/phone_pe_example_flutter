// ignore_for_file: public_member_api_docs, sort_constructors_first
class Request {
  Request({
    required this.merchantId,
    required this.merchantTransactionId,
    required this.merchantUserId,
    required this.amount,
    required this.redirectUrl,
    required this.callbackUrl,
    required this.mobileNumber,
  });
  final String merchantId;
  final String merchantTransactionId;
  final String merchantUserId;
  final num amount;
  final String redirectUrl;
  final String callbackUrl;
  final String mobileNumber;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'merchantId': merchantId,
      'merchantTransactionId': merchantTransactionId,
      'merchantUserId': merchantUserId,
      'amount': amount,
      'redirectUrl': redirectUrl,
      "redirectMode": "REDIRECT",
      'callbackUrl': callbackUrl,
      'mobileNumber': mobileNumber,
      "paymentInstrument": {"type": "PAY_PAGE"}
    };
  }

  Request copyWith({
    String? merchantId,
    String? merchantTransactionId,
    String? merchantUserId,
    num? amount,
    String? redirectUrl,
    String? callbackUrl,
    String? mobileNumber,
  }) {
    return Request(
      merchantId: merchantId ?? this.merchantId,
      merchantTransactionId:
          merchantTransactionId ?? this.merchantTransactionId,
      merchantUserId: merchantUserId ?? this.merchantUserId,
      amount: amount ?? this.amount,
      redirectUrl: redirectUrl ?? this.redirectUrl,
      callbackUrl: callbackUrl ?? this.callbackUrl,
      mobileNumber: mobileNumber ?? this.mobileNumber,
    );
  }
}
