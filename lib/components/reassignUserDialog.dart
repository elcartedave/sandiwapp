import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandiwapp/components/button.dart';
import 'package:sandiwapp/components/styles.dart';
import 'package:sandiwapp/components/texts.dart';
import 'package:sandiwapp/models/userModel.dart';

import '../providers/user_provider.dart';

class ReassignUser extends StatefulWidget {
  final MyUser user;
  const ReassignUser({required this.user, super.key});

  @override
  State<ReassignUser> createState() => _ReassignUserState();
}

class _ReassignUserState extends State<ReassignUser> {
  String? _selectedDesignation;
  bool _isLoading = false;
  final List<String> designation = [
    "Aplikante",
    "Resi-Lupon ng Edukasyon at Pananaliksik",
    "Resi-Lupon ng Pamamahayag at Publikasyon",
    "Resi-Lupon ng Kasapian",
    "Resi-Lupon ng Pananalapi",
    "Resi-Lupon ng Ugnayang Panlabas",
    "Head-Lupon ng Edukasyon at Pananaliksik",
    "Head-Lupon ng Pamamahayag at Publikasyon",
    "Head-Lupon ng Kasapian",
    "Head-Lupon ng Pananalapi",
    "Head-Lupon ng Ugnayang Panlabas",
    "Sec-Lupon ng Edukasyon at Pananaliksik",
    "Sec-Lupon ng Pamamahayag at Publikasyon",
    "Sec-Lupon ng Kasapian",
    "Sec-Lupon ng Pananalapi",
    "Sec-Lupon ng Ugnayang Panlabas",
    "VP-Lupon ng Edukasyon at Pananaliksik",
    "VP-Lupon ng Pamamahayag at Publikasyon",
    "VP-Lupon ng Kasapian",
    "VP-Lupon ng Pananalapi",
    "VP-Lupon ng Ugnayang Panlabas",
    "Pres-Lupon ng Edukasyon at Pananaliksik",
    "Pres-Lupon ng Pamamahayag at Publikasyon",
    "Pres-Lupon ng Kasapian",
    "Pres-Lupon ng Pananalapi",
    "Pres-Lupon ng Ugnayang Panlabas",
  ];
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: PatrickHand(
        text: widget.user.name,
        fontSize: 24,
      ),
      backgroundColor: Colors.white,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
              alignment: Alignment.topLeft,
              child: Text("Enter designation", style: blackText)),
          DropdownButtonFormField<String>(
            hint: Text("Designation", style: blackText),
            dropdownColor: Colors.white,
            isExpanded: true,
            value: _selectedDesignation,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.only(
                top: 12,
                left: 14,
                right: 14,
                bottom: 12,
              ),
              enabledBorder: OutlineInputBorder(
                borderSide:
                    const BorderSide(width: 2, color: Color(0xFF1A1A1A)),
                borderRadius: BorderRadius.circular(8),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 2, color: Colors.red),
                borderRadius: BorderRadius.circular(15),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 2, color: Colors.red),
                borderRadius: BorderRadius.circular(15),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 2, color: Colors.black),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onChanged: (newValue) {
              setState(() {
                _selectedDesignation = newValue;
              });
            },
            items: designation.map((designationItem) {
              return DropdownMenuItem(
                value: designationItem,
                child: Text(
                  designationItem,
                  style: TextStyle(fontSize: 12),
                  overflow: TextOverflow.ellipsis,
                ),
              );
            }).toList(),
            validator: (value) =>
                value == null ? 'Please select a designation' : null,
          ),
        ],
      ),
      actions: [
        Row(
          children: [
            Expanded(
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: Colors.black,
                      ),
                    )
                  : BlackButton(
                      text: "I-update",
                      onTap: () async {
                        setState(() {
                          _isLoading = true;
                        });

                        await context.read<UserProvider>().acceptAndAddLupon(
                            widget.user.email, _selectedDesignation!);

                        setState(() {
                          _isLoading = false;
                        });
                        Navigator.pop(context);
                      },
                    ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Center(
                child: WhiteButton(
                  text: "Bumalik",
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}
