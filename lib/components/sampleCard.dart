import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandiwapp/components/imageBuffer.dart';
import 'package:sandiwapp/components/showMessageDialog.dart';
import 'package:sandiwapp/models/userModel.dart';
import 'package:sandiwapp/providers/user_provider.dart';
import 'package:sandiwapp/screens/users/ResidentsProfilePage.dart';

class SampleCard extends StatefulWidget {
  const SampleCard({required this.user});

  final MyUser user;

  @override
  State<SampleCard> createState() => _SampleCardState();
}

class _SampleCardState extends State<SampleCard> {
  @override
  Widget build(BuildContext context) {
    Stream<DocumentSnapshot> _userStream =
        context.watch<UserProvider>().fetchCurrentUser();
    return StreamBuilder(
        stream: _userStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator(
              color: Colors.white,
            ));
          }
          if (snapshot.hasError) {
            return const Center(child: Text("Error fetching user data"));
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(child: Text("User data not available"));
          }
          MyUser currentUser =
              MyUser.fromJson(snapshot.data!.data() as Map<String, dynamic>);

          return InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      fullscreenDialog: true,
                      builder: (context) => ResidentProfilePage(
                            user: widget.user,
                          )));
            },
            onLongPress: () {
              showDialog(
                  context: context,
                  builder: (context) => ShowMessageDialog(
                      senderEmail: currentUser.email, user: widget.user));
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 2),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10)),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8),
                        topRight: Radius.circular(8)),
                    child: widget.user.photoUrl == null ||
                            widget.user.photoUrl!.isEmpty
                        ? Image.asset(
                            'assets/images/base_image.png',
                            fit: BoxFit.fill,
                            width: double.infinity,
                            height: 100,
                          )
                        : ImageBuffer(
                            photoURL: widget.user.photoUrl!,
                            fit: BoxFit.contain,
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
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }
}
