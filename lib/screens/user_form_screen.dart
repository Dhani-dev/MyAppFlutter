//Pantalla de formulario, crear/editar usuario

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/user.dart';
import '../providers/user_provider.dart';

class UserFormScreen extends StatefulWidget {
  const UserFormScreen({super.key});

  @override
  State<UserFormScreen> createState() => _UserFormScreenState();
}

class _UserFormScreenState extends State<UserFormScreen> {
  // Key para la validación del formulario (Requisito: Validación de formularios)
  final _formKey = GlobalKey<FormState>(); 
  // Controladores para capturar el texto de los campos
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();

  // Variable para determinar si estamos editando o creando
  User? _editingUser; 
  bool _isSaving = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Obtiene el usuario pasado como argumento (si existe)
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is User) {
      _editingUser = args;
      // Precarga los campos si estamos EDITANDO
      _firstNameController.text = _editingUser!.firstName;
      _lastNameController.text = _editingUser!.lastName;
      _emailController.text = _editingUser!.email;
      _usernameController.text = _editingUser!.username;
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  // Método que maneja la creación o edición
  Future<void> _saveForm() async {
    if (!_formKey.currentState!.validate()) {
      return; // No hace nada si la validación falla
    }

    setState(() {
      _isSaving = true;
    });

    // Construye el mapa de datos a enviar a la API
    final userData = {
      'firstName': _firstNameController.text,
      'lastName': _lastNameController.text,
      'email': _emailController.text,
      'username': _usernameController.text,
      // Nota: El campo 'image' y otros se manejan de manera estática o se omiten en la simulación
    };

    final provider = Provider.of<UserProvider>(context, listen: false);
    bool success = false;

    if (_editingUser == null) {
      // Lógica CREATE (POST)
      success = await provider.createUser(userData);
    } else {
      // Lógica UPDATE (PUT/PATCH)
      success = await provider.updateUser(_editingUser!.id, userData);
    }

    if (context.mounted) {
      setState(() {
        _isSaving = false;
      });

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Usuario ${_editingUser == null ? 'creado' : 'actualizado'} con éxito.')),
        );
        Navigator.of(context).pop(); // Regresa a la lista
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${provider.errorMessage}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = _editingUser != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Editar Usuario' : 'Crear Nuevo Usuario'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Campo 1: First Name
              TextFormField(
                controller: _firstNameController,
                decoration: const InputDecoration(labelText: 'Nombre'),
                validator: (value) {
                  // Validación básica: campo obligatorio
                  if (value == null || value.isEmpty) {
                    return 'El nombre es obligatorio.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              // Campo 2: Last Name
              TextFormField(
                controller: _lastNameController,
                decoration: const InputDecoration(labelText: 'Apellido'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'El apellido es obligatorio.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              // Campo 3: Email
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty || !value.contains('@')) {
                    return 'Ingrese un email válido.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              // Campo 4: Username
               TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(labelText: 'Username'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'El username es obligatorio.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),
              // Botón de Guardar
              ElevatedButton(
                onPressed: _isSaving ? null : _saveForm,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: _isSaving
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(isEditing ? 'Guardar Cambios' : 'Crear Usuario'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}