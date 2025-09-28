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
  final ScrollController _scrollController = ScrollController(); //Controlador para la paginación con Scroll
  String _searchQuery = ''; //Texto para el buscador

  @override
  void initState() {
    super.initState();
    //Inicia carga de la pagina
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<UserProvider>(context, listen: false).fetchUsers();
    });

    //Para detectar el final de la lista y cargar más
    _scrollController.addListener(() {
      final provider = Provider.of<UserProvider>(context, listen: false);

      double scrollThreshold = 0.9;
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent * scrollThreshold) {
        if (!provider.isLoading && provider.errorMessage == null) {
          provider.loadNextPage();
        }
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

//Para el buscador o filtrar usuarios
  List<User> _filterUsers(List<User> users) {
    if (_searchQuery.isEmpty) {
      return users;
    }
    return users.where((user) {
      //Filtra por nombre completo, email, username
      final fullName = '${user.firstName} ${user.lastName}'.toLowerCase();
      final email = user.email.toLowerCase();
      final query = _searchQuery.toLowerCase();
      return fullName.contains(query) ||
          email.contains(query) ||
          user.username.toLowerCase().contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, provider, child) {
        final filteredUsers = _filterUsers(provider.users);

        return Scaffold(
          appBar: AppBar(
            title: const Text('Usuarios'),
            centerTitle: true,
            actions: [
              //Boton para crear un nuevo usuario, create
              IconButton(
                icon: const Icon(Icons.person_add),
                onPressed: () => Navigator.of(context).pushNamed('/form'),
              ),
            ],
          ),
          body: Column(
            children: [
              //Texto para el buscador
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

              if (provider.errorMessage != null && filteredUsers.isEmpty)
                Center(child: Text(provider.errorMessage!))
              else if (filteredUsers.isEmpty && !provider.isLoading)
                const Center(child: Text('No hay usuarios para mostrar.'))
              else
                //Muestra la lista de los buscados
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    itemCount:
                        filteredUsers.length + (provider.isLoading ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index < filteredUsers.length) {
                        final user = filteredUsers[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 4.0,
                            horizontal: 8.0,
                          ),
                          child: Card(
                            elevation: 3,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                gradient: LinearGradient(
                                  colors: const [
                                    Color.fromARGB(
                                      255,
                                      230,
                                      230,
                                      255,
                                    ), 
                                    Colors
                                        .indigo, 
                                  ],
                                  begin: Alignment
                                      .topLeft, 
                                  end: Alignment
                                      .bottomRight, 
                                  stops: const [
                                    0.3,
                                    1.0,
                                  ], 
                                ),
                              ),

                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundImage: NetworkImage(user.image),
                                ),

                                title: Text(
                                  '${user.firstName} ${user.lastName}',
                                  style: const TextStyle(
                                    color: Colors.indigo,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                subtitle: Text(
                                  user.email,
                                  style: TextStyle(
                                    color: Colors.black.withOpacity(0.8),
                                  ),
                                ),
                                onTap: () {
                                  Navigator.of(
                                    context,
                                  ).pushNamed('/detail', arguments: user);
                                },
                                trailing: IconButton(
                                  icon: const Icon(
                                    Icons.edit,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {
                                    Navigator.of(
                                      context,
                                    ).pushNamed('/form', arguments: user);
                                  },
                                ),
                              ),
                            ),
                          ),
                        );
                      } else {
                        //Manejo del estado de carga al final de la lista
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
