class PicturesData {
  List<String>? pictures;

  PicturesData({
    this.pictures,
  });

  factory PicturesData.fromJson(Map<String, dynamic> json) => PicturesData(
        pictures: List<String>.from(json['pictures']),
      );

  Map<String, dynamic> toJson() => {
        if (pictures != null) 'pictures': pictures!,
      };
}
