class User {
  final String id;
  final String name;
  final String email;
  final String? profileImageUrl;
  final String bio;
  final String role; // 'mentor' or 'mentee'

  User({
    required this.id,
    required this.name,
    required this.email,
    this.profileImageUrl,
    required this.bio,
    this.role = 'mentee',
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      profileImageUrl: json['profileImageUrl'],
      bio: json['bio'] ?? '',
      role: json['role'] ?? 'mentee',
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
    };
  }
}
