import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'package:todoapp/task.dart';

class Storage {
  Future<String> get localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get localFile async {
    final path = await localPath;
    return File('$path/tasks.json');
  }

  Future<List<Task>> readTasks() async {
    try {
      final file = await localFile;
      // Read the file
      String contents = await file.readAsString();
      List<dynamic> jsonData = jsonDecode(contents);
      return jsonData.map((item) => Task.fromJson(item)).toList();
    } catch (e) {
      // If encountering an error, return an empty list
      return [];
    }
  }

  Future<File> writeTasks(List<Task> tasks) async {
    final file = await localFile;
    // Convert tasks to json and write to file
    String json = jsonEncode(tasks.map((task) => task.toJson()).toList());
    return file.writeAsString(json);
  }
}