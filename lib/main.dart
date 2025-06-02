import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:todo_app/models/task_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final dir = await getApplicationSupportDirectory();
  final isar = await Isar.open(
    [TaskSchema],
    directory: dir.path,
  );

  runApp(MyApp(isar: isar));
}

class MyApp extends StatelessWidget {
  final Isar isar;

  const MyApp({super.key, required this.isar});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'To-Do List',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: TodoPage(isar: isar),
    );
  }
}

class TodoPage extends StatefulWidget {
  final Isar isar;

  const TodoPage({super.key, required this.isar});

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  List<Task> _tasks = [];
  final TextEditingController _inputController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    final tasks = await widget.isar.tasks.where().findAll();
    setState(() {
      _tasks = tasks;
    });
  }

  Future<void> _addTask() async {
    if (_inputController.text.trim().isNotEmpty) {
      final newTask = Task(description: _inputController.text);
      await widget.isar.writeTxn(() async {
        await widget.isar.tasks.put(newTask);
      });
      _inputController.clear();
      await _loadTasks();
    }
  }

  Future<void> _toggleTaskStatus(Task task) async {
    task.isCompleted = !task.isCompleted;
    await widget.isar.writeTxn(() async {
      await widget.isar.tasks.put(task);
    });
    await _loadTasks();
  }

  Future<void> _deleteTask(int id) async {
    await widget.isar.writeTxn(() async {
      await widget.isar.tasks.delete(id);
    });
    await _loadTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('To-Do List'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              spacing: 8,
              children: [
                Expanded(
                  child: TextField(
                    controller: _inputController,
                    decoration: const InputDecoration(
                      labelText: 'Add a new task',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (value) => _addTask(),
                  ),
                ),
                ElevatedButton(
                  onPressed: _addTask,
                  child: const Text('Add'),
                ),
              ],
            ),
          ),
          Expanded(
              child: _tasks.isEmpty
                  ? const Center(
                      child: Text('No tasks available, but you can add some!'),
                    )
                  : ListView.builder(
                      itemCount: _tasks.length,
                      itemBuilder: (context, index) {
                        final task = _tasks[index];
                        return Card(
                          margin: EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          child: ListTile(
                            title: Text(
                              task.description,
                              style: TextStyle(
                                decoration: task.isCompleted ?
                                  TextDecoration.lineThrough : null,
                                color: task.isCompleted ? Colors.grey : null,
                              ),
                            ),
                            leading: Checkbox(
                                value: task.isCompleted,
                                onChanged: (bool? value) {
                                  _toggleTaskStatus(task);
                                }),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _deleteTask(task.id),
                            ),
                          ),
                        );
                      },

                    )
              )
        ],
      )
    );
  }
}
