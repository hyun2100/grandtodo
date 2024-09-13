import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../vm/todo_vm.dart';
import '../model/todo.dart';

class TodoEditPage extends StatefulWidget {
  final Todo todo;

  const TodoEditPage({super.key, required this.todo});

  @override
  _TodoEditPageState createState() => _TodoEditPageState();
}

class _TodoEditPageState extends State<TodoEditPage> {
  late TextEditingController _dateController;
  late TextEditingController _timeController;
  late TextEditingController _titleController;
  late TextEditingController _contentController;

  @override
  void initState() {
    super.initState();
    _dateController = TextEditingController(text: widget.todo.date);
    _timeController = TextEditingController(text: widget.todo.time);
    _titleController = TextEditingController(text: widget.todo.title);
    _contentController = TextEditingController(text: widget.todo.content);
  }

  @override
  void dispose() {
    _dateController.dispose();
    _timeController.dispose();
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateFormat('yyyy-MM-dd').parse(_dateController.text),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        _dateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  void _updateTodo() {
    final updatedTodo = Todo(
      id: widget.todo.id,
      date: _dateController.text,
      time: _timeController.text,
      title: _titleController.text,
      content: _contentController.text,
    );
    Provider.of<TodoViewModel>(context, listen: false).updateTodo(updatedTodo);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('할 일 수정'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: () => _selectDate(context),
              child: AbsorbPointer(
                child: TextFormField(
                  controller: _dateController,
                  decoration: const InputDecoration(
                    labelText: '날짜',
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                ),
              ),
            ),
            TextFormField(
              controller: _timeController,
              decoration: const InputDecoration(labelText: '시간'),
            ),
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: '제목'),
            ),
            TextFormField(
              controller: _contentController,
              decoration: const InputDecoration(labelText: '내용'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _updateTodo,
              child: const Text('수정'),
            ),
          ],
        ),
      ),
    );
  }
}