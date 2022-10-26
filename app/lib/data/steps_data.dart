class StepsData {
  bool identity;
  bool gettingStarted;
  bool confirmMail;

  StepsData({
    required this.identity,
    required this.gettingStarted,
    required this.confirmMail,
  });

  factory StepsData.fromJson(Map<String, dynamic> json) => StepsData(
        identity: json['identity'],
        gettingStarted: json['gettingStarted'],
        confirmMail: json['confirmMail'],
      );

  Map<String, dynamic> toJson() => {
        'identity': identity,
        'gettingStarted': gettingStarted,
        'confirmMail': confirmMail,
      };
}
