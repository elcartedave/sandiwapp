import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sandiwapp/components/button.dart';
import 'package:sandiwapp/models/taskModel.dart';
import 'package:sandiwapp/providers/task_provider.dart';

class TaskManager extends StatefulWidget {
  const TaskManager({super.key});

  @override
  State<TaskManager> createState() => _TaskManagerState();
}

class _TaskManagerState extends State<TaskManager> {
  late List<bool> tempStatusList;
  late List<Task> tasks;

  @override
  void initState() {
    super.initState();
    tempStatusList = []; // Initialize the tempStatusList here
  }

  @override
  Widget build(BuildContext context) {
    Stream<QuerySnapshot> _tasksStream =
        context.read<TaskProvider>().getUserTask();
    return AlertDialog(
      backgroundColor: Colors.white,
      title: Text(
        "Mga Nakatakdang Gawain",
        style: GoogleFonts.patrickHand(color: Colors.black, fontSize: 30),
        textAlign: TextAlign.left,
      ),
      content: Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                "Lagyan ng tsek ang mga gawaing tapos na",
                style: GoogleFonts.patrickHand(fontSize: 15),
              ),
              const SizedBox(height: 10),
              Container(
                height: 300,
                child: StreamBuilder(
                    stream: _tasksStream,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                            child: CircularProgressIndicator(
                          color: Colors.black,
                        ));
                      }
                      if (snapshot.hasError) {
                        return Center(child: Text("Error: ${snapshot.error}"));
                      }
                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return Center(child: Text("No Tasks Yet!"));
                      }

                      tasks = snapshot.data!.docs.map((doc) {
                        var data = doc.data() as Map<String, dynamic>;
                        return Task.fromJson(data);
                      }).toList();

                      // Initialize tempStatusList once tasks are loaded
                      if (tempStatusList.isEmpty) {
                        tempStatusList =
                            tasks.map((task) => task.status).toList();
                      }

                      return ListView.builder(
                          itemCount: tasks.length,
                          itemBuilder: (context, index) {
                            return CheckboxListTile(
                              activeColor: Colors.black,
                              title: Text(
                                tasks[index].task,
                                style: GoogleFonts.patrickHand(fontSize: 20),
                              ),
                              subtitle: Text(
                                "Due: ${tasks[index].dueDate}",
                                style: GoogleFonts.patrickHand(fontSize: 15),
                              ),
                              value: tempStatusList[index],
                              onChanged: (bool? value) {
                                setState(() {
                                  tempStatusList[index] = value!;
                                });
                              },
                            );
                          });
                    }),
              ),
            ],
          ),
        ),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            BlackButton(
                text: "I-Save",
                onTap: () async {
                  // Update tasks in Firestore
                  for (int i = 0; i < tasks.length; i++) {
                    tasks[i].status = tempStatusList[i];
                    await context
                        .read<TaskProvider>()
                        .toggleTask(tasks[i].id!, tasks[i].status);
                    print(
                        'Updated task ${tasks[i].id} with status ${tasks[i].status}');
                  }
                  Navigator.of(context).pop(); // Close the dialog after saving
                }),
            const SizedBox(width: 10),
            WhiteButton(
              text: "Cancel",
              onTap: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        )
      ],
    );
  }
}
