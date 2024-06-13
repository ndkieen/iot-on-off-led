import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_database/firebase_database.dart';

FirebaseDatabase database = FirebaseDatabase.instance;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

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
      home: const MyHomePage(title: 'BÀI TẬP LỚN '),
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
  final DatabaseReference _databaseRef = FirebaseDatabase.instance.ref();
  void _toggleLed(String ledKey, bool currentState) {
    _databaseRef.child(ledKey).set(!currentState);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BÀI TẬP LỚN'),
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: _databaseRef.onValue,
        builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
          if (snapshot.hasData && snapshot.data!.snapshot.value != null) {
            Map<dynamic, dynamic> data =
                snapshot.data!.snapshot.value as Map<dynamic, dynamic>;

            int nhietDo = data['NhietDo'] ?? 0;
            int nongDoKhiGa = data['NongDoKhiGa'] ?? 0;

            // Safe parsing of LED states
            bool led1State = data['Led1'] is bool ? data['Led1'] : false;
            bool led2State = data['Led2'] is bool ? data['Led2'] : false;
            bool led3State = data['Led3'] is bool ? data['Led3'] : false;

            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Nhiệt độ: $nhietDo°C',
                    style: const TextStyle(fontSize: 24),
                  ),
                  Text(
                    'Nồng độ khí ga: $nongDoKhiGa',
                    style: const TextStyle(fontSize: 24),
                  ),
                  ElevatedButton(
                    onPressed: () => _toggleLed('Led1', led1State),
                    child: Text(led1State ? 'Tắt LED 1' : 'Bật LED 1'),
                  ),
                  ElevatedButton(
                    onPressed: () => _toggleLed('Led2', led2State),
                    child: Text(led2State ? 'Tắt LED 2' : 'Bật LED 2'),
                  ),
                  ElevatedButton(
                    onPressed: () => _toggleLed('Led3', led3State),
                    child: Text(led3State ? 'Tắt LED 3' : 'Bật LED 3'),
                  ),
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Lỗi: ${snapshot.error}'));
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
