import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/database_helper.dart';
import 'package:flutter_complete_guide/screens/taskpage.dart';
import 'package:flutter_complete_guide/widgets.dart';

import '../models/task.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DatabaseHelper dbHelper = DatabaseHelper();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: const Color(0xfff6f6f6),
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Stack(
            children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Container(
                  margin: const EdgeInsets.only(bottom: 32, top: 32),
                  child:
                      const Image(image: AssetImage('assets/images/logo.png')),
                ),
                Expanded(
                  child: FutureBuilder(
                    future: dbHelper.listTasks(),
                    builder: (context, AsyncSnapshot<List<Task>> snapshot) {
                      return ListView.builder(
                          itemCount: snapshot.data?.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => TaskPage(
                                      context,
                                      task: snapshot.data?[index],
                                    ),
                                  ),
                                ).then(
                                  (value) => setState(
                                    (() {}),
                                  ),
                                );
                              },
                              child: TaskCard(
                                title: snapshot.data?[index].title,
                                desc: snapshot.data?[index].description,
                              ),
                            );
                          });
                    },
                  ),
                )
              ]),
              Positioned(
                bottom: 24,
                right: 0,
                child: GestureDetector(
                  onTap: (() => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TaskPage(
                            context,
                          ),
                        ),
                      ).then(
                        (value) => setState((() {})),
                      )),
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color(0xff7349fe),
                            Color(0xff643fdb),
                          ],
                          begin: Alignment(0, -1),
                          end: Alignment(0, 1),
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    child: const Image(
                        image: AssetImage('assets/images/add_icon.png')),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
