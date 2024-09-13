import 'package:flutter/foundation.dart';
import '../data/database_helper.dart';
import '../model/todo.dart';
import 'package:intl/intl.dart';

class TodoViewModel extends ChangeNotifier {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  List<Todo> _todos = [];
  List<Todo> _cachedTodayTodos = [];
  DateTime _lastFetchTime = DateTime(0);

  List<Todo> get todos => _todos;

  Future<void> loadTodos() async {
    final todoMaps = await _dbHelper.getTodos();
    _todos = todoMaps.map((map) => Todo.fromMap(map)).toList();
    notifyListeners();
  }

  Future<void> addTodo(Todo todo) async {
    final id = await _dbHelper.insertTodo(todo.toMap());
    todo.id = id;
    _todos.add(todo);
    _invalidateCache();
    notifyListeners();
  }

  Future<void> updateTodo(Todo todo) async {
    await _dbHelper.updateTodo(todo.toMap());
    final index = _todos.indexWhere((t) => t.id == todo.id);
    if (index != -1) {
      _todos[index] = todo;
      _invalidateCache();
      notifyListeners();
    }
  }

  Future<void> deleteTodo(int id) async {
    await _dbHelper.deleteTodo(id);
    _todos.removeWhere((todo) => todo.id == id);
    _invalidateCache();
    notifyListeners();
  }

 Todo? getTodoById(int id) {
  try {
    return _todos.firstWhere((todo) => todo.id == id);
  } catch (e) {
    return null;
  }
}

  Future<List<Todo>> getTodayTodos() async {
    final now = DateTime.now();
    if (now.difference(_lastFetchTime).inMinutes < 5 && _cachedTodayTodos.isNotEmpty) {
      return _cachedTodayTodos;
    }
    
    final today = DateFormat('yyyy-MM-dd').format(now);
    _cachedTodayTodos = _todos.where((todo) => todo.date == today).toList();
    _lastFetchTime = now;
    return _cachedTodayTodos;
  }

  Future<void> toggleTodoCompletion(Todo todo) async {
    todo.isCompleted = !todo.isCompleted;
    await updateTodo(todo);
  }

  Future<List<Todo>> searchTodos(String query) async {
    return _todos.where((todo) =>
        todo.title.toLowerCase().contains(query.toLowerCase()) ||
        todo.content.toLowerCase().contains(query.toLowerCase())
    ).toList();
  }

  Future<List<Todo>> getTodosByDate(String date) async {
    return _todos.where((todo) => todo.date == date).toList();
  }

  void _invalidateCache() {
    _cachedTodayTodos = [];
    _lastFetchTime = DateTime(0);
  }
}