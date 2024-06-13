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
      home: const MyHomePage(title: 'BÀI TẬP LỚN'),
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
    return SafeArea(
      child: Scaffold(
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

              double nhietDo = data['NhietDo'] ?? 0;
              int nongDoKhiGa = data['NongDoKhiGa'] ?? 0;

              // Safe parsing of LED states
              bool led1State = data['Led1'] is bool ? data['Led1'] : false;
              bool led2State = data['Led2'] is bool ? data['Led2'] : false;
              bool led3State = data['Led3'] is bool ? data['Led3'] : false;

              return Container(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      'Nhiệt độ: $nhietDo°C',
                      style: const TextStyle(fontSize: 24),
                    ),
                    Slider(
                      value: nongDoKhiGa.toDouble(),
                      min: 0,
                      max: 6000,
                      divisions: 600,
                      label: '$nongDoKhiGa',
                      onChanged: (double value) {},
                    ),
                    Expanded(
                      child: GridView.count(
                        crossAxisCount: 2,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                        padding: const EdgeInsets.all(16.0),
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                fixedSize: const Size(100, 100),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                backgroundColor:
                                    led1State ? Colors.red : Colors.green),
                            onPressed: () => _toggleLed('Led1', led1State),
                            child: Text(
                              led1State ? 'OFF' : 'ON',
                              style: const TextStyle(
                                fontSize: 28, // Kích thước chữ
                                fontWeight: FontWeight.bold, // Độ đậm
                                color: Colors.white, // Màu chữ
                                // Khoảng cách giữa các chữ
                              ),
                            ),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              fixedSize: const Size(100, 100),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              backgroundColor:
                                  led2State ? Colors.red : Colors.green,
                            ),
                            onPressed: () => _toggleLed('Led2', led2State),
                            child: Text(
                              led2State ? 'OFF' : 'ON',
                              style: const TextStyle(
                                fontSize: 28, // Kích thước chữ
                                fontWeight: FontWeight.bold, // Độ đậm
                                color: Colors.white, // Màu chữ
                                // Khoảng cách giữa các chữ
                              ),
                            ),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              fixedSize: const Size(100, 100),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              backgroundColor:
                                  led3State ? Colors.red : Colors.green,
                            ),
                            onPressed: () => _toggleLed('Led3', led3State),
                            child: Text(
                              led3State ? 'OFF' : 'ON',
                              style: const TextStyle(
                                fontSize: 28, // Kích thước chữ
                                fontWeight: FontWeight.bold, // Độ đậm
                                color: Colors.white, // Màu chữ
                                // Khoảng cách giữa các chữ
                              ),
                            ),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              fixedSize: const Size(100, 100),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              backgroundColor: Colors.blueGrey,
                            ),
                            onPressed: () {},
                            child: const Text('Reserved'),
                          ),
                        ],
                      ),
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
      ),
    );
  }
}
