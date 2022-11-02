class HobbiesData {
  List<String>? hobbies;

  HobbiesData({
    this.hobbies,
  });

  factory HobbiesData.fromJson(Map<String, dynamic> json) => HobbiesData(
        hobbies: List<String>.from(json['hobbies']),
      );

  Map<String, dynamic> toJson() => {
        if (hobbies != null) 'hobbies': hobbies!,
      };
}
