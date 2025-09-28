//gestion del estado
import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/user_service.dart';

class UserProvider with ChangeNotifier {
  //Instancia del servicio para consumir la API
  final UserService _userService = UserService();

  List<User> _users = [];
  bool _isLoading = false;
  String? _errorMessage;
  int _limit = 12;
  int _skip = 0; 

  List<User> get users =>
      _users.where((user) => !user.isDeleted).toList();
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchUsers() async {
    if (_isLoading) return; 

    _isLoading = true;
    _errorMessage = null;
    notifyListeners(); 

    try {
      final newUsers = await _userService.fetchUsers(
        limit: _limit,
        skip: _skip,
      );

      if (_skip == 0) {
        _users = newUsers;
      } else {
        _users.addAll(newUsers);
      }

      _skip += _limit;
    } catch (e) {
      _errorMessage = 'Error al cargar los usuarios: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

//Crear usuario
  Future<bool> createUser(Map<String, dynamic> userData) async {
    _isLoading = true;
    notifyListeners();

    try {
      final newUser = await _userService.createUser(userData);

      _users.insert(
        0,
        newUser,
      ); //Añade el nuevo usuario al inicio de la lista

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Error al crear el usuario: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

//Editar usuario
  Future<bool> updateUser(int id, Map<String, dynamic> updatedData) async {
    _isLoading = true;
    notifyListeners();

    try {
      final updatedUser = await _userService.updateUser(id, updatedData);

      final index = _users.indexWhere((user) => user.id == id);
      if (index != -1) {
        _users[index] = updatedUser; //Reemplaza el antiguo con el nuevo
      }

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      if (e.toString().contains('Simulación exitosa: Actualización local')) {
        String? updatedImage = updatedData['image'] as String?; 
        final index = _users.indexWhere((user) => user.id == id);
        if (index != -1) {
          //Crea un nuevo objeto User con los datos actualizados
          final originalUser = _users[index];
          final updatedLocalUser = originalUser.copyWith(
            firstName: updatedData['firstName'],
            lastName: updatedData['lastName'],
            email: updatedData['email'],
            username: updatedData['username'],
            image: updatedImage,
          );
          _users[index] = updatedLocalUser; //Reemplaza localmente
        }
        _isLoading = false;
        notifyListeners();
        return true;
      }
      _errorMessage = 'Error al actualizar el usuario: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }


//Eliminar un usuario
  Future<bool> deleteUser(int id) async {
    _isLoading = true;
    notifyListeners();

    try {
      //Llama al servicio
      final deletedResult = await _userService.deleteUser(id);
      final index = _users.indexWhere((user) => user.id == id);
      if (index != -1) {
        _users[index] = _users[index].copyWith(isDeleted: true); //Se crea una copia del objeto para eliminarlo
      }

      _isLoading = false;
      notifyListeners();
      return true; 
    } catch (e) {
      _errorMessage = 'Error al eliminar el usuario: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

//Para manejar la paginacion con Scroll
  void loadNextPage() {
    if (!_isLoading) {
      fetchUsers();
    }
  }
}
