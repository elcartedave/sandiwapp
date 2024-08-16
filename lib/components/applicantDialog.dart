import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandiwapp/components/button.dart';
import 'package:sandiwapp/components/styles.dart';
import 'package:sandiwapp/components/textfield.dart';
import 'package:sandiwapp/components/texts.dart';
import 'package:sandiwapp/models/userModel.dart';
import 'package:sandiwapp/providers/user_provider.dart';

class ApplicantDialog extends StatefulWidget {
  final MyUser user;
  const ApplicantDialog({required this.user, super.key});

  @override
  State<ApplicantDialog> createState() => _ApplicantDialogState();
}

class _ApplicantDialogState extends State<ApplicantDialog> {
  final List<String> designation = [
    "Resi-Lupon ng Edukasyon at Pananaliksik",
    "Resi-Lupon ng Pamamahayag at Publikasyon",
    "Resi-Lupon ng Kasapian",
    "Resi-Lupon ng Pananalapi",
    "Resi-Lupon ng Ugnayang Panlabas"
  ];
  String? _selectedDesignation;
  final _formKey = GlobalKey<FormState>();
  TextEditingController _batchController = TextEditingController();
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: PatrickHand(
        text: widget.user.name,
        fontSize: 24,
      ),
      backgroundColor: Colors.white,
      content: Form(
        key: _formKey,
        child: Column(
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
            const SizedBox(height: 10),
            Container(
                alignment: Alignment.topLeft,
                child: Text("Enter batch", style: blackText)),
            MyTextField2(
                controller: _batchController, obscureText: false, hintText: "")
          ],
        ),
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
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            _isLoading = true;
                          });

                          await context.read<UserProvider>().acceptAndAddLupon(
                              widget.user.email, _selectedDesignation!);
                          await context
                              .read<UserProvider>()
                              .addBatch(widget.user.id!, _batchController.text);
                          setState(() {
                            _isLoading = false;
                          });
                          Navigator.pop(context);
                        }
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
