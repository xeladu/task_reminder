import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:task_reminder/database/models/task.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

void main() {
  const String json1 = """
    { 
        "id": 1,
        "position": 1,
        "title": "test title 1",
        "description": "test description 1",
        "created": 1645383600000,
        "completed": null,
        "category": "test category 1"
    }
    """;

  const String json2 = """
    {
        "id": 2,
        "title": "test title 2",
        "description": "test description 2",
        "created": 1645383600000,
        "completed": null,
        "category": "test category 2"
    }
    """;

  setUpAll(() async {
    WidgetsFlutterBinding.ensureInitialized();
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation("Europe/Berlin"));

    return Future.value();
  });

  test("Verify object deserialization 1", () {
    var task = Task.fromJson(jsonDecode(json1));

    expect(1, task.id);
    expect("test title 1", task.title);
    expect("test description 1", task.description);
    expect("test category 1", task.category);
    expect(tz.TZDateTime.local(2022, 02, 20, 20, 0, 0), task.created);
  });

  test("Verify object deserialization 2", () {
    var task = Task.fromJson(jsonDecode(json2));

    expect(2, task.id);
    expect("test title 2", task.title);
    expect("test description 2", task.description);
    expect("test category 2", task.category);
    expect(tz.TZDateTime.local(2022, 02, 20, 20, 0, 0), task.created);
  });

  test("Verify serialization and deserialization", () {
    var date = tz.TZDateTime.local(2022, 4, 20, 16, 34, 58, 0, 0);

    var expected = Task(
        created: date,
        id: 1,
        title: "title",
        category: "category",
        description: "description",
        completed: null);

    var actual = Task.fromJson(jsonDecode(jsonEncode(expected.toJson())));

    expect(actual, expected);
  });
}
