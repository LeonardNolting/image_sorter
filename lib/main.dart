import 'dart:async';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import 'carousel.dart';

void main() {
  runApp(const App());
}

Future<File> moveFile(File sourceFile, String newPath) async {
  try {
    // prefer using rename as it is probably faster
    return await sourceFile.rename(newPath);
  } on FileSystemException {
    // if rename fails, copy the source file and then delete it
    final newFile = await sourceFile.copy(newPath);
    await sourceFile.delete();
    return newFile;
  }
}

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AppState();
}

class _AppState extends State<App> {
  bool showContext = false;
  Directory? directory;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Image Sorter',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: Scaffold(
          appBar: AppBar(
            leading: IconButton(
                onPressed: () {
                  FilePicker.platform.getDirectoryPath().then((value) => {
                        if (value != null)
                          setState(() {
                            directory = Directory(value);
                          })
                      });
                },
                icon: const Icon(Icons.folder)),
            automaticallyImplyLeading: false,
            actions: [
              IconButton(onPressed: () {}, icon: const Icon(Icons.help))
            ],
          ),
          body: Body(directory: directory, showContext: showContext)),
    );
  }
}

class Body extends StatefulWidget {
  const Body({Key? key, required this.directory, required this.showContext})
      : super(key: key);

  final Directory? directory;
  final bool showContext;

  @override
  State<StatefulWidget> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  Widget build(BuildContext context) {
    var directory = widget.directory;
    if (directory != null) {
      var files = <File>[];
      var completer = Completer<List<File>>();
      var lister = directory.list(recursive: false, followLinks: false);
      lister.listen((file) {
        if (file is File) {
          files.add(file);
        }
      },
          onDone: () => completer.complete(files),
          onError: (error) => completer.completeError(error),
          cancelOnError: true);

      return FutureBuilder<List<File>>(
        future: completer.future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Carousel(
                showContext: widget.showContext,
                files: files,
                directory: directory);
          } else if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.error),
                  Text("Something went wrong! Please try again.")
                ],
              ),
            );
          } else {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  CircularProgressIndicator(),
                  Text("Loading files...")
                ],
              ),
            );
          }
        },
      );
    } else {
      return const Center(child: Text("Please pick a folder."));
    }
  }
}
