import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandiwapp/components/dateformatter.dart';
import 'package:sandiwapp/components/imageBuffer.dart';
import 'package:sandiwapp/components/imageDialog.dart';
import 'package:sandiwapp/components/styles.dart';
import 'package:sandiwapp/components/texts.dart';
import 'package:sandiwapp/models/paymentModel.dart';
import 'package:sandiwapp/providers/payment_provider.dart';

class ViewPaymentsPage extends StatefulWidget {
  const ViewPaymentsPage({super.key});

  @override
  State<ViewPaymentsPage> createState() => _ViewPaymentsPageState();
}

class _ViewPaymentsPageState extends State<ViewPaymentsPage> {
  @override
  Widget build(BuildContext context) {
    Stream<QuerySnapshot> _paymentsStream =
        context.watch<PaymentProvider>().payments;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: PatrickHand(text: "View Proof of Payments", fontSize: 24),
      ),
      body: StreamBuilder(
        stream: _paymentsStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text("No Payments Yet!"));
          }
          List<Payment> payments = snapshot.data!.docs.map((doc) {
            return Payment.fromJson(doc.data() as Map<String, dynamic>);
          }).toList();

          // Group the payments by their confirmation status
          List<Payment> notConfirmedPayments =
              payments.where((payment) => !payment.confirmed!).toList();
          List<Payment> confirmedPayments =
              payments.where((payment) => payment.confirmed!).toList();

          // Sort payments within each group by date (most recent first)
          notConfirmedPayments.sort((a, b) => b.date!.compareTo(a.date!));
          confirmedPayments.sort((a, b) => b.date!.compareTo(a.date!));

          return ListView(
            children: [
              if (notConfirmedPayments.isNotEmpty) ...[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Not Confirmed Payments',
                    style: blackText.copyWith(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(8.0),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 8.0,
                    mainAxisSpacing: 8.0,
                    childAspectRatio: 1.0,
                  ),
                  itemCount: notConfirmedPayments.length,
                  itemBuilder: (context, index) {
                    Payment payment = notConfirmedPayments[index];
                    return PaymentGridTile(
                      payment: payment,
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return ImageDialog(
                              name: "${payment.sender}'s Proof of Payment",
                              photoURL: payment.photoURL,
                              isPayment: !payment.confirmed!,
                              date: dateFormatter(payment.date!),
                              userId: payment.userId,
                              id: payment.id,
                            );
                          },
                        );
                      },
                      isConfirmed: false,
                    );
                  },
                ),
              ],
              if (confirmedPayments.isNotEmpty) ...[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Confirmed Payments',
                    style: blackText.copyWith(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(8.0),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 8.0,
                    mainAxisSpacing: 8.0,
                    childAspectRatio: 1.0,
                  ),
                  itemCount: confirmedPayments.length,
                  itemBuilder: (context, index) {
                    Payment payment = confirmedPayments[index];
                    return PaymentGridTile(
                      payment: payment,
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return ImageDialog(
                              name: "${payment.sender}'s Proof of Payment",
                              photoURL: payment.photoURL,
                              isPayment: !payment.confirmed!,
                              date: dateFormatter(payment.date!),
                              amount: payment.amount,
                            );
                          },
                        );
                      },
                      isConfirmed: true,
                    );
                  },
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}

class PaymentGridTile extends StatelessWidget {
  final Payment payment;
  final VoidCallback onTap;
  final bool isConfirmed;

  const PaymentGridTile({
    Key? key,
    required this.payment,
    required this.onTap,
    required this.isConfirmed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridTile(
      child: GestureDetector(
        onTap: onTap,
        child: Card(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          elevation: 5,
          child: Column(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(10.0),
                  ),
                  child: Stack(
                    children: [
                      ImageBuffer(
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                        photoURL: payment.photoURL,
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  payment.sender!,
                  style: blackText,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
