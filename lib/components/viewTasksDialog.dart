import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sandiwapp/components/button.dart';
import 'package:sandiwapp/components/customSnackbar.dart';
import 'package:sandiwapp/components/dateformatter.dart';
import 'package:sandiwapp/models/taskModel.dart';
import 'package:sandiwapp/models/userModel.dart';
import 'package:sandiwapp/providers/task_provider.dart';

class ViewTasks extends StatefulWidget {
  final MyUser user;
  const ViewTasks({required this.user, super.key});

  @override
  State<ViewTasks> createState() => _ViewTasksState();
}

class _ViewTasksState extends State<ViewTasks> {
  late List<MyTask> tasks;
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    Stream<QuerySnapshot> _tasksStream =
        context.watch<TaskProvider>().fetchUserTasks(widget.user.email);
    return AlertDialog(
      backgroundColor: Colors.white,
      title: Text("${widget.user.nickname}'s Tasks"),
      content: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.5,
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
                  return MyTask.fromJson(data);
                }).toList();

                return ListView.builder(
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      return CheckboxListTile(
                        activeColor: Colors.black,
                        title: Text(
                          tasks[index].task,
                          style: GoogleFonts.patrickHand(fontSize: 22),
                        ),
                        subtitle: Column(
                          children: [
                            Text(
                              "Date Assigned: ${dateFormatter(tasks[index].date)}",
                              style: GoogleFonts.patrickHand(fontSize: 15),
                            ),
                            Text(
                              "Due Date: ${dateFormatter(tasks[index].dueDate)}",
                              style: GoogleFonts.patrickHand(
                                  fontSize: 15, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                        value: tasks[index].status,
                        onChanged: (bool? value) {
                          showCustomSnackBar(
                              context, "Only the member can edit the task", 30);
                        },
                      );
                    });
              }),
        ),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            _isLoading
                ? const Expanded(
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Center(
                        child: CircularProgressIndicator(
                          color: Colors.black,
                        ),
                      ),
                    ),
                  )
                : Expanded(
                    child: BlackButton(
                        text: "Confirm Done Tasks",
                        onTap: () async {
                          // Update tasks in Firestore
                          setState(() {
                            _isLoading = true;
                          });

                          await context
                              .read<TaskProvider>()
                              .deleteTask(widget.user.email);

                          showCustomSnackBar(context, "Tasks Updated", 85);
                          Navigator.of(context)
                              .pop(); // Close the dialog after saving
                        }),
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
        )
      ],
    );
  }
}
