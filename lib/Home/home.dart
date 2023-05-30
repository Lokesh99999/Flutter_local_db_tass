import 'package:assignment/SplashScreen.dart';
import 'package:assignment/TasksModel.dart';
import 'package:assignment/tasks_provider.dart';
import 'package:assignment/theme.dart';
import 'package:assignment/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController taskCtrl = TextEditingController();
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  int _counter = 0;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<TasksProvider>(context, listen: false).getAllTass();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TasksProvider>(builder: (context, tasks, child) {
      return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          actions: [
            GestureDetector(
              onTap: () {
                _prefs.then((value) {
                  value.clear();
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => SplashScreen()),
                      (Route<dynamic> route) => false);
                });
              },
              child: Icon(
                Icons.logout,
                color: Colors.white,
              ),
            )
          ],
        ),
        body: tasks.tasks.length < 1
            ? Center(
                child: Text("No Tass Available"),
              )
            : ListView.separated(
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(tasks.tasks[index].task),
                    trailing: SizedBox(
                      width: 80,
                      height: 120,
                      child: Row(children: [
                        GestureDetector(
                          onTap: () {
                            taskCtrl.text = tasks.tasks[index].task;
                            showDialog(
                                context: context,
                                barrierDismissible:
                                    true, // user must tap button!
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Center(
                                        child: const Text('Update task')),
                                    content: SingleChildScrollView(
                                        child: Column(
                                      children: [
                                        SizedBox(
                                            width: 300,
                                            child: TextFormField(
                                              maxLines: 5,
                                              controller: taskCtrl,
                                            )),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                      ],
                                    )),
                                    actions: <Widget>[
                                      Center(
                                        child: ElevatedButton(
                                          onPressed: () {
                                            if (taskCtrl.text.isNotEmpty) {
                                              tasks.updateTask(
                                                  tasks.tasks[index],
                                                  taskCtrl.text);
                                              Navigator.of(context).pop();
                                            } else {
                                              print("please enter task");
                                            }
                                          },
                                          style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                                    Colors.green),
                                            shape: MaterialStateProperty.all(
                                              RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                            ),
                                          ),
                                          child: const Text(
                                            "Update Task",
                                            style: TextStyle(
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  );
                                });
                          },
                          child: Icon(
                            Icons.edit,
                            color: Colors.green,
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        GestureDetector(
                          onTap: () {
                            showDialog(
                                context: context,
                                barrierDismissible:
                                    true, // user must tap button!
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text('Delete Task'),
                                    content: SingleChildScrollView(
                                        child: Column(
                                      children: [
                                        Text("Are You Sure Want to Delete ?")
                                      ],
                                    )),
                                    actions: <Widget>[
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  Colors.grey),
                                          shape: MaterialStateProperty.all(
                                            RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                          ),
                                        ),
                                        child: const Text(
                                          "Cancel",
                                          style: TextStyle(
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          tasks.removeTask(tasks.tasks[index]);
                                          Navigator.of(context).pop();
                                        },
                                        style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  Colors.red),
                                          shape: MaterialStateProperty.all(
                                            RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                          ),
                                        ),
                                        child: const Text(
                                          "Delete",
                                          style: TextStyle(
                                            fontSize: 16,
                                          ),
                                        ),
                                      )
                                    ],
                                  );
                                });
                          },
                          child: Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                        ),
                      ]),
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  return Divider();
                },
                itemCount: tasks.tasks.length,
              ),

        floatingActionButton: FloatingActionButton(
          onPressed: () {
            taskCtrl.clear();
            showDialog(
                context: context,
                barrierDismissible: true, // user must tap button!
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Center(child: const Text('Add Task')),
                    content: SingleChildScrollView(
                        child: Column(
                      children: [
                        SizedBox(
                            width: 300,
                            child: TextFormField(
                              controller: taskCtrl,
                            )),
                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    )),
                    actions: <Widget>[
                      Center(
                        child: ElevatedButton(
                          onPressed: () {
                            if (taskCtrl.text.isNotEmpty) {
                              tasks.addTask(TaskModel(task: taskCtrl.text));
                              taskCtrl.clear();
                              Navigator.pop(context);
                            } else {
                              Utils().toastErrorMessage("Please Enter task");
                            }
                          },
                          child: Text(
                            "Add Task",
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.green),
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  );
                });
          },
          tooltip: 'Add Task',
          child: const Icon(Icons.add),
        ), // This trailing comma makes auto-formatting nicer for build methods.
      );
    });
  }

  // Widget getTaskContainer(int index) {
  //   return Container(
  //     padding: EdgeInsets.all(20),
  //     decoration: BoxDecoration(
  //       borderRadius: BorderRadius.circular(12),
  //       boxShadow: [
  //         BoxShadow(color: Colors.grey, blurRadius: .3, spreadRadius: .9)
  //       ],
  //       color: Colors.white,
  //     ),
  //     child: Row(
  //       children: [
  //         Expanded(
  //           child: Text(
  //             "${tasks[index]}",
  //             style: TextStyle(fontSize: 20),
  //           ),
  //         ),
  //         Icon(
  //           Icons.edit,
  //           color: Colors.green,
  //         ),
  //         GestureDetector(
  //           onTap: () {
  //             setState(() {
  //               tasks.removeAt(index);
  //             });
  //           },
  //           child: Icon(
  //             Icons.delete,
  //             color: Colors.red,
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
}
