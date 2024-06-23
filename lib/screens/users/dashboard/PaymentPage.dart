import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sandiwapp/components/button.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0.0,
        backgroundColor: Color(0xFFEEEEEE),
        title: Text(
          "Payment Page",
          style: GoogleFonts.patrickHand(fontSize: 24),
        ),
      ),
      body: Container(
          padding: EdgeInsets.all(16),
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
              WhiteButton(text: "Upload Proof of Payment"),
              Text(
                "Note: Hindi kaagad magrereflect ang balanse sa iyong dashboard, kailangan munang kumpirmahin ng pinuno ng lupon ng pananalapi ang iyong payment",
                style: GoogleFonts.patrickHand(
                    fontSize: 16, fontWeight: FontWeight.w300),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: Align(
                  alignment: FractionalOffset.bottomCenter,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      height: 50,
                      decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(10)),
                      child: Center(
                          child: Text(
                        "IPADALA",
                        style: GoogleFonts.patrickHand(
                            fontSize: 22, color: Colors.white),
                      )),
                    ),
                  ),
                ),
              )
            ],
          )),
    );
  }
}
