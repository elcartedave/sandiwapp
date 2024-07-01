import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandiwapp/components/styles.dart';
import 'package:sandiwapp/models/userModel.dart';
import 'package:sandiwapp/providers/user_provider.dart';

class AdminSampleCard extends StatefulWidget {
  const AdminSampleCard({required this.user});

  final MyUser user;

  @override
  State<AdminSampleCard> createState() => _AdminSampleCardState();
}

class _AdminSampleCardState extends State<AdminSampleCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
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
                    try {
                      await context
                          .read<UserProvider>()
                          .rejectAndDelete(widget.user.email);
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          backgroundColor: Colors.white,
                          content: Text(
                            "User successfully deleted!",
                            style: blackText,
                          )));
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          backgroundColor: Colors.white,
                          content: Text(
                            "User deletion failed",
                            style: blackText,
                          )));
                    }
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
