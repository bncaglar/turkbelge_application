import 'package:flutter/material.dart';

class PdfViewerPage extends StatefulWidget {
  var filePath;

  PdfViewerPage({required this.filePath});

  @override
  _PdfViewerPageState createState() => _PdfViewerPageState();
}

class _PdfViewerPageState extends State<PdfViewerPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(

      ),
    );
  }
}
