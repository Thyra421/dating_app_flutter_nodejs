class SettingsData {
  bool? notifications;
  bool? appearOnSearch;
  bool? darkMode;
  String? language;
  int? maxDistance;

  SettingsData({
    this.notifications,
    this.appearOnSearch,
    this.darkMode,
    this.language,
    this.maxDistance,
  });

  factory SettingsData.fromJson(Map<String, dynamic> json) => SettingsData(
        notifications: json['notifications'],
        appearOnSearch: json['appearOnSearch'],
        darkMode: json['darkMode'],
        language: json['language'],
        maxDistance: json['maxDistance'],
      );

  void setFrom(SettingsData other) {
    if (other.notifications != null) notifications = other.notifications!;
    if (other.appearOnSearch != null) appearOnSearch = other.appearOnSearch!;
    if (other.darkMode != null) darkMode = other.darkMode!;
    if (other.language != null) language = other.language!;
    if (other.maxDistance != null) maxDistance = other.maxDistance!;
  }

  Map<String, dynamic> toJson() => {
        if (notifications != null) 'notifications': notifications!,
        if (appearOnSearch != null) 'appearOnSearch': appearOnSearch!,
        if (darkMode != null) 'darkMode': darkMode!,
        if (language != null) 'language': language!,
        if (maxDistance != null) 'maxDistance': maxDistance!,
      };
}
