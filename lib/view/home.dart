import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'memo_page.dart';
import 'todo_page.dart';
import 'today_page.dart';
import 'package:provider/provider.dart';
import '../vm/todo_vm.dart';
import '../model/todo.dart';

class Home extends StatefulWidget {
  const Home({super. key});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String _currentTime = '';
  String _currentDate = '';
  String _today = '';

  @override
  void initState() {
    super.initState();
    _updateTime();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TodoViewModel>(context, listen: false).loadTodos();
    });
  }

  void _updateTime() {
    final now = DateTime.now();
    final timeFormat = DateFormat('HH:mm');
    final dateFormat = DateFormat('yyyy년 MM월 dd일');
    final todayFormat = DateFormat('yyyy-MM-dd');
    setState(() {
      _currentTime = timeFormat.format(now);
      _currentDate = dateFormat.format(now);
      _today = todayFormat.format(now);
    });
    Timer(const Duration(seconds: 1), _updateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 144, 238, 144),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(_currentTime, style: const TextStyle(fontSize: 35)),
            Text(_currentDate, style: const TextStyle(fontSize: 35)),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => MemoPage()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 200, 255, 200),
                        padding: const EdgeInsets.all(20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.note, size: 58),
                          SizedBox(height: 8),
                          Text('메모', style: TextStyle(fontSize: 50)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => TodoPage()),
                        );
                        Provider.of<TodoViewModel>(context, listen: false).loadTodos();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 200, 255, 200),
                        padding: const EdgeInsets.all(20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.check_box, size: 58),
                          SizedBox(height: 8),
                          Text('할일', style: TextStyle(fontSize: 50)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Column(
                      children: [
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: ElevatedButton(
                              onPressed: () {
                                // 순이네 전화 기능
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color.fromARGB(255, 144, 238, 144),
                                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.phone, size: 48),
                                  SizedBox(height: 8),
                                  Text('순이네', style: TextStyle(fontSize: 20)),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: ElevatedButton(
                              onPressed: () {
                                // 복지사 전화 기능
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color.fromARGB(255, 255, 204, 204),
                                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.phone, size: 48),
                                  SizedBox(height: 8),
                                  Text('복지사', style: TextStyle(fontSize: 20)),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    flex: 2,
                    child: Consumer<TodoViewModel>(
                      builder: (context, todoVM, child) {
                        return FutureBuilder<List<Todo>>(
                          future: todoVM.getTodayTodos(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const Center(child: CircularProgressIndicator());
                            } else if (snapshot.hasError) {
                              return Center(child: Text('Error: ${snapshot.error}'));
                            } else {
                              final todayTodos = snapshot.data ?? [];
                              return ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => TodayPage(),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color.fromARGB(255, 255, 228, 196),
                                  padding: const EdgeInsets.all(10),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        alignment: Alignment.center,
                                        child: Text('오늘의 할일', style: TextStyle(fontSize: 50)),
                                      ),
                                    ),
                                    Divider(color: Colors.white, height: 1),
                                    Expanded(
                                      flex: 5,
                                      child: ListView.builder(
                                        itemCount: todayTodos.length,
                                        itemBuilder: (context, index) {
                                          final todo = todayTodos[index];
                                          return Card(
                                            margin: EdgeInsets.symmetric(vertical: 4.0),
                                            child: ListTile(
                                              leading: Text(todo.time, style: TextStyle(color: Colors.grey)),
                                              title: Text(todo.title, style: TextStyle(fontSize: 20)),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}