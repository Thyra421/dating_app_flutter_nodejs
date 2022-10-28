class ErrorData {
  int? code;
  String? value;

  ErrorData({
    this.value,
    this.code,
  });

  factory ErrorData.fromJson(Map<String, dynamic> json) => ErrorData(
        value: json['value'],
        code: json['code'],
      );
}
