import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:uuid/uuid.dart';

class App extends StatelessWidget {
  final String flavor;

  const App({
    super.key,
    required this.flavor,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flavor app',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: ElevatedButton(
            onPressed: () async {
              List<File> shareImages = [];
              final temp = await getTemporaryDirectory();
              final uri = Uri.parse('https://kinsta.com/wp-content/uploads/2020/08/tiger-jpg.jpg');
              final response = await http.get(uri);
              final bytes = response.bodyBytes;
              final path = '${temp.path}/1.jpg';
              File ele = File(path);
              await ele.writeAsBytes(bytes);
              shareImages.add(ele);

              final randomString = const Uuid().v4();
              String path1 = 'prod/$randomString.jpg';

              final ref = FirebaseStorage.instance.ref().child(path1);
              TaskSnapshot uploadTask = await ref.putFile(shareImages[0]);
              String url = await uploadTask.ref.getDownloadURL();
            },
            child: const Text('Upload'),
          ),
        ),
      ),
    );
  }
}
