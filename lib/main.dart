import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page :)'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          Container(
          color: Colors.black,
          child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.all(20),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Text("Holi", style: TextStyle(fontSize: 20)), 
                    decoration: BoxDecoration(color: const Color.fromARGB(255, 17, 227, 255), 
                    borderRadius: BorderRadius.all(Radius.circular(10))
                    ),
                  ), 
                  decoration: BoxDecoration(
                    color: Colors.cyanAccent,
                    borderRadius: BorderRadius.all(Radius.circular(10)), 
                    ),
                  ),
                Container(
                  height: 100,
                  width: 100,
                  child: Center(child: Text('Hellu')),
                  decoration: BoxDecoration(
                    color: Colors.cyanAccent,
                    borderRadius: BorderRadius.all(Radius.circular(10))
                    ),
                )
              ],
            ),
          ),
          /*Container(
            height: 400,
            color: Colors.cyanAccent,
            child: Image.network(
              width: 200,
              fit: BoxFit.contain,
              'https://unblast.com/wp-content/uploads/2021/01/Space-Background-Image-5.jpg'
            ),
          ), */
          Image.asset('assets/images/nube.jpg'),
          Row(children: 
            [Text('juju'), 
            Text('bubu')]
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
