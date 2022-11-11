import 'package:lust/data/identity_data.dart';
import 'package:lust/data/pictures_data.dart';

class MatchData {
  int? commonHobbiesCount;
  double? distance;
  IdentityData? matchIdentity;
  String? userId;
  PicturesData? pictures;
  bool? noMatch;

  MatchData({
    this.commonHobbiesCount,
    this.distance,
    this.matchIdentity,
    this.userId,
    this.noMatch,
    this.pictures,
  });

  factory MatchData.fromJson(Map<String, dynamic> json) => MatchData(
      noMatch: json['noMatch'],
      commonHobbiesCount: json['commonHobbiesCount'],
      pictures: json['pictures'] != null
          ? PicturesData.fromJson(json['pictures'])
          : null,
      distance: json['distance'],
      userId: json['userId'],
      matchIdentity: json['identity'] != null
          ? IdentityData.fromJson(json['identity'])
          : null);
}
