import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandiwapp/components/button.dart';
import 'package:sandiwapp/components/customSnackbar.dart';
import 'package:sandiwapp/components/styles.dart';
import 'package:sandiwapp/components/textfield.dart';
import 'package:sandiwapp/components/texts.dart';
import 'package:sandiwapp/providers/payment_provider.dart';

class ImageDialog extends StatefulWidget {
  final String name;
  final String photoURL;
  final bool? isPayment;
  final String? date;
  final String? id;
  final String? userId;
  final String? amount;
  const ImageDialog(
      {this.id,
      this.userId,
      this.amount,
      this.date,
      this.isPayment,
      required this.name,
      required this.photoURL,
      super.key});

  @override
  State<ImageDialog> createState() => _ImageDialogState();
}

class _ImageDialogState extends State<ImageDialog> {
  TextEditingController _amountController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    widget.isPayment ?? false;
    return AlertDialog(
      backgroundColor: Colors.white,
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            PatrickHandSC(text: widget.name, fontSize: 24),
            const SizedBox(height: 10),
            widget.date == null
                ? Container()
                : Column(
                    children: [
                      Text(
                        "Ipinadala noong ${widget.date}",
                        style: blackText,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
            widget.amount != null
                ? Column(
                    children: [
                      Text(
                        "Amount: Php ${widget.amount}",
                        style: blackText,
                      ),
                    ],
                  )
                : Container(),
            const SizedBox(height: 10),
            widget.isPayment == false || widget.isPayment == null
                ? Container()
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Form(
                        key: _formKey,
                        child: MyTextField2(
                            controller: _amountController,
                            obscureText: false,
                            hintText: "Enter the amount indicated in the proof",
                            isNumber: true,
                            keyboardType: TextInputType.number),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
            Container(
              height: MediaQuery.of(context).size.height * 0.4,
              child: SingleChildScrollView(
                  child: CachedNetworkImage(
                imageUrl: widget.photoURL,
                fit: BoxFit.cover,
                progressIndicatorBuilder: (context, url, downloadProgress) =>
                    SizedBox(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(
                          color: Colors.black,
                          value: downloadProgress.progress,
                        ),
                      ],
                    ),
                  ),
                ),
              )),
            ),
          ],
        ),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            widget.isPayment == false || widget.isPayment == null
                ? Container()
                : Expanded(
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
                                String? message = await context
                                    .read<PaymentProvider>()
                                    .confirmPayment(widget.id!,
                                        _amountController.text, widget.userId!);
                                if (message == "") {
                                  showCustomSnackBar(
                                      context,
                                      "Payment of Php ${_amountController.text} is confirmed and balance is updated!",
                                      30);
                                } else {
                                  showCustomSnackBar(context, message!, 30);
                                }
                                Navigator.of(context).pop();
                              }
                            },
                          ),
                  ),
            widget.isPayment == false || widget.isPayment == null
                ? Container()
                : const SizedBox(width: 10),
            Expanded(
              child: WhiteButton(
                onTap: () {
                  Navigator.of(context).pop();
                },
                text: "Bumalik",
              ),
            ),
          ],
        )
      ],
    );
  }
}
