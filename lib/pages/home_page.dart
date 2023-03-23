import 'package:flutter/material.dart';
import 'package:flutter_todoapp/Constants/style.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_todoapp/data/local_storage.dart';
import 'package:flutter_todoapp/main.dart';
import 'package:flutter_todoapp/models/task_model.dart';
import 'package:flutter_todoapp/widgets/customSearch_delegate.dart';
import 'package:flutter_todoapp/widgets/taskListItem.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<Task> _alltasks;
  late LocalStorage localStorage;
  @override
  void initState() {
    super.initState();
    localStorage = locator<LocalStorage>();
    _alltasks = <Task>[];
    _getAllTaskFrom();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _appBar(context),
        body: _alltasks.isNotEmpty
            ? _listViewBuilder(_alltasks)
            : const Center(
                child: Text(
                  "Hadi Görev Ekle",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
              ));
  }

  AppBar _appBar(BuildContext context) {
    return AppBar(
      title: GestureDetector(
          onTap: () {
            _showAddTaskBottomSheet(context);
          },
          child: Text("Bugün Neler Yapacaksın?",
              style: ConstanstStyle.appbarText())),
      centerTitle: false,
      backgroundColor: Colors.white,
      actions: appbarIcons(context),
    );
  }

  List<Widget> appbarIcons(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          _showSearchPage();
        },
        icon: const Icon(Icons.search),
      ),
      IconButton(
        onPressed: () {
          _showAddTaskBottomSheet(context);
        },
        icon: const Icon(Icons.add),
      ),
    ];
  }

  void _showAddTaskBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          width: MediaQuery.of(context).size.width,
          child: ListTile(
            title: TextField(
              autofocus: true,
              style: const TextStyle(fontSize: 18),
              decoration: const InputDecoration(
                  hintText: 'Görev Nedir?', border: InputBorder.none),
              onSubmitted: (value) {
                Navigator.of(context).pop();
                if (value.isNotEmpty) {
                  DatePicker.showTimePicker(
                    context,
                    showSecondsColumn: false,
                    onConfirm: (time) async {
                      var newTask =
                          Task.create(Taskname: value, cretedAt: time);
                      _alltasks.insert(0, newTask);
                      await localStorage.addTask(task: newTask);
                      setState(() {});
                    },
                  );
                }
              },
            ),
          ),
        );
      },
    );
  }

  ListView _listViewBuilder(List<Task> list) {
    return ListView.builder(
      itemCount: list.length,
      itemBuilder: (context, index) {
        var _listChild = list[index];
        return Dismissible(
            background: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(
                  Icons.delete,
                  color: Colors.grey,
                ),
                SizedBox(
                  width: 10,
                ),
                Text("Bu Görev sildindi"),
              ],
            ),
            key: Key(_listChild.Taskid),
            onDismissed: (direction) {
              list.removeAt(index);
              localStorage.deleteTask(task: _listChild);
              setState(() {});
            },
            child: TaskItem(task: _listChild));
      },
    );
  }

  void _getAllTaskFrom() async {
    _alltasks = await localStorage.getAllTask();
    setState(() {});
  }

  void _showSearchPage() async {
    await showSearch(
        context: context, delegate: CustomSearchDelagte(alltask: _alltasks));
    _getAllTaskFrom();
  }
}
