class RelationsData {
  List<String>? blocked;
  List<String>? notInterested;

  RelationsData({
    this.blocked,
    this.notInterested,
  });

  factory RelationsData.fromJson(Map<String, dynamic> json) => RelationsData(
        blocked: List<String>.from(json['blocked']),
        notInterested: List<String>.from(json['notInterested']),
      );

  Map<String, dynamic> toJson() => {
        if (blocked != null) 'blocked': blocked!,
        if (notInterested != null) 'notInterested': notInterested!,
      };
}
