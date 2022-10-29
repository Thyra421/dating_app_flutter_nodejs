enum GenderData { male, female, nonBinary, other, prefereNotToSay }

class IdentityData {
  String? firstName;
  String? description;
  DateTime? dateOfBirth;
  GenderData? gender;

  IdentityData({
    this.firstName,
    this.description,
    this.dateOfBirth,
    this.gender,
  });

  factory IdentityData.fromJson(Map<String, dynamic> json) => IdentityData(
      firstName: json['firstName'],
      description: json['description'],
      dateOfBirth: json['dateOfBirth'] != null
          ? DateTime.parse(json['dateOfBirth'])
          : null,
      gender: json['gender'] != null &&
              GenderData.values.any((gender) => gender.name == json['gender'])
          ? GenderData.values
              .firstWhere((gender) => gender.name == json['gender'])
          : null);

  void setFrom(IdentityData other) {
    if (other.firstName != null) firstName = other.firstName!;
    if (other.description != null) description = other.description!;
    if (other.dateOfBirth != null) dateOfBirth = other.dateOfBirth!;
    if (other.gender != null) gender = other.gender!;
  }

  Map<String, dynamic> toJson() => {
        if (firstName != null) 'firstName': firstName!,
        if (description != null) 'description': description!,
        if (dateOfBirth != null)
          'dateOfBirth': dateOfBirth!.toString().split(' ').first,
        if (gender != null) 'gender': gender!.name,
      };
}
