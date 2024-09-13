import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../vm/todo_vm.dart';
import '../model/todo.dart';
import 'todo_edit_page.dart';

class TodoDetailPage extends StatelessWidget {
  final Todo todo;

  const TodoDetailPage({super.key, required this.todo});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('할 일 상세'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TodoEditPage(todo: todo),
                ),
              );
            },
          ),
          IconButton(
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
                          Provider.of<TodoViewModel>(context, listen: false).deleteTodo(todo.id!);
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('날짜: ${todo.date}', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            Text('시간: ${todo.time}', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            Text('제목: ${todo.title}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            const Text('내용:', style: TextStyle(fontSize: 18)),
            Text(todo.content, style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}