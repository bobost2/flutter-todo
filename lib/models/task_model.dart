import 'package:isar/isar.dart';

part 'task_model.g.dart';

@Collection()
class Task {
  Id id = Isar.autoIncrement;
  late String description;
  bool isCompleted;

  Task({
    required this.description,
    this.isCompleted = false,
  });
}
