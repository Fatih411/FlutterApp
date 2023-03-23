// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_todoapp/Constants/style.dart';
import 'package:flutter_todoapp/data/local_storage.dart';
import 'package:flutter_todoapp/main.dart';
import 'package:flutter_todoapp/models/task_model.dart';
import 'package:intl/intl.dart';

class TaskItem extends StatefulWidget {
  final Task task;
  const TaskItem({
    Key? key,
    required this.task,
  }) : super(key: key);

  @override
  State<TaskItem> createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> {
  TextEditingController _taskNameController = TextEditingController();
  late LocalStorage _localStorage;
  @override
  void initState() {
    super.initState();
    _localStorage = locator<LocalStorage>();
  }

  @override
  Widget build(BuildContext context) {
    _taskNameController.text = widget.task.Taskname;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.25), blurRadius: 10)
          ]),
      child: ListTile(
        leading: GestureDetector(
          onTap: () {
            widget.task.isCompleted = !widget.task.isCompleted;
            _localStorage.updateTask(task: widget.task);
            setState(() {});
          },
          child: Container(
              decoration: BoxDecoration(
                  color: widget.task.isCompleted ? Colors.green : Colors.white,
                  border: Border.all(color: Colors.black.withOpacity(0.2)),
                  shape: BoxShape.circle),
              child: const Icon(
                Icons.check,
                color: Colors.white,
              )),
        ),
        title: widget.task.isCompleted
            ? Text(
                widget.task.Taskname,
                style: const TextStyle(
                    decoration: TextDecoration.lineThrough, color: Colors.grey),
              )
            : TextField(
                controller: _taskNameController,
                minLines: 1,
                maxLines: null,
                textInputAction: TextInputAction.done,
                style: ConstanstStyle.textFieldStyle(),
                decoration: const InputDecoration(border: InputBorder.none),
                onSubmitted: (value) {
                  if (value.isNotEmpty) {
                    widget.task.Taskname = value;
                    _localStorage.updateTask(task: widget.task);
                  }
                },
              ),
        trailing: Text(
          DateFormat('hh:mm a').format(widget.task.cretedAt),
          style: ConstanstStyle.dateTimeStlye(),
        ),
      ),
    );
  }
}
