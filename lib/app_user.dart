class AppUser {
  final String username;
  final String email;
  final String password;

  AppUser({required this.username, required this.email, required this.password});

  Map<String, String> get userData => {
    'username': username,
    'email': email,
    'password': password,
  };
}