class Users1 {
  final String id;
  final String name;

  final String password;
  final String email;
  final String image;

  Users1({
    required this.id,
    required this.name,
    required this.password,
    required this.email,
    required this.image,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'password': password,
        'name': name,
        'email': email,
        'image': image,
      };

  static Users1 fromJson(Map<String, dynamic> json) => Users1(
        id: json['id'],
        name: json['name'],
        password: json['password'],
        email: json['email'],
        image: json['image'],
      );
}
