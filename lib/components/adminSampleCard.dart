import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandiwapp/components/reassignUserDialog.dart';
import 'package:sandiwapp/components/styles.dart';
import 'package:sandiwapp/models/userModel.dart';
import 'package:sandiwapp/providers/user_provider.dart';
import 'package:sandiwapp/screens/users/ResidentsProfilePage.dart';

class AdminSampleCard extends StatefulWidget {
  const AdminSampleCard({required this.user});

  final MyUser user;

  @override
  State<AdminSampleCard> createState() => _AdminSampleCardState();
}

class _AdminSampleCardState extends State<AdminSampleCard> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ResidentProfilePage(
                      user: widget.user,
                      message: false,
                    )));
      },
      onLongPress: () {
        showDialog(
            context: context,
            builder: (context) => ReassignUser(user: widget.user));
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 2),
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10), topRight: Radius.circular(10)),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8), topRight: Radius.circular(8)),
              child:
                  widget.user.photoUrl == null || widget.user.photoUrl!.isEmpty
                      ? Image.asset(
                          'assets/images/base_image.png',
                          fit: BoxFit.fill,
                          width: double.infinity,
                          height: 100,
                        )
                      : Image.network(
                          widget.user.photoUrl!,
                          fit: BoxFit.fill,
                          width: double.infinity,
                          height: 100,
                        ),
            ),
          ),
          const SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.fromLTRB(6, 4, 6, 4),
            child: Column(
              children: [
                Text(
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  widget.user.name,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  "Batch ${widget.user.batch}",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14),
                ),
                TextButton(
                  child: Text(
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      "Delete User",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14, color: Colors.red)),
                  onPressed: () async {
                    showCupertinoDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return CupertinoAlertDialog(
                          title: Text('Delete Note'),
                          content: Text(
                              'Are you sure you want to delete this user?'),
                          actions: [
                            CupertinoDialogAction(
                              isDefaultAction: true,
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text(
                                'Cancel',
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                            CupertinoDialogAction(
                              isDestructiveAction: true,
                              onPressed: () async {
                                try {
                                  await context
                                      .read<UserProvider>()
                                      .rejectAndDelete(widget.user.email);
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                          backgroundColor: Colors.white,
                                          content: Text(
                                            "User successfully deleted!",
                                            style: blackText,
                                          )));
                                  Navigator.pop(context);
                                } catch (e) {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                          backgroundColor: Colors.white,
                                          content: Text(
                                            "User deletion failed",
                                            style: blackText,
                                          )));
                                }
                              },
                              child: Text('Delete',
                                  style: TextStyle(color: Colors.black)),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
