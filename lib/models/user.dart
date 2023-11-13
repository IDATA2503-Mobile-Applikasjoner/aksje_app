/// Represents a user's account information.
class User {
  /// Email address of the user.
  final String email;

  /// Password for the user's account.
  final String password;

  /// Unique identifier for the user.
  final int uid;

  /// Constructs a [User] with a given [email], [password], and [uid].
  User({
    required this.email,
    required this.password,
    required this.uid,
  });

  /// Converts a [User] instance to JSON format.
  ///
  /// Returns a map with keys 'email', 'password', and 'uid'.
  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      'uid': uid,
    };
  }

  /// Creates a [User] instance from JSON data.
  ///
  /// The [json] parameter must contain the keys 'email', 'password', and 'uid'.
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      email: json['email'] as String,
      password: json['password'] as String,
      uid: json['uid'] as int,
    );
  }
}
