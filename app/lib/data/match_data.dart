import 'package:app/data/identity_data.dart';

class MatchData {
  int? commonHobbiesCount;
  double? distance;
  IdentityData? matchIdentity;

  MatchData({
    this.commonHobbiesCount,
    this.distance,
    this.matchIdentity,
  });

  factory MatchData.fromJson(Map<String, dynamic> json) => MatchData(
      commonHobbiesCount: json['commonHobbiesCount'],
      distance: json['distance'],
      matchIdentity: json['identity'] != null
          ? IdentityData.fromJson(json['identity'])
          : null);
}
