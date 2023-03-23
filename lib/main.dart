import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_todoapp/data/local_storage.dart';
import 'package:flutter_todoapp/models/task_model.dart';
import 'package:flutter_todoapp/pages/home_page.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/adapters.dart';

final locator = GetIt.instance;
void setup() {
  locator.registerSingleton<LocalStorage>(HiveLocalStorage());
}

Future<void> setupHive() async {
  await Hive.initFlutter();
  Hive.registerAdapter(TaskAdapter());
  var taskBox = await Hive.openBox<Task>('tasks');

  for (var element in taskBox.values) {
    if (element.cretedAt.day != DateTime.now().day) {
      taskBox.delete(element.Taskid);
    }
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  await setupHive();
  setup();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        appBarTheme: const AppBarTheme(
            elevation: 0,
            backgroundColor: Colors.white,
            iconTheme: IconThemeData(color: Colors.black)),
      ),
      home: const HomePage(),
    );
  }
}
