import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firestore_test/getstudent.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: _getInit,
    );
  }
}

get _getInit {
  return FutureBuilder(
    future: Firebase.initializeApp(),
    builder: (context, snapshot) {
      if (snapshot.hasError) {
        return const Scaffold(
          body: Center(
              child: Icon(
            Icons.info,
            size: 30,
            color: Colors.red,
          )),
        );
      }
      if (snapshot.connectionState == ConnectionState.done) {
        return const MyHomePage(title: 'Home');
      }
      return const Center(
        child: CircularProgressIndicator(),
      );
    },
  );
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<String> docIds = [];
  Future getDocId() async {
    await FirebaseFirestore.instance
        .collection('student')
        .get()
        .then((value) => value.docs.forEach((DocumentSnapshot document) {
              setState(() {
                print('ID=${document.reference.id}');
                docIds.add(document.reference.id);
              });
            }));
  }

  var varInit;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    varInit = getDocId();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: FutureBuilder(
        future: varInit,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text('Something was wrong..');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text('Loading data....');
          }
          return ListView.builder(
            itemCount: docIds.length,
            itemBuilder: (context, index) {
              return getStudentData(documentId: docIds[index]);
            },
          );
        },
      ),
    );
  }
}
