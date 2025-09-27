//Pantalla de lista, muestra usuarios
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../models/user.dart';

class UserListScreen extends StatefulWidget {
  const UserListScreen({super.key});

  @override
  State<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  // Controlador para la paginación con Scroll Infinito
  final ScrollController _scrollController = ScrollController();
  // Texto para la funcionalidad de Buscador/Filtro (Requisito)
  String _searchQuery = ''; 

  @override
  void initState() {
    super.initState();
    // Inicia la carga de la primera página
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<UserProvider>(context, listen: false).fetchUsers();
    });

    // Listener para detectar el final de la lista y cargar más (Paginación)
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        Provider.of<UserProvider>(context, listen: false).loadNextPage();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // Lógica de filtrado (Requisito: Buscador o Filtro)
  List<User> _filterUsers(List<User> users) {
    if (_searchQuery.isEmpty) {
      return users;
    }
    return users.where((user) {
      // Filtra por nombre completo, email o username (puedes ajustar los campos)
      final fullName = '${user.firstName} ${user.lastName}'.toLowerCase();
      final email = user.email.toLowerCase();
      final query = _searchQuery.toLowerCase();
      return fullName.contains(query) || email.contains(query) || user.username.toLowerCase().contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    // Usamos Consumer para escuchar los cambios del UserProvider
    return Consumer<UserProvider>(
      builder: (context, provider, child) {
        final filteredUsers = _filterUsers(provider.users);

        return Scaffold(
          appBar: AppBar(
            title: const Text('Usuarios (CRUD)'),
            actions: [
              // Botón para ir a crear un nuevo usuario (CREATE)
              IconButton(
                icon: const Icon(Icons.person_add),
                onPressed: () => Navigator.of(context).pushNamed('/form'),
              ),
            ],
          ),
          body: Column(
            children: [
              // Campo de texto para el buscador
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  decoration: const InputDecoration(
                    labelText: 'Buscar usuario',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                ),
              ),
              
              // 1. Manejo del estado de ERROR
              if (provider.errorMessage != null && filteredUsers.isEmpty)
                Center(child: Text(provider.errorMessage!))
              else if (filteredUsers.isEmpty && !provider.isLoading)
                const Center(child: Text('No hay usuarios para mostrar.'))
              else
                // 2. Muestra la lista
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    itemCount: filteredUsers.length + (provider.isLoading ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index < filteredUsers.length) {
                        final user = filteredUsers[index];
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(user.image),
                          ),
                          title: Text('${user.firstName} ${user.lastName}'),
                          subtitle: Text(user.email),
                          onTap: () {
                            // Navegación a la pantalla de detalle
                            Navigator.of(context).pushNamed(
                              '/detail',
                              arguments: user, // Pasa el objeto User al detalle
                            );
                          },
                          // Icono para editar (navega al formulario)
                          trailing: IconButton(
                            icon: const Icon(Icons.edit, color: Colors.indigo),
                            onPressed: () {
                              Navigator.of(context).pushNamed('/form', arguments: user);
                            },
                          ),
                        );
                      } else {
                        // 3. Manejo del estado de CARGA (al final de la lista para paginación)
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }
                    },
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}