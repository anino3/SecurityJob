class User1 {
  final String id;
  final String name;
  final String username;
  final String password;
  final String email;

  User1({
    required this.id,
    required this.name,
    required this.username,
    required this.password,
    required this.email,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'username': username,
        'password': password,
        'name': name,
        'email': email,
      };

  static User1 fromJson(Map<String, dynamic> json) => User1(
        id: json['id'],
        name: json['name'],
        username: json['username'],
        password: json['password'],
        email: json['email'],
      );
}
