import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/user_provider.dart';
import 'screens/user_list_screen.dart';
import 'screens/user_detail_screen.dart';
import 'screens/user_form_screen.dart';

void main() {
  runApp(
    // En este caso, inicializamos el UserProvider antes de la app
    ChangeNotifierProvider(
      create: (context) => UserProvider(), // <- ¡Aquí cambiamos a UserProvider!
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Práctica Flutter CRUD Users', // Título de la app
      theme: ThemeData(
        // Define tu paleta de colores principal para la interfaz atractiva [cite: 35]
        primarySwatch: Colors.indigo, 
      ),
      debugShowCheckedModeBanner: false, 
      // Define la pantalla inicial (Lista de registros)
      home: const UserListScreen(), // <- ¡Aquí cambiamos a UserListScreen!
      
      // Opcional: Define las rutas de navegación para mayor limpieza
      routes: {
        '/list': (context) => const UserListScreen(),
        '/detail': (context) => const UserDetailScreen(),
        '/form': (context) => UserFormScreen(),
      },
      initialRoute: '/list',
    );
  }
}







