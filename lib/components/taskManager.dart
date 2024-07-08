import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sandiwapp/components/button.dart';
import 'package:sandiwapp/components/customSnackbar.dart';
import 'package:sandiwapp/components/dateformatter.dart';
import 'package:sandiwapp/models/taskModel.dart';
import 'package:sandiwapp/providers/task_provider.dart';

class TaskManagerDialog extends StatefulWidget {
  const TaskManagerDialog({super.key});

  @override
  State<TaskManagerDialog> createState() => _TaskManagerDialogState();
}

class _TaskManagerDialogState extends State<TaskManagerDialog> {
  late List<bool> tempStatusList;
  late List<MyTask> tasks;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    tempStatusList = []; // Initialize the tempStatusList here
  }

  @override
  Widget build(BuildContext context) {
    Stream<QuerySnapshot> _tasksStream =
        context.watch<TaskProvider>().fetchTasks();
    return AlertDialog(
      backgroundColor: Colors.white,
      title: Text(
        "Mga Nakatakdang Gawain",
        style: GoogleFonts.patrickHand(color: Colors.black, fontSize: 24),
      ),
      content: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.8,
          maxHeight: MediaQuery.of(context).size.height * 0.6,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                "Lagyan ng tsek ang mga gawaing tapos na",
                style: GoogleFonts.inter(fontSize: 16),
                textAlign: TextAlign.left,
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: StreamBuilder(
                stream: _tasksStream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {}
                  if (snapshot.hasError) {
                    return Center(child: Text("Error: ${snapshot.error}"));
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(child: Text("No Tasks Yet!"));
                  }

                  tasks = snapshot.data!.docs.map((doc) {
                    var data = doc.data() as Map<String, dynamic>;
                    return MyTask.fromJson(data);
                  }).toList();

                  // Initialize tempStatusList once tasks are loaded
                  if (tempStatusList.isEmpty) {
                    tempStatusList = tasks.map((task) => task.status).toList();
                  }

                  return ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: EdgeInsets.symmetric(vertical: 4),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black, width: 2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: CheckboxListTile(
                          activeColor: Colors.black,
                          title: Text(
                            tasks[index].task,
                            style: GoogleFonts.patrickHand(fontSize: 22),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Date Assigned: ${dateFormatter(tasks[index].date)}",
                                style: GoogleFonts.patrickHand(fontSize: 15),
                              ),
                              Text(
                                "Due Date: ${dateFormatter(tasks[index].dueDate)}",
                                style: GoogleFonts.patrickHand(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          value: tempStatusList[index],
                          onChanged: (bool? value) {
                            setState(() {
                              tempStatusList[index] = value!;
                            });
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: _isLoading
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: Colors.black,
                            ),
                          )
                        : BlackButton(
                            text: "I-Save",
                            onTap: () async {
                              // Update tasks in Firestore
                              setState(() {
                                _isLoading = true;
                              });
                              for (int i = 0; i < tasks.length; i++) {
                                tasks[i].status = tempStatusList[i];
                                await context
                                    .read<TaskProvider>()
                                    .toggleTask(tasks[i].id!, tasks[i].status);
                                print("${tasks[i].id} - ${tasks[i].status}");
                              }
                              showCustomSnackBar(context, "Tasks Updated", 85);
                              Navigator.of(context).pop(); //
                            },
                          ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: WhiteButton(
                      text: "Cancel",
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
