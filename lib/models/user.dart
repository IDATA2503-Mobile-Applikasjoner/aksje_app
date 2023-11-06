class User {
  final String email;
  final String password;
  final int uid;

  User({
    required this.email,
    required this.password,
    required this.uid
  });

    Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      'uid': uid
    };
  }

    factory User.fromJson(Map<String, dynamic> json) {
    return User(
      email: json['email'],
      password: json['password'],
      uid: json['uid']
    );
  }
}