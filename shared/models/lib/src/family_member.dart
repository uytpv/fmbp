class FamilyMember {
  final String id;
  final String familyId;
  final String name;          // VD: "Ba (Bố)", "Mẹ", "Anh Hai", "Em gái"
  final String relationship;  // "Bố", "Mẹ", "Con trai", "Con gái", "Ông", "Bà"
  final String gender;        // "MALE", "FEMALE"
  final int birthYear;        // VD: 1981, 2008, 2012
  final List<String> dietaryPreferences; // VD: ["Không ăn thịt mỡ", "Thích ăn chay", "Nhiều rau"]

  const FamilyMember({
    required this.id,
    required this.familyId,
    required this.name,
    required this.relationship,
    required this.gender,
    required this.birthYear,
    required this.dietaryPreferences,
  });

  /// Tính tuổi tự động tăng theo từng năm (2026 -> 45t, 2027 -> 46t)
  int get age => DateTime.now().year - birthYear;

  Map<String, dynamic> toJson() => {
        'id': id,
        'familyId': familyId,
        'name': name,
        'relationship': relationship,
        'gender': gender,
        'birthYear': birthYear,
        'dietaryPreferences': dietaryPreferences,
      };

  factory FamilyMember.fromJson(Map<String, dynamic> json) => FamilyMember(
        id: json['id'] as String,
        familyId: json['familyId'] as String,
        name: json['name'] as String,
        relationship: json['relationship'] as String,
        gender: json['gender'] as String,
        birthYear: (json['birthYear'] as num).toInt(),
        dietaryPreferences: List<String>.from(json['dietaryPreferences'] ?? []),
      );
}
