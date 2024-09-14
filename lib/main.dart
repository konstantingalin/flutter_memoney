import 'package:flutter/material.dart';
import 'auth/login/login.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://muvvrtnzbbfpejzhofhs.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im11dnZydG56YmJmcGVqemhvZmhzIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MjE1ODgxMTgsImV4cCI6MjAzNzE2NDExOH0.LNK7P1P0x5AfOWTVOS43YTL-Pvmk3fxXc_9jXbtX7x8',
  );

  runApp(const MyApp());
}

final supabase = Supabase.instance.client;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Мое тестовое приложение'),
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
  String _test = "Ничего";

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
        title: InkWell(
          child: Text(widget.title),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const LoginScreen()),
            );
          },
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              _test,
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const Padding(
              padding: EdgeInsets.only(top: 20),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    setState(() {
                      _test = 'Один';
                    });
                  },
                  child: const Text('1'),
                ),
                const Padding(padding: EdgeInsets.only(left: 10)),
                InkWell(
                  onTap: () {
                    setState(() {
                      _test = 'Два';
                    });
                  },
                  child: const Text('2'),
                ),
                const Padding(padding: EdgeInsets.only(left: 10)),
                InkWell(
                  onTap: () {
                    setState(() {
                      _test = 'Три';
                    });
                  },
                  child: const Text('3'),
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
