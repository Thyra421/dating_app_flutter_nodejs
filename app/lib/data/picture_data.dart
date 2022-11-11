class PictureData {
  String? name;
  String? originalName;
  String? url;

  PictureData({
    this.name,
    this.originalName,
    this.url,
  });

  factory PictureData.fromJson(Map<String, dynamic> json) => PictureData(
        name: json['name'],
        originalName: json['originalName'],
        url: json['url'],
      );

  Map<String, dynamic> toJson() => {
        if (name != null) 'name': name,
        if (originalName != null) 'originalName': originalName,
      };
}
