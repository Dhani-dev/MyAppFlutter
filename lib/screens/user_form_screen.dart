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
  //Key para la validacion del formulario
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _imageUrlController = TextEditingController();

  //Verifica si se esta editando o creando
  User? _editingUser;
  bool _isSaving = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is User) {
      _editingUser = args;
      _firstNameController.text = _editingUser!.firstName;
      _lastNameController.text = _editingUser!.lastName;
      _emailController.text = _editingUser!.email;
      _usernameController.text = _editingUser!.username;
      _imageUrlController.text = _editingUser!.image;
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _usernameController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  //Para validar la creacion o edicion
  Future<void> _saveForm() async {
    if (!_formKey.currentState!.validate()) {
      return; 
    }

    setState(() {
      _isSaving = true;
    });

    final isEditing = _editingUser != null;
    //Construye el mapa de datos para enviar a la API
    final userData = {
      'firstName': _firstNameController.text,
      'lastName': _lastNameController.text,
      'email': _emailController.text,
      'username': _usernameController.text,
      'image': _imageUrlController.text.isNotEmpty
          ? _imageUrlController
                .text //Se usa la url ingresada
          : (isEditing ? _editingUser!.image : defaultImageUrl),
    };

    final provider = Provider.of<UserProvider>(context, listen: false);
    bool success = false;

    if (_editingUser == null) {
      success = await provider.createUser(userData); //Para crear, post
    } else {
      success = await provider.updateUser(_editingUser!.id, userData); //Para actualizar, put
    }

    if (context.mounted) {
      setState(() {
        _isSaving = false;
      });

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Usuario ${_editingUser == null ? 'creado' : 'actualizado'} con éxito.',
            ),
          ),
        );
        Navigator.of(context).pop(); //Regresa a la lista
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
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [

              TextFormField(
                controller: _firstNameController,
                decoration: const InputDecoration(labelText: 'Nombre'),
                validator: (value) {
                  //Validación campo obligatorio
                  if (value == null || value.isEmpty) {
                    return 'El nombre es obligatorio.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),

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

              TextFormField(
                controller: _imageUrlController,
                decoration: const InputDecoration(
                  labelText: 'URL de Imagen (Opcional)',
                ),
                keyboardType: TextInputType.url,
 
              ),
              const SizedBox(height: 30),
              //Boton de Guardar
              SizedBox(
                width: double.infinity,
                height: 50,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      15,
                    ), 
                    gradient: const LinearGradient(
                      colors: [
                        Color.fromARGB(
                          255,
                          230,
                          230,
                          255,
                        ), 
                        Colors.indigo, 
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      stops: [0.3, 1.0],
                    ),
                  ),
                  child: ElevatedButton(
                    onPressed: _saveForm, //Llama a la funcion para guardar
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors
                          .transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: const Text(
                      'Guardar Cambios',
                      style: TextStyle(
                        color: Colors.indigo,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
