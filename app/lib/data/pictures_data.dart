import 'package:lust/data/picture_data.dart';

class PicturesData {
  List<PictureData>? pictures;

  PicturesData({
    this.pictures,
  });

  factory PicturesData.fromJson(Map<String, dynamic> json) => PicturesData(
        pictures: List<Map<String, dynamic>>.from(json['pictures'])
            .map((pic) => PictureData.fromJson(pic))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        if (pictures != null)
          'pictures': pictures!.map((p) => p.toJson()).toList(),
      };
}
