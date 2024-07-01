import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:sandiwapp/components/button.dart';
import 'package:sandiwapp/components/customSnackbar.dart';
import 'package:sandiwapp/components/scrollDownAnimation.dart';
import 'package:sandiwapp/components/uploadImage.dart';
import 'package:sandiwapp/models/userModel.dart';
import 'package:sandiwapp/providers/payment_provider.dart';

class PaymentPage extends StatefulWidget {
  final MyUser user;
  const PaymentPage(this.user, {super.key});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  File? _image;
  bool _isLoading = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _pickImageAndScroll() async {
    File? pickedImage = await pickerImage();
    setState(() {
      _image = pickedImage;
    });
    if (_image != null) {
      scrollToEnd(_scrollController);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0.0,
        backgroundColor: const Color(0xFFEEEEEE),
        title: Text(
          "Payment Page",
          style: GoogleFonts.patrickHand(fontSize: 24),
        ),
      ),
      body: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Expanded(
          child: SingleChildScrollView(
            controller: _scrollController,
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Text(
                  "Ipadala lamang ang kakulangan sa isa sa mga accounts na ito",
                  style: GoogleFonts.patrickHand(fontSize: 20),
                ),
                Container(
                  height: 300,
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("GCash: 09123456789"),
                      Text("BPI: 09123456789"),
                      Text("Landbank: 09123456789")
                    ],
                  ),
                ),
                WhiteButton(
                  text: "Upload Proof of Payment",
                  onTap: _pickImageAndScroll,
                ),
                if (_image != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: Image.file(
                      _image!,
                      height: 200,
                      width: 200,
                    ),
                  ),
                Text(
                  "Note: Hindi kaagad magrereflect ang balanse sa iyong dashboard, kailangan munang kumpirmahin ng pinuno ng lupon ng pananalapi ang iyong payment",
                  style: GoogleFonts.patrickHand(
                      fontSize: 16, fontWeight: FontWeight.w300),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
        _isLoading
            ? const Padding(
                padding: EdgeInsets.all(16.0),
                child: Center(
                  child: CircularProgressIndicator(
                    color: Colors.black,
                  ),
                ),
              )
            : Padding(
                padding: const EdgeInsets.all(16.0),
                child: BlackButton(
                  text: "IPADALA",
                  onTap: () async {
                    setState(() {
                      _isLoading = true;
                    });
                    if (_image != null) {
                      await context.read<PaymentProvider>().uploadPayment(
                          _image!, widget.user.id!, widget.user.name);
                      showCustomSnackBar(
                          context, "Payment proof sent for review", 100);
                      Navigator.pop(context);
                    } else {
                      showCustomSnackBar(context, "No Image Uploaded!", 80);
                      setState(() {
                        _isLoading = false;
                      });
                    }
                  },
                ),
              )
      ]),
    );
  }
}
