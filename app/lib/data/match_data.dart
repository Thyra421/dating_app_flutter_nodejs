import 'package:lust/data/identity_data.dart';

class MatchData {
  int? commonHobbiesCount;
  double? distance;
  IdentityData? matchIdentity;
  String? userId;
  bool? noMatch;

  MatchData({
    this.commonHobbiesCount,
    this.distance,
    this.matchIdentity,
    this.userId,
    this.noMatch,
  });

  factory MatchData.fromJson(Map<String, dynamic> json) => MatchData(
      noMatch: json['noMatch'],
      commonHobbiesCount: json['commonHobbiesCount'],
      distance: json['distance'],
      userId: json['userId'],
      matchIdentity: json['identity'] != null
          ? IdentityData.fromJson(json['identity'])
          : null);
}
