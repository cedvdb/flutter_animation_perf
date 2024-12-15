import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:test_flut/data.dart';
import 'package:test_flut/firebase_options.dart';

void main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseFirestore.instance.settings = Settings(
    persistenceEnabled: true,
  );
  FirebaseFirestore.instance.disableNetwork();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: const MyHomePage(title: 'Flutter firestore test'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late final Future<QuerySnapshot> data;
  bool isCreating = false;
  bool hasCreatedData = false;
  final watch = Stopwatch();

  @override
  void initState() {
    watch.start();
    super.initState();
    data = FirebaseFirestore.instance.collection('products').get(GetOptions());
  }

  void createData() async {
    setState(() {
      isCreating = true;
    });
    final writes = <Future>[];
    for (final product in productsData) {
      final write = FirebaseFirestore.instance
          .collection('products')
          .doc(product['id'] as String)
          .set(product);
      writes.add(write);
    }
    await Future.wait(writes);
    setState(() {
      isCreating = false;
      hasCreatedData = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: FutureBuilder(
        future: data,
        builder: (ctx, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }
          if (snap.requireData.docs.isEmpty) {
            if (isCreating) {
              return Text('creating data, hold on this could take a minute...');
            }
            if (hasCreatedData) {
              return Text('Please reload the page to start the benchmark');
            }
            return ElevatedButton(
              onPressed: createData,
              child: Text('Create data'),
            );
          }
          return Text(
              'found ${snap.requireData.docs.length} products, ${watch.elapsed}');
        },
      ),
    );
  }
}
