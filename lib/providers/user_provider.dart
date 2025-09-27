//gestion del estado
import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/user_service.dart';

// El controlador o gestor de estado (Provider)
class UserProvider with ChangeNotifier {
  // 1. Dependencia: Instancia del servicio para consumir la API
  final UserService _userService = UserService();

  // 2. Estado de la Aplicación (Datos y Control)
  List<User> _users = [];
  bool _isLoading = false;
  String? _errorMessage;
  int _limit = 10; // Para paginación
  int _skip = 0;   // Para paginación

  // 3. Getters para que la UI pueda acceder al estado
  List<User> get users => _users.where((user) => !user.isDeleted).toList(); // Filtra eliminados
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // -------------------------------------------------------------------
  // READ: Obtener y Paginar Usuarios
  // -------------------------------------------------------------------
  Future<void> fetchUsers() async {
    if (_isLoading) return; // Evita llamadas concurrentes

    _isLoading = true;
    _errorMessage = null;
    notifyListeners(); // Notifica a la UI que la carga ha comenzado

    try {
      final newUsers = await _userService.fetchUsers(limit: _limit, skip: _skip);
      
      // Si es la primera carga (skip=0), reemplaza la lista; si no, añade
      if (_skip == 0) {
        _users = newUsers;
      } else {
        _users.addAll(newUsers);
      }
      
      // Actualiza el 'skip' para la próxima página
      _skip += _limit;

    } catch (e) {
      _errorMessage = 'Error al cargar los usuarios: $e';
    } finally {
      _isLoading = false;
      notifyListeners(); // Notifica a la UI que la carga ha finalizado (éxito o error)
    }
  }

  // -------------------------------------------------------------------
  // CREATE: Agregar un nuevo usuario (Desde el formulario)
  // -------------------------------------------------------------------
  Future<bool> createUser(Map<String, dynamic> userData) async {
    _isLoading = true;
    notifyListeners();

    try {
      final newUser = await _userService.createUser(userData);
      
      // 1. Actualización Automática de la Interfaz (Requisito)
      _users.insert(0, newUser); // Añade el nuevo usuario al inicio de la lista local
      
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

  // -------------------------------------------------------------------
  // UPDATE: Editar un usuario (Desde el formulario)
  // -------------------------------------------------------------------
  Future<bool> updateUser(int id, Map<String, dynamic> updatedData) async {
    _isLoading = true;
    notifyListeners();

    try {
      final updatedUser = await _userService.updateUser(id, updatedData);
      
      // 1. Actualización Automática de la Interfaz (Requisito)
      final index = _users.indexWhere((user) => user.id == id);
      if (index != -1) {
        _users[index] = updatedUser; // Reemplaza el objeto antiguo con el nuevo
      }

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Error al actualizar el usuario: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
  
  // -------------------------------------------------------------------
  // DELETE: Eliminar un usuario
  // -------------------------------------------------------------------
  Future<bool> deleteUser(int id) async {
    _isLoading = true;
    notifyListeners();

    try {
      // No necesitamos el resultado de la API, solo la confirmación de la operación
      await _userService.deleteUser(id); 

      // 1. Actualización Automática de la Interfaz (Requisito)
      // Como DummyJSON hace un soft-delete, actualizamos el objeto local
      final index = _users.indexWhere((user) => user.id == id);
      if (index != -1) {
        // Creamos una copia del objeto marcándolo como eliminado
        _users[index] = _users[index].copyWith(isDeleted: true); 
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

  // Método para manejar la paginación con Scroll Infinito (Requisito)
  void loadNextPage() {
    // Si no está cargando y hay más elementos, intenta cargar la siguiente página
    if (!_isLoading) {
      fetchUsers();
    }
  }
}