//Manejo de api

const String defaultImageUrl = 'https://cdn-icons-png.flaticon.com/512/4140/4140047.png'; //Imagen de usuario por defecto
// Modelo de Usuario
class User {
  final int id;
  final String firstName;
  final String lastName;
  final String email;
  final String image;
  final String username;

  final bool isDeleted; 

  // Constructor
  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.image,
    required this.username,
    this.isDeleted = false, 
  });

  //Deserializacion de JSON a objeto de dart, cuando se recibe datos de la api
  factory User.fromJson(Map<String, dynamic> json) {
    
    return User(
      id: json['id'] as int,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      email: json['email'] as String,
      image: json['image'] as String,
      username: json['username'] as String,
      isDeleted: json['isDeleted'] ?? false, 
    );
  }

  //Serializacion de objeto de dart a JSON, cuando se envia datos de la api
  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'username': username,
      'image': image,
    };
  }

  User copyWith({
    int? id,
    String? firstName,
    String? lastName,
    String? email,
    String? image,
    String? username,
    bool? isDeleted,
  }) {
    return User(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      image: image ?? this.image,
      username: username ?? this.username,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }
}