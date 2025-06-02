import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:todo_app/models/task_model.dart';

class AddEditTaskPage extends StatefulWidget {
  final Isar isar;
  final bool isEditing;

  final Task? task;
  const AddEditTaskPage({super.key, required this.isar,
    required this.isEditing, this.task});

  @override
  State<AddEditTaskPage> createState() => _AddEditTaskPageState();
}

class _AddEditTaskPageState extends State<AddEditTaskPage> {
  final TextEditingController _inputController = TextEditingController();

  @override
  void initState() {
    super.initState();

    if (widget.isEditing && widget.task != null) {
      _inputController.text = widget.task!.description;
    }
  }

  Future<void> _addEditTask() async {
    if (_inputController.text.trim().isNotEmpty) {
      if (widget.isEditing && widget.task != null) {
        final updatedTask = widget.task!..description = _inputController.text;
        await widget.isar.writeTxn(() async {
          await widget.isar.tasks.put(updatedTask);
        });
      } else {
        final newTask = Task(description: _inputController.text);
        await widget.isar.writeTxn(() async {
          await widget.isar.tasks.put(newTask);
        });
      }

      _inputController.clear();

      if (mounted) {
        Navigator.pop(context, true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEditing ? 'Edit Task' : 'Add Task'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 8,
            children: [
              TextField(
                controller: _inputController,
                decoration: const InputDecoration(
                  labelText: 'Task description',
                  border: OutlineInputBorder(),
                ),
                onSubmitted: (value) => _addEditTask(),
              ),
              ElevatedButton(
                onPressed: _addEditTask,
                child: Text(widget.isEditing ? 'Replace' : 'Add'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
