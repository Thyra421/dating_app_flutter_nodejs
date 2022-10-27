class ErrorData {
  int code;
  String value;

  ErrorData({
    required this.value,
    required this.code,
  });

  factory ErrorData.fromJson(Map<String, dynamic> json) => ErrorData(
        value: json['value'],
        code: json['code'],
      );
}
