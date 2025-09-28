//Comunicación con la api (GET, POST, PUT, DELETE)
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user.dart';

//Rango de id de la api de 1 a 100, mayores a este son creados localmente
const int _maxApiId = 100;

class UserService {
  //URL de la API
  static const String baseUrl = 'https://dummyjson.com/users';

//Obtiene usuarios
  Future<List<User>> fetchUsers({int limit = 10, int skip = 0}) async {
    // Implementación para la paginación (requisito funcional)
    final url = Uri.parse('$baseUrl?limit=$limit&skip=$skip');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List usersJson = data['users'];
      
      return usersJson.map((json) => User.fromJson(json)).toList();
    } else {
      throw Exception('Fallo al cargar los usuarios: ${response.statusCode}');
    }
  }

//Crear un nuevo usuario, post
  Future<User> createUser(Map<String, dynamic> newUser) async {
    final url = Uri.parse('$baseUrl/add');
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(newUser),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return User.fromJson(json.decode(response.body));
    } else {
      throw Exception('Fallo al crear el usuario. Código: ${response.statusCode}');
    }
  }


//Editar un usuario, put
  Future<User> updateUser(int id, Map<String, dynamic> updatedFields) async {
    if (id > _maxApiId) {
    print('Simulación de actualización para ID $id');
    
    throw Exception('Simulación exitosa: Actualización local para ID $id');
  }
    final url = Uri.parse('$baseUrl/$id'); //Endpoint: id
    final response = await http.put(
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

//Eliminar un usuario, delete
  Future<Map<String, dynamic>> deleteUser(int id) async {
    if (id > _maxApiId) {
    print('DELETE LOCAL: Simulación de eliminación para ID $id');
    return {'id': id, 'isDeleted': true}; 
  }
    final url = Uri.parse('$baseUrl/$id'); //Endpoint: id
    final response = await http.delete(url);

    if (response.statusCode == 200) {
      return json.decode(response.body); 
    } else {
      throw Exception('Fallo al eliminar el usuario. Código: ${response.statusCode}');
    }
  }
}