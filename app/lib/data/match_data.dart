import 'package:app/data/identity_data.dart';

class MatchData {
  int commonHobbiesCount;
  double distance;
  IdentityData matchIdentity;

  MatchData({
    required this.commonHobbiesCount,
    required this.distance,
    required this.matchIdentity,
  });

  factory MatchData.fromJson(Map<String, dynamic> json) => MatchData(
        commonHobbiesCount: json['commonHobbiesCount'],
        distance: json['distance'],
        matchIdentity: IdentityData.fromJson(json['matchIdentity']),
      );
}
