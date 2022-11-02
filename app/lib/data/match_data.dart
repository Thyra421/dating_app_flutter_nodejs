import 'package:lust/data/identity_data.dart';

class MatchData {
  int? commonHobbiesCount;
  double? distance;
  IdentityData? matchIdentity;
  String? userId;

  MatchData({
    this.commonHobbiesCount,
    this.distance,
    this.matchIdentity,
    this.userId,
  });

  factory MatchData.fromJson(Map<String, dynamic> json) => MatchData(
      commonHobbiesCount: json['commonHobbiesCount'],
      distance: json['distance'],
      userId: json['userId'],
      matchIdentity: json['identity'] != null
          ? IdentityData.fromJson(json['identity'])
          : null);
}
