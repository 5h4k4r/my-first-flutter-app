import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/database_helper.dart';

import '../models/task.dart';
import '../models/todo.dart';
import '../widgets.dart';

class TaskPage extends StatefulWidget {
  const TaskPage(BuildContext context, {this.task});
  final Task? task;

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  String _taskTitle = "";
  int _taskId = 0;
  String _taskDescription = "";

  late FocusNode _titleFocusNode;
  late FocusNode _todoFocusNode;
  late FocusNode _descFocusNode;
  bool _contentVisible = false;
  DatabaseHelper dbHelper = DatabaseHelper();

  @override
  void initState() {
    if (widget.task != null) {
      _taskTitle = widget.task?.title ?? "";
      _taskId = widget.task?.id ?? 0;
      _taskDescription = widget.task?.description ?? "";
      _contentVisible = true;
    }
    _titleFocusNode = FocusNode();
    _todoFocusNode = FocusNode();
    _descFocusNode = FocusNode();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 24,
                      bottom: 6,
                    ),
                    child: Row(children: [
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(24),
                          child: Image(
                            image:
                                AssetImage('assets/images/back_arrow_icon.png'),
                          ),
                        ),
                      ),
                      Expanded(
                        child: TextField(
                          focusNode: _titleFocusNode,
                          onSubmitted: (value) async {
                            DatabaseHelper dbHelper = DatabaseHelper();
                            if (value != "") {
                              if (widget.task == null) {
                                Task newTask = Task(
                                  title: value,
                                );
                                _taskId = await dbHelper.insertTask(newTask);
                                print("id: $_taskId");
                                setState(() {
                                  _contentVisible = true;
                                  _taskTitle = value;
                                });
                              } else {
                                await dbHelper.updateTaskTitle(
                                  _taskId,
                                  value,
                                );
                                print("Updated task title");

                                setState(() {
                                  _taskTitle = value;
                                });
                              }
                              _descFocusNode.requestFocus();
                            }
                          },
                          controller: TextEditingController(text: _taskTitle),
                          decoration: const InputDecoration(
                            hintText: "Enter task title",
                            border: InputBorder.none,
                          ),
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff211551),
                          ),
                        ),
                      )
                    ]),
                  ),
                  Visibility(
                    visible: _contentVisible,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: TextField(
                        focusNode: _descFocusNode,
                        controller:
                            TextEditingController(text: _taskDescription),
                        decoration: const InputDecoration(
                          hintText: "Enter task description",
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 24,
                          ),
                        ),
                        onSubmitted: (value) async {
                          _todoFocusNode.requestFocus();
                          if (value == "" || _taskId == 0) return;

                          await dbHelper.updateTaskDesc(_taskId, value);
                        },
                      ),
                    ),
                  ),
                  Visibility(
                    visible: _contentVisible,
                    child: FutureBuilder(
                      initialData: const <Todo>[],
                      future: dbHelper.getTodo(_taskId),
                      builder: (context, AsyncSnapshot<List<Todo>> snapshot) {
                        return Expanded(
                          child: ListView.builder(
                            itemCount: snapshot.data?.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () async {
                                  var todo = snapshot.data![index];

                                  if (snapshot.data![index].isDone == 0) {
                                    await dbHelper.updateTodo(
                                        snapshot.data![index].id!, 1);
                                  } else {
                                    await dbHelper.updateTodo(
                                        snapshot.data![index].id!, 0);
                                  }
                                  setState(() {});
                                },
                                child: TodoWidget(
                                  text: snapshot.data![index].title,
                                  isDone: snapshot.data![index].isDone == 0
                                      ? false
                                      : true,
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  Visibility(
                    visible: _contentVisible,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Row(
                        children: [
                          Container(
                            width: 20,
                            height: 20,
                            margin: const EdgeInsets.only(right: 12),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                  color: const Color(0xff86829d), width: 1.5),
                              color: Colors.transparent,
                            ),
                            child: const Image(
                              image: AssetImage('assets/images/check_icon.png'),
                            ),
                          ),
                          Expanded(
                            child: TextField(
                              controller: TextEditingController(text: ""),
                              focusNode: _todoFocusNode,
                              onSubmitted: (value) async {
                                DatabaseHelper dbHelper = DatabaseHelper();
                                if (value == "" || widget.task == null) {
                                  return;
                                }
                                Todo newTodo = Todo(
                                    title: value,
                                    isDone: 0,
                                    taskId: widget.task!.id!);
                                await dbHelper.insertTodo(newTodo);
                                setState(() {});
                                print("Created new todo");
                                _todoFocusNode.requestFocus();
                              },
                              decoration: const InputDecoration(
                                  hintText: "Enter todo item",
                                  border: InputBorder.none),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
              Visibility(
                visible: _contentVisible,
                child: Positioned(
                  bottom: 24,
                  right: 24,
                  child: GestureDetector(
                    onTap: (() async {
                      if (_taskId != 0) {
                        await dbHelper.deleteTask(_taskId);
                        Navigator.pop(context);
                        setState(() {});
                      }
                    }),
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration: const BoxDecoration(
                          color: Color(0xffde3577),
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      child: const Image(
                          image: AssetImage('assets/images/delete_icon.png')),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
