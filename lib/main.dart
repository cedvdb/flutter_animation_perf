import 'package:flutter/material.dart';

void main() async {
  runApp(MaterialApp(
    home: Scaffold(
      appBar: AppBar(
        title: Text('circular progress indicator'),
      ),
      body: Center(child: CircularProgressIndicator()),
    ),
  ));
}
