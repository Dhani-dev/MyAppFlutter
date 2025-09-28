import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/user_provider.dart';
import 'screens/user_list_screen.dart';
import 'screens/user_detail_screen.dart';
import 'screens/user_form_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => UserProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Práctica Flutter Users Dani',
      theme: ThemeData(
        primarySwatch: Colors.indigo, //Paleta de colores
      ),
      debugShowCheckedModeBanner: false, 
      
      routes: {
        '/': (context) => const UserListScreen(),
        '/detail': (context) => const UserDetailScreen(),
        '/form': (context) => UserFormScreen(),
      },
      initialRoute: '/',
    );
  }
}







