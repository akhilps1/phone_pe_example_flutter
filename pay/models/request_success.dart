import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class RequestSuccess {
  RequestSuccess({
    required this.success,
    required this.code,
    required this.message,
    required this.data,
  });
  final bool? success;
  final String code;
  final String message;
  final Data data;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'success': success,
      'code': code,
      'message': message,
      'data': data.toMap(),
    };
  }

  factory RequestSuccess.fromMap(Map<String, dynamic> map) {
    return RequestSuccess(
      success: map['success'],
      code: map['code'] as String,
      message: map['message'] as String,
      data: Data.fromMap(map['data'] as Map<String, dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory RequestSuccess.fromJson(String source) =>
      RequestSuccess.fromMap(json.decode(source) as Map<String, dynamic>);
}

class Data {
  Data({
    required this.merchantId,
    required this.merchantTransactionId,
    required this.instrumentResponse,
  });
  final String merchantId;
  final String merchantTransactionId;
  final InstrumentResponse instrumentResponse;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'merchantId': merchantId,
      'merchantTransactionId': merchantTransactionId,
      'instrumentResponse': instrumentResponse.toMap(),
    };
  }

  factory Data.fromMap(Map<String, dynamic> map) {
    return Data(
      merchantId: map['merchantId'] as String,
      merchantTransactionId: map['merchantTransactionId'] as String,
      instrumentResponse: InstrumentResponse.fromMap(
          map['instrumentResponse'] as Map<String, dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory Data.fromJson(String source) =>
      Data.fromMap(json.decode(source) as Map<String, dynamic>);
}

class InstrumentResponse {
  InstrumentResponse({
    required this.type,
    required this.redirectInfo,
  });
  final String type;
  final RedirectInfo redirectInfo;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'type': type,
      'redirectInfo': redirectInfo.toMap(),
    };
  }

  factory InstrumentResponse.fromMap(Map<String, dynamic> map) {
    return InstrumentResponse(
      type: map['type'] as String,
      redirectInfo:
          RedirectInfo.fromMap(map['redirectInfo'] as Map<String, dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory InstrumentResponse.fromJson(String source) =>
      InstrumentResponse.fromMap(json.decode(source) as Map<String, dynamic>);
}

class RedirectInfo {
  RedirectInfo({
    required this.url,
    required this.method,
  });
  final String url;
  final String method;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'url': url,
      'method': method,
    };
  }

  factory RedirectInfo.fromMap(Map<String, dynamic> map) {
    return RedirectInfo(
      url: map['url'] as String,
      method: map['method'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory RedirectInfo.fromJson(String source) =>
      RedirectInfo.fromMap(json.decode(source) as Map<String, dynamic>);
}
