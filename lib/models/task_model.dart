import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
part 'task_model.g.dart';

@HiveType(typeId: 1)
class Task extends HiveObject {
  @HiveField(0)
  final String Taskid;

  @HiveField(1)
  String Taskname;

  @HiveField(2)
  final DateTime cretedAt;

  @HiveField(3)
  bool isCompleted;

  Task({
    required this.Taskid,
    required this.Taskname,
    required this.cretedAt,
    required this.isCompleted,
  });

  factory Task.create({required String Taskname, required DateTime cretedAt}) {
    return Task(
        Taskid: const Uuid().v1(),
        Taskname: Taskname,
        cretedAt: cretedAt,
        isCompleted: false);
  }
}
