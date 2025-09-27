//Comunicación con la api (GET, POST, PUT, DELETE)

// user_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user.dart'; // Asegúrate de que la ruta sea correcta

class UserService {
  // URL base de la API que elegiste para los usuarios
  static const String baseUrl = 'https://dummyjson.com/users';

  // -------------------------------------------------------------------
  // 1. READ: Obtener lista de usuarios (GET)
  // -------------------------------------------------------------------
  Future<List<User>> fetchUsers({int limit = 10, int skip = 0}) async {
    // Implementación para la paginación (requisito funcional)
    final url = Uri.parse('$baseUrl?limit=$limit&skip=$skip');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      // DummyJSON devuelve un mapa con la clave 'users'
      final Map<String, dynamic> data = json.decode(response.body);
      final List usersJson = data['users'];
      
      // Mapeamos cada objeto JSON a nuestra clase User
      return usersJson.map((json) => User.fromJson(json)).toList();
    } else {
      // Manejo de estados de error (requisito)
      throw Exception('Fallo al cargar los usuarios: ${response.statusCode}');
    }
  }

  // -------------------------------------------------------------------
  // 2. CREATE: Crear un nuevo usuario (POST)
  // -------------------------------------------------------------------
  Future<User> createUser(Map<String, dynamic> newUser) async {
    final url = Uri.parse('$baseUrl/add');
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      // Codificamos el mapa del nuevo usuario a JSON
      body: jsonEncode(newUser),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      // Si la API es exitosa, devuelve el objeto creado
      return User.fromJson(json.decode(response.body));
    } else {
      throw Exception('Fallo al crear el usuario. Código: ${response.statusCode}');
    }
  }

  // -------------------------------------------------------------------
  // 3. UPDATE: Editar un usuario existente (PUT/PATCH)
  // -------------------------------------------------------------------
  Future<User> updateUser(int id, Map<String, dynamic> updatedFields) async {
    final url = Uri.parse('$baseUrl/$id'); // Endpoint: /users/{id}
    final response = await http.put( // Usamos PUT o PATCH
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(updatedFields),
    );

    if (response.statusCode == 200) {
      return User.fromJson(json.decode(response.body));
    } else {
      throw Exception('Fallo al actualizar el usuario. Código: ${response.statusCode}');
    }
  }

  // -------------------------------------------------------------------
  // 4. DELETE: Eliminar un usuario (DELETE)
  // -------------------------------------------------------------------
  Future<Map<String, dynamic>> deleteUser(int id) async {
    final url = Uri.parse('$baseUrl/$id'); // Endpoint: /users/{id}
    final response = await http.delete(url);

    if (response.statusCode == 200) {
      // La API de DummyJSON devuelve el objeto eliminado con un flag.
      return json.decode(response.body); 
    } else {
      throw Exception('Fallo al eliminar el usuario. Código: ${response.statusCode}');
    }
  }
}