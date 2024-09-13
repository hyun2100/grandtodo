import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../vm/todo_vm.dart';
import '../model/todo.dart';
import 'todo_edit_page.dart';

class TodoPage extends StatefulWidget {
  @override
  _TodoPageState createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  TextEditingController _dateController = TextEditingController();
  TextEditingController _titleController = TextEditingController();
  TextEditingController _contentController = TextEditingController();
  String _selectedTime = '00:00';
  String _repeatType = '반복 없음';
  List<bool> _selectedWeekdays = List.generate(7, (_) => false);
  int _selectedMonthDay = 1;

  @override
  void initState() {
    super.initState();
    _dateController.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
    Provider.of<TodoViewModel>(context, listen: false).loadTodos();
  }

  List<String> _generateTimeOptions() {
    List<String> times = [];
    for (int hour = 0; hour < 24; hour++) {
      for (int minute = 0; minute < 60; minute += 30) {
        times.add(
            '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}');
      }
    }
    return times;
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

  void _addTodo() {
    final todo = Todo(
      date: _dateController.text,
      time: _selectedTime,
      title: _titleController.text,
      content: _contentController.text,
      repeatType: _repeatType,
      repeatWeekdays: _repeatType == '매주' ? _selectedWeekdays : null,
      repeatMonthDay: _repeatType == '매월' ? _selectedMonthDay : null,
    );
    Provider.of<TodoViewModel>(context, listen: false).addTodo(todo);
    _clearInputs();
  }

  void _clearInputs() {
    _titleController.clear();
    _contentController.clear();
    _selectedTime = '00:00';
    _repeatType = '반복 없음';
    _selectedWeekdays = List.generate(7, (_) => false);
    _selectedMonthDay = 1;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 144, 238, 144),
        title: Text('할일 관리'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      Expanded(
                        flex: 2,
                        child: _buildSideButton(
                          icon: Icons.list,
                          label: '할일수정',
                          onPressed: () {},
                          color: Color.fromARGB(255, 144, 238, 144),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: _buildSideButton(
                          icon: Icons.phone,
                          label: '순이네',
                          onPressed: () {},
                          color: Color.fromARGB(255, 227, 236, 227),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: _buildSideButton(
                          icon: Icons.support_agent,
                          label: '복지사',
                          onPressed: () {},
                          color: Color.fromARGB(255, 227, 236, 227),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () => _selectDate(context),
                          child: AbsorbPointer(
                            child: TextFormField(
                              controller: _dateController,
                              style: TextStyle(fontSize: 20),
                              decoration: InputDecoration(
                                labelText: '날짜',
                                suffixIcon: Icon(Icons.calendar_today),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 8),
                        DropdownButton<String>(
                          value: _selectedTime,
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedTime = newValue!;
                            });
                          },
                          items: _generateTimeOptions()
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value, style: TextStyle(fontSize: 20)),
                            );
                          }).toList(),
                        ),
                        SizedBox(height: 8),
                        TextFormField(
                          controller: _titleController,
                          style: TextStyle(fontSize: 20),
                          decoration: InputDecoration(
                            labelText: '할일 제목',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        SizedBox(height: 8),
                        Expanded(
                          child: TextFormField(
                            controller: _contentController,
                            style: TextStyle(fontSize: 20),
                            decoration: InputDecoration(
                              labelText: '할일 내용',
                              border: OutlineInputBorder(),
                            ),
                            maxLines: null,
                            expands: true,
                          ),
                        ),
                        SizedBox(height: 8),
                        _buildRepeatSection(),
                        SizedBox(height: 8),
                        ElevatedButton(
                          onPressed: _addTodo,
                          child: Text('추가하기', style: TextStyle(fontSize: 20)),
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Consumer<TodoViewModel>(
              builder: (context, todoVM, child) {
                return FutureBuilder<List<Todo>>(
                  future: todoVM.getTodosByDate(_dateController.text),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(child: Text('No todos for this date.'));
                    } else {
                      final todos = snapshot.data!;
                      return ListView.builder(
                        itemCount: todos.length,
                        itemBuilder: (context, index) {
                          final todo = todos[index];
                          return ListTile(
                            title: Text('${todo.time} - ${todo.title}'),
                            subtitle: Text(todo.content),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.edit),
                                  onPressed: () async {
                                    final updatedTodo = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => TodoEditPage(todo: todo),
                                      ),
                                    );
                                    if (updatedTodo != null) {
                                      todoVM.updateTodo(updatedTodo);
                                    }
                                  },
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: () {
                                    todoVM.deleteTodo(todo.id!);
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    }
                  },
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        height: 50,
        child: ElevatedButton(
          onPressed: () => Navigator.pop(context),
          child: Text('뒤로가기', style: TextStyle(fontSize: 20)),
          style: ElevatedButton.styleFrom(
            backgroundColor: Color.fromARGB(255, 144, 238, 144),
          ),
        ),
      ),
    );
  }

  Widget _buildRepeatSection() {
    return Column(
      children: [
        
        Row(
          children: [
            Radio<String>(
              value: '반복 없음',
              groupValue: _repeatType,
              onChanged: (value) => setState(() => _repeatType = value!),
            ),
            Text('반복 없음'),
            Radio<String>(
              value: '매일',
              groupValue: _repeatType,
              onChanged: (value) => setState(() => _repeatType = value!),
            ),
            Text('매일'),
            Radio<String>(
              value: '매주',
              groupValue: _repeatType,
              onChanged: (value) => setState(() => _repeatType = value!),
            ),
            Text('매주'),
            Radio<String>(
              value: '매월',
              groupValue: _repeatType,
              onChanged: (value) => setState(() => _repeatType = value!),
            ),
            Text('매월'),
          ],
        ),
        if (_repeatType == '매주')
          _buildWeekdaySelector(),
        if (_repeatType == '매월')
          _buildMonthDaySelector(),
      ],
    );
  }

  Widget _buildWeekdaySelector() {
    return Wrap(
      spacing: 8.0,
      children: [
        for (int i = 0; i < 7; i++)
          ElevatedButton(
            onPressed: () => setState(() => _selectedWeekdays[i] = !_selectedWeekdays[i]),
            style: ElevatedButton.styleFrom(
              backgroundColor: _selectedWeekdays[i] ? Colors.blue : Colors.grey,
            ),
            child: Text(['월', '화', '수', '목', '금', '토', '일'][i]),
          ),
      ],
    );
  }

  Widget _buildMonthDaySelector() {
    return DropdownButton<int>(
      value: _selectedMonthDay,
      items: List.generate(31, (index) => index + 1)
          .map((day) => DropdownMenuItem(value: day, child: Text('$day일')))
          .toList(),
      onChanged: (value) => setState(() => _selectedMonthDay = value!),
    );
  }

  Widget _buildSideButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding: EdgeInsets.all(8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 32),
            SizedBox(height: 4),
            Text(label, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}