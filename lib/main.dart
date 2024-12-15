import 'package:flutter/material.dart';

void main() async {
  runApp(MaterialApp(
    home: Scaffold(
      appBar: AppBar(
        title: Text('circular progress indicator'),
      ),
      body: Center(
        child: StreamBuilder<Object>(
          stream: Stream.empty(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return CircularProgressIndicator();
            }
            return Container();
          },
        ),
      ),
    ),
  ));
}
