class SettingsData {
  bool notifications;
  bool appearOnRadar;
  bool trackPosition;
  bool darkMode;
  String language;

  SettingsData({
    required this.notifications,
    required this.appearOnRadar,
    required this.trackPosition,
    required this.darkMode,
    required this.language,
  });

  factory SettingsData.fromJson(Map<String, dynamic> json) => SettingsData(
        notifications: json['notifications'],
        appearOnRadar: json['appearOnRadar'],
        trackPosition: json['trackPosition'],
        darkMode: json['darkMode'],
        language: json['language'],
      );

  Map<String, dynamic> toJson() => {
        'notifications': notifications,
        'appearOnRadar': appearOnRadar,
        'trackPosition': trackPosition,
        'darkMode': darkMode,
        'language': language,
      };
}
