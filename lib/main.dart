import 'package:flutter/material.dart';
import 'package:todoapp/task.dart';
import 'package:todoapp/readandwrite.dart';

void main() {
  runApp(const MaterialApp(
    home: ToDoApp(),
  ));
}

class ToDoApp extends StatefulWidget {
  const ToDoApp({super.key});

  @override
  ToDoAppState createState() => ToDoAppState();
}

class ToDoAppState extends State<ToDoApp> {
  final List<Task> tasks = [];
  final Storage storage = Storage();
  final GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();

  @override
  void initState() {
    super.initState();
    storage.readTasks().then((taskList) {
      setState(() {
        tasks.addAll(taskList);
      });
    });
  }

  void addNewTask(String title) {
    final newTask = Task(
      title: title,
      id: DateTime.now().toString(),
    );

    setState(() {
      tasks.add(newTask);
    });
    listKey.currentState?.insertItem(tasks.length - 1);
    storage.writeTasks(tasks);
  }

  void startAddNewTask(BuildContext context) {
    String taskTitle = '';

    showDialog(
        context: context,
        builder: (ctx) {

          Text txt = const Text('Add New Task');
          InputDecoration id = const InputDecoration(labelText: 'Task Title');
          TextField tf = TextField(onChanged: (value) {
            taskTitle = value;
          }, decoration: id);
          Text txt1 = const Text('Cancel');
          ElevatedButton elebtn1 = ElevatedButton(child: txt1, onPressed: () {
            Navigator.of(ctx).pop();
          });
          Text txt2 = const Text('Add');
          ElevatedButton elebtn2 = ElevatedButton(child: txt2, onPressed: () {
            if (taskTitle.isNotEmpty) {
              addNewTask(taskTitle);
              Navigator.of(ctx).pop();
            }
          });
          AlertDialog ad = AlertDialog(title: txt, content: tf, actions: [elebtn1, elebtn2]);
          MaterialApp m = MaterialApp(home: ad, debugShowCheckedModeBanner: false);
          return m;
        });
  }

  void deleteTask(int index) {
    Task removedTask = tasks[index];

    setState(() {
      tasks.removeAt(index);
    });

    listKey.currentState?.removeItem(
      index,
          (BuildContext context, Animation<double> animation) {

        TextStyle txtst = const TextStyle(decoration: TextDecoration.lineThrough);
        Text txt = Text(removedTask.title, style: txtst);
        Icon icn = const Icon(Icons.check_circle, color: Colors.green);
        ListTile lt1 = ListTile(title: txt, leading: icn);
        Card crd = Card(elevation: 4, margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5), child: lt1);
        SizeTransition st = SizeTransition(sizeFactor: animation, child: crd);
        MaterialApp m = MaterialApp(home: st, debugShowCheckedModeBanner: false);
        return m;
      },
      duration: const Duration(milliseconds: 250),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${removedTask.title} deleted'), action: SnackBarAction(label: 'UNDO', onPressed: () {
        setState(() {
          tasks.insert(index, removedTask);
        });
        listKey.currentState?.insertItem(index);
      },
      ),
        duration: const Duration(seconds: 2),
      ),
    );

    storage.writeTasks(tasks);
  }

  Widget buildTaskItem(BuildContext context, int index) {

    TextStyle txtst1 = TextStyle(decoration: tasks[index].completed ? TextDecoration.lineThrough : null);
    Text txt2 = Text(tasks[index].title, style: txtst1);
    Icon icn = Icon(tasks[index].completed ? Icons.check_circle : Icons.radio_button_unchecked, color: tasks[index].completed ? Colors.green : null);
    IconButton icnbtn = IconButton(icon: const Icon(Icons.delete), onPressed: () => deleteTask(index));
    ListTile lt = ListTile(title: txt2, leading: icn, trailing: icnbtn, onTap: () {
      setState(() {
        tasks[index].toggleCompleted();
      });
      storage.writeTasks(tasks);
    },);

    Card crd = Card(elevation: 4, margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5), child: lt);
    MaterialApp m = MaterialApp(home: crd, debugShowCheckedModeBanner: false);
    return m;
  }

  @override
  Widget build(BuildContext context) {

    Text txt1 = const Text('ToDo App');
    AppBar ab = AppBar(title: txt1);
    AnimatedList al = AnimatedList(key: listKey, initialItemCount: tasks.length, itemBuilder: (context, index, animation) {
      return buildTaskItem(context, index);
    });
    FloatingActionButton fab1 = FloatingActionButton(onPressed: () => startAddNewTask(context), tooltip: 'Add Task', child: const Icon(Icons.add));
    Scaffold sf = Scaffold(appBar: ab, body: al, floatingActionButton: fab1);
    MaterialApp m = MaterialApp(home: sf, debugShowCheckedModeBanner: false);
    return m;
  }
}
