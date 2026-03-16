class User {
  final String id;
  final String name;
  final String email;
  final String? profileImageUrl;
  final String bio;
  final String role; // 'mentor' or 'mentee'
  final List<String> interests;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.profileImageUrl,
    required this.bio,
    this.role = 'mentee',
    this.interests = const [],
  });

  factory User.fromJson(Map<String, dynamic> json) {
    final id = json['id'];
    final name = json['name'];
    final email = json['email'];

    if (id == null || id is! String || id.isEmpty) {
      throw FormatException(
        'User.fromJson: missing or invalid required field "id" (got $id)',
      );
    }
    if (name == null || name is! String || name.isEmpty) {
      throw FormatException(
        'User.fromJson: missing or invalid required field "name" (got $name)',
      );
    }
    if (email == null || email is! String || email.isEmpty) {
      throw FormatException(
        'User.fromJson: missing or invalid required field "email" (got $email)',
      );
    }

    return User(
      id: id,
      name: name,
      email: email,
      profileImageUrl: json['profileImageUrl'] as String?,
      bio: json['bio'] as String? ?? '',
      role: json['role'] as String? ?? 'mentee',
      interests: List<String>.from(json['interests'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'profileImageUrl': profileImageUrl,
      'bio': bio,
      'role': role,
      'interests': interests,
    };
  }
}
