class StepsData {
  bool? identity;
  bool? gettingStarted;
  bool? confirmMail;

  StepsData({
    this.identity,
    this.gettingStarted,
    this.confirmMail,
  });

  factory StepsData.fromJson(Map<String, dynamic> json) => StepsData(
        identity: json['identity'],
        gettingStarted: json['gettingStarted'],
        confirmMail: json['confirmMail'],
      );

  Map<String, dynamic> toJson() => {
        if (identity != null) 'identity': identity!,
        if (gettingStarted != null) 'gettingStarted': gettingStarted!,
        if (confirmMail != null) 'confirmMail': confirmMail!,
      };
}
