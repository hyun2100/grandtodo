import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../vm/todo_vm.dart';
import '../model/todo.dart';

class TodayPage extends StatefulWidget {
  const TodayPage({super.key});

  @override
  _TodayPageState createState() => _TodayPageState();
}

class _TodayPageState extends State<TodayPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TodoViewModel>(context, listen: false).loadTodos();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color.fromARGB(255, 144, 238, 144),
        title: const Center(
          child: Text('오늘의 할일', style: TextStyle(fontSize: 30)),
        ),
      ),
      body: Consumer<TodoViewModel>(
        builder: (context, todoVM, child) {
          return FutureBuilder<List<Todo>>(
            future: todoVM.getTodayTodos(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('오늘의 할 일이 없습니다.'));
              } else {
                final todayTodos = snapshot.data!;
                return ListView.builder(
                  itemCount: todayTodos.length,
                  itemBuilder: (context, index) {
                    final todo = todayTodos[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                      child: ListTile(
                        leading: Text(todo.time, style: const TextStyle(color: Colors.grey)),
                        title: Text(todo.title, style: const TextStyle(fontSize: 20)),
                        subtitle: Text(todo.content),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('할 일 삭제'),
                                  content: const Text('이 할 일을 삭제하시겠습니까?'),
                                  actions: <Widget>[
                                    TextButton(
                                      child: const Text('취소'),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    TextButton(
                                      child: const Text('삭제'),
                                      onPressed: () {
                                        todoVM.deleteTodo(todo.id!);
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                      ),
                    );
                  },
                );
              }
            },
          );
        },
      ),
      bottomNavigationBar: ElevatedButton(
        onPressed: () => Navigator.pop(context),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 20),
          minimumSize: const Size(double.infinity, 70),
          backgroundColor: const Color.fromARGB(255, 144, 238, 144),
        ),
        child: Text('뒤로가기', style: TextStyle(fontSize: 40)),
      ),
    );
  }
}