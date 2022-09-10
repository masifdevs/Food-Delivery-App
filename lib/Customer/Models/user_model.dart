class User {
  int id;
  String username;
  String email;
  String phone;
  String password;

  User({
    this.id,
    this.phone,
    this.username,
    this.email,
    this.password,
  });
  factory User.fromJson(Map<String, dynamic> jsonData) {
    return User(
      id: int.parse(jsonData['id']),
      username: jsonData['Name'],
      email: jsonData['email'],
      phone: jsonData['phone'],
    );
  }
}
