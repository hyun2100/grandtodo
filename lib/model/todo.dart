class Todo {
  int? id;
  String date;
  String time;
  String title;
  String content;
  bool isCompleted;
  String repeatType;
  List<bool>? repeatWeekdays;
  int? repeatMonthDay;

  Todo({
    this.id,
    required this.date,
    required this.time,
    required this.title,
    required this.content,
    this.isCompleted = false,
    this.repeatType = '반복 없음',
    this.repeatWeekdays,
    this.repeatMonthDay,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date,
      'time': time,
      'title': title,
      'content': content,
      'isCompleted': isCompleted ? 1 : 0,
      'repeatType': repeatType,
      'repeatWeekdays': repeatWeekdays != null ? repeatWeekdays!.join(',') : null,
      'repeatMonthDay': repeatMonthDay,
    };
  }

  factory Todo.fromMap(Map<String, dynamic> map) {
    return Todo(
      id: map['id'],
      date: map['date'],
      time: map['time'],
      title: map['title'],
      content: map['content'],
      isCompleted: map['isCompleted'] == 1,
      repeatType: map['repeatType'] ?? '반복 없음',
      repeatWeekdays: map['repeatWeekdays'] != null 
          ? map['repeatWeekdays'].split(',').map((e) => e == 'true').toList()
          : null,
      repeatMonthDay: map['repeatMonthDay'],
    );
  }
}