import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:todo_app/pages/add_edit_task_page.dart';

import '../models/task_model.dart';

class Homepage extends StatefulWidget {
  final Isar isar;

  const Homepage({super.key, required this.isar});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  List<Task> _tasks = [];

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
        floatingActionButton: FloatingActionButton(
            shape: const CircleBorder(),
            child: const Icon(Icons.add),
            onPressed: () => {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) =>
                    AddEditTaskPage(isar: widget.isar, isEditing: false))
              ).then((result) {
                if (result == true) {
                  _loadTasks();
                }
              })
            }),
        body: Column(
          children: [
            Image.asset("images/logo.png"),
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
                        trailing:
                          SizedBox(
                            width: 100,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit, color: Colors.blueGrey),
                                  onPressed: () => {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (_) =>
                                          AddEditTaskPage(
                                              isar: widget.isar,
                                              isEditing: true,
                                              task: task))
                                    ).then((result) {
                                      if (result == true) {
                                        _loadTasks();
                                      }
                                    })
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  onPressed: () => _deleteTask(task.id),
                                ),
                              ],
                            ),
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
