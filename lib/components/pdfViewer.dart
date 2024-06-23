import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PDFViewer extends StatelessWidget {
  const PDFViewer({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[50],
      body: Padding(
        padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
        child: SfPdfViewer.asset(
          "assets/pdfs/konsti.pdf",
          enableTextSelection: true,
          enableDoubleTapZooming: true,
          canShowTextSelectionMenu: true,
        ),
      ),
    );
  }
}
