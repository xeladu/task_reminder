import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:timezone/timezone.dart' as tz;

@immutable
class Task extends Equatable {
  const Task(
      {required this.id,
      required this.title,
      required this.description,
      required this.created,
      required this.category,
      this.completed,
      this.template = false});

  final int id;
  final String title;
  final String description;
  final tz.TZDateTime created;
  final String category;
  final tz.TZDateTime? completed;
  final bool template;

  Task.empty()
      : this(
            id: 0,
            title: "",
            description: "",
            created: tz.TZDateTime.now(tz.local),
            category: "",
            completed: null,
            template: false);

  factory Task.fromJson(Map<String, dynamic> json) => Task(
      id: json.containsKey("id") ? json["id"] : 0,
      title: json.containsKey("title") ? json["title"] : "",
      description: json.containsKey("description") ? json["description"] : "",
      category: json.containsKey("category") ? json["category"] : "",
      created: json.containsKey("created")
          ? tz.TZDateTime.fromMillisecondsSinceEpoch(tz.local, json["created"])
          : tz.TZDateTime.fromMillisecondsSinceEpoch(tz.local, 1),
      completed: json.containsKey("completed") && json["completed"] > 0
          ? tz.TZDateTime.fromMillisecondsSinceEpoch(
              tz.local, json["completed"])
          : null,
      template:
          json.containsKey("template") ? json["template"] as bool : false);

  Task copyWith({int? newId, tz.TZDateTime? completedDate, bool? isTemplate}) =>
      Task(
          category: category,
          id: newId ?? id,
          created: created,
          description: description,
          title: title,
          completed: completedDate,
          template: isTemplate ?? template);

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "description": description,
        "created": created.millisecondsSinceEpoch,
        "category": category,
        "completed": completed == null ? 0 : completed!.millisecondsSinceEpoch,
        "template": template
      };

  @override
  List<Object?> get props =>
      [id, title, description, created, completed, category, template];

  @override
  String toString() {
    return "$title, $id, $category, $completed";
  }

  bool isValid() {
    return title.isNotEmpty;
  }
}
