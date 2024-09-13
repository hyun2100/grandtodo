import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'view/home.dart';
import 'vm/todo_vm.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => TodoViewModel(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '100 App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const Home(),
    );
  }
}