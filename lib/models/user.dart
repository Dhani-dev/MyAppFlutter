//Manejo de api

// Clase principal para el Modelo de Usuario
class User {
  final int id;
  final String firstName;
  final String lastName;
  final String email;
  final String image;
  final String username;

  // Campos opcionales para la funcionalidad de DELETE (soft-delete en la API falsa)
  final bool isDeleted; 

  // Constructor
  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.image,
    required this.username,
    this.isDeleted = false, // Por defecto, un usuario no está eliminado
  });

  // -------------------------------------------------------------------
  // 1. Factory Constructor para la Deserialización (JSON a Objeto Dart)
  // -------------------------------------------------------------------
  // Este constructor se usa cuando recibes datos de la API (GET, POST, PUT, DELETE)
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      email: json['email'] as String,
      image: json['image'] as String,
      username: json['username'] as String,
      
      // La API de DummyJSON incluye este campo en las respuestas de DELETE
      isDeleted: json['isDeleted'] ?? false, 
    );
  }

  // -------------------------------------------------------------------
  // 2. Método para Serialización (Objeto Dart a JSON)
  // -------------------------------------------------------------------
  // Este método se usa para enviar datos a la API (POST, PUT/PATCH)
  Map<String, dynamic> toJson() {
    return {
      // Generalmente no envías el 'id' al crear (POST)
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'username': username,
      // Se pueden incluir más campos según lo que necesites actualizar/crear
    };
  }

  // Método para crear una copia de la instancia con nuevos valores
  // Útil para la lógica de estado (Provider) y las operaciones de UPDATE
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