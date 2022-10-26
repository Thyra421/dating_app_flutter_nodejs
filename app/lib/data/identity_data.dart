enum GenderData { male, female, nonBinary, other, prefereNotToSay }

class IdentityData {
  String firstName;
  String lastName;
  String description;
  DateTime dateOfBirth;
  GenderData gender;

  IdentityData({
    required this.firstName,
    required this.lastName,
    required this.description,
    required this.dateOfBirth,
    required this.gender,
  });

  factory IdentityData.fromJson(Map<String, dynamic> json) => IdentityData(
        firstName: json['firstName'],
        lastName: json['lastName'],
        description: json['description'],
        dateOfBirth: DateTime.parse(json['dateOfBirth']),
        gender: GenderData.values.firstWhere(
            (gender) => gender == json['gender'],
            orElse: () => GenderData.prefereNotToSay),
      );

  Map<String, dynamic> toJson() => {
        'firstName': firstName,
        'lastName': lastName,
        'description': description,
        'dateOfBirth': dateOfBirth,
        'gender': gender,
      };
}
