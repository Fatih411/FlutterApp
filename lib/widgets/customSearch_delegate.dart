import 'package:flutter/material.dart';
import 'package:flutter_todoapp/data/local_storage.dart';
import 'package:flutter_todoapp/main.dart';
import 'package:flutter_todoapp/models/task_model.dart';
import 'package:flutter_todoapp/widgets/taskListItem.dart';

class CustomSearchDelagte extends SearchDelegate {
  final List<Task> alltask;

  CustomSearchDelagte({required this.alltask});
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query.isEmpty ? null : query = '';
          },
          icon: const Icon(Icons.delete))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: const Icon(Icons.arrow_back_ios),
      color: Colors.black,
      iconSize: 20,
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    var filteredList = alltask
        .where(
          (element) =>
              element.Taskname.toLowerCase().contains(query.toLowerCase()),
        )
        .toList();
    return filteredList.isNotEmpty
        ? ListView.builder(
            itemCount: filteredList.length,
            itemBuilder: (context, index) {
              var _listChild = filteredList[index];
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
                  onDismissed: (direction) async {
                    filteredList.removeAt(index);
                    await locator<LocalStorage>().deleteTask(task: _listChild);
                  },
                  child: TaskItem(task: _listChild));
            },
          )
        : const Center(
            child: Text(
              "Bulunan Sonuç yok",
              style: TextStyle(
                fontSize: 18,
              ),
            ),
          );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
  }
}
