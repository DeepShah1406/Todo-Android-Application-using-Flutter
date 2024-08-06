import 'package:flutter/material.dart';
import 'package:todoapp/task.dart';
import 'package:todoapp/readandwrite.dart';

void main() {
  runApp(const MaterialApp(home: ToDoApp(), debugShowCheckedModeBanner: false));
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
          InputDecoration inpdeco = const InputDecoration(labelText: 'Task Title');
          TextField txtf = TextField(
              onChanged: (value) {
                taskTitle = value;
              }, decoration: inpdeco);
          ElevatedButton ebtn1 = ElevatedButton(child: const Text('Cancel'), onPressed: () {
            Navigator.of(ctx).pop();
          });
          ElevatedButton ebtn2 = ElevatedButton(child: const Text('Add'), onPressed: () {
            if (taskTitle.isNotEmpty) {
              addNewTask(taskTitle);
              Navigator.of(ctx).pop();
            }
          });
          AlertDialog altd = AlertDialog(title: txt, content: txtf, actions: [ebtn1, ebtn2]);
          return altd;
        }
    );
  }

  void deleteTask(int index) {
    Task removedTask = tasks[index];
    setState(() {tasks.removeAt(index);});

    listKey.currentState?.removeItem(
        index,
            (BuildContext context, Animation<double> animation) {
          TextStyle txtsty = const TextStyle(decoration: TextDecoration.lineThrough);
          Text txt = Text(removedTask.title, style: txtsty);
          ListTile lt = ListTile(title: txt);
          Card crd = Card(elevation: 4, margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5), child: lt);
          SizeTransition stran = SizeTransition(sizeFactor: animation, child: crd);
          return stran;
        },
        duration: const Duration(milliseconds: 250)
    );

    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${removedTask.title} deleted'), action: SnackBarAction(label: 'UNDO',
            onPressed: () {
              setState(() {
                tasks.insert(index, removedTask);
              });
              listKey.currentState?.insertItem(index);
            }),
          duration: const Duration(seconds: 2),
        ));
    storage.writeTasks(tasks);
  }

  Widget buildTaskItem(BuildContext context, int index) {
    TextStyle txtsyl = TextStyle(decoration: tasks[index].completed ? TextDecoration.lineThrough : null);
    Text txt = Text(tasks[index].title, style: txtsyl);
    Icon icn = Icon(tasks[index].completed ? Icons.check_circle : Icons.radio_button_unchecked, color: tasks[index].completed ? Colors.green : null);
    IconButton icnbtn = IconButton(icon: const Icon(Icons.delete), onPressed: () => deleteTask(index));
    ListTile lt = ListTile(title: txt, leading: icn, trailing: icnbtn, onTap: () {
      setState(() {
        tasks[index].toggleCompleted();
      });
      storage.writeTasks(tasks);
    });
    Card crd = Card(elevation: 4, margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5), child: lt);
    return crd;
  }

  @override
  Widget build(BuildContext context) {
    Text txt = const Text('ToDo App');
    AppBar ab = AppBar(title: txt);
    AnimatedList al = AnimatedList(key: listKey, initialItemCount: tasks.length, itemBuilder: (context, index, animation) {
      return buildTaskItem(context, index);
    });
    Icon icn = const Icon(Icons.add);
    FloatingActionButton fab = FloatingActionButton(onPressed: () => startAddNewTask(context), tooltip: 'Add Task', child: icn);
    Scaffold sf = Scaffold(appBar: ab, body: al, floatingActionButton: fab);
    return sf;
  }
}