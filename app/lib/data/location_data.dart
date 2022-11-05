class LocationData {
  double? posX;
  double? posY;

  LocationData({
    this.posX,
    this.posY,
  });

  factory LocationData.fromJson(Map<String, dynamic> json) => LocationData(
        posX: json['posX'],
        posY: json['posY'],
      );

  Map<String, dynamic> toJson() => {
        if (posX != null) 'posX': posX!,
        if (posY != null) 'posY': posY!,
      };
}
