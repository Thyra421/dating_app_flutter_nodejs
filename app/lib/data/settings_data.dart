class SettingsData {
  bool? notifications;
  bool? appearOnRadar;
  bool? trackPosition;
  bool? darkMode;
  String? language;
  int? maxDistance;

  SettingsData({
    this.notifications,
    this.appearOnRadar,
    this.trackPosition,
    this.darkMode,
    this.language,
    this.maxDistance,
  });

  factory SettingsData.fromJson(Map<String, dynamic> json) => SettingsData(
        notifications: json['notifications'],
        appearOnRadar: json['appearOnRadar'],
        trackPosition: json['trackPosition'],
        darkMode: json['darkMode'],
        language: json['language'],
        maxDistance: json['maxDistance'],
      );

  void setFrom(SettingsData other) {
    if (other.notifications != null) notifications = other.notifications!;
    if (other.appearOnRadar != null) appearOnRadar = other.appearOnRadar!;
    if (other.trackPosition != null) trackPosition = other.trackPosition!;
    if (other.darkMode != null) darkMode = other.darkMode!;
    if (other.language != null) language = other.language!;
    if (other.maxDistance != null) maxDistance = other.maxDistance!;
  }

  Map<String, dynamic> toJson() => {
        if (notifications != null) 'notifications': notifications!,
        if (appearOnRadar != null) 'appearOnRadar': appearOnRadar!,
        if (trackPosition != null) 'trackPosition': trackPosition!,
        if (darkMode != null) 'darkMode': darkMode!,
        if (language != null) 'language': language!,
        if (maxDistance != null) 'maxDistance': maxDistance!,
      };
}
