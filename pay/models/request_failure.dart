// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class RequestFailure {
  RequestFailure({
    required this.success,
    required this.code,
    required this.message,
  });
  final bool success;
  final String code;
  final String? message;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'success': success,
      'code': code,
      'message': message,
    };
  }

  factory RequestFailure.fromMap(Map<String, dynamic> map) {
    return RequestFailure(
      success: map['success'] as bool,
      code: map['code'] as String,
      message: map['message'],
    );
  }

  String toJson() => json.encode(toMap());

  factory RequestFailure.fromJson(String source) =>
      RequestFailure.fromMap(json.decode(source) as Map<String, dynamic>);
}


// {
//   "servlet": "jersey",
//   "message": "Request failed.",
//   "url": "/pg/v1/pay",
//   "status": "500"
// }