class User {
  final String email;

  User({required this.email});

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      email: map['email'] as String,
    );
  }
}
