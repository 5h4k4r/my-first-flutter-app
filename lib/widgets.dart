import 'package:flutter/material.dart';

class TaskCard extends StatelessWidget {
  final String? desc;
  final String? title;

  const TaskCard({Key? key, this.desc, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
        margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title ?? "{Unnamed task}",
              style: const TextStyle(
                  color: Color(0xff211551),
                  fontSize: 22,
                  fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15),
              child: Text(
                desc ?? "No Description added",
                style: const TextStyle(
                    fontSize: 16, color: Color(0xff86829d), height: 1.5),
              ),
            )
          ],
        ));
  }
}

class TodoWidget extends StatelessWidget {
  const TodoWidget({this.text, this.isDone});

  final String? text;
  final bool? isDone;
  get isTaskDone => isDone != null && isDone!;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Row(
        children: [
          Container(
            width: 20,
            height: 20,
            margin: const EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              border: isTaskDone
                  ? null
                  : Border.all(color: const Color(0xff86829d), width: 1.5),
              color: isTaskDone ? const Color(0xff7349fe) : Colors.transparent,
            ),
            child: const Image(
              image: AssetImage('assets/images/check_icon.png'),
            ),
          ),
          Flexible(
            child: Text(
              text ?? "(Unnamed Todo)",
              style: TextStyle(
                color: isTaskDone
                    ? const Color(0xff211551)
                    : const Color(0xff86829d),
                fontSize: 16,
                fontWeight: isTaskDone ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          )
        ],
      ),
    );
  }
}
