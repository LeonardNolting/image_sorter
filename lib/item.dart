import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_sorter/status.dart';
import 'package:path/path.dart';

class Item extends StatelessWidget {
  final File file;
  late final String name;
  final Status status;
  final void Function(Status status) setStatus;

  Item({Key? key,
    required this.file,
    this.status = Status.neutral,
    required this.setStatus})
      : super(key: key) {
    name = basename(file.path);
  }

  void dragged(double delta, {int threshold = 0}) {
    if (delta != 0) {
      // TODO Datei auch tatsächlich verschieben
      if (delta > threshold) {
        setStatus(status == Status.liked ? Status.neutral : Status.disliked);
      } else if (delta < -threshold) {
        setStatus(status == Status.disliked ? Status.neutral : Status.liked);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Offset? start;
    double distance = 100;
    return GestureDetector(
      onVerticalDragEnd: (details) {
        // print("vertical: " + details.primaryVelocity.toString());
      },
      onVerticalDragDown: (details) {
        // start = details.globalPosition;
      },
      // TODO nicht nur auf `delta` hören sondern vor allem auf insgesamt zurückgelegte Strecke (sodass berechenbarer)
      onVerticalDragUpdate: (details) =>
          dragged(details.primaryDelta ?? 0.0, threshold: 20),
      onVerticalDragStart: (details) {
        // TODO andeuten? (ein bisschen in die Richtung gehen)
        // details.
      },
      child: FittedBox(
        fit: BoxFit.contain,
        alignment: Alignment.center,
        child: AnimatedContainer(
          transform: Matrix4.translationValues(
              0,
              status == Status.neutral
                  ? 0
                  : status == Status.disliked
                  ? distance
                  : -distance,
              0),
          curve: Curves.easeInOutCubicEmphasized,
          duration: const Duration(milliseconds: 200),
          child: Image.file(file),
        ),
      ),
    );
  }
}

/*class Item extends StatefulWidget {
  final File file;
  late final String name;

  Item({Key? key, required this.file}) : super(key: key) {
    name = basename(file.path);
  }

  @override
  State<StatefulWidget> createState() => _ItemState();
}

class _ItemState extends State<Item> {
  Status status = Status.neutral;

  void dragged(double delta, {int threshold = 0}) {
    if (delta != 0) {
      setState(() {
        // TODO Datei auch tatsächlich verschieben
        if (delta > threshold) {
          // status = Status.disliked;
          status = status == Status.liked ? Status.neutral : Status.disliked;
        } else if (delta < -threshold) {
          status = status == Status.disliked ? Status.neutral : Status.liked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Offset? start;
    double distance = 100;
    return GestureDetector(
      onVerticalDragEnd: (details) {
        // print("vertical: " + details.primaryVelocity.toString());
      },
      onVerticalDragDown: (details) {
        // start = details.globalPosition;
      },
      // TODO nicht nur auf `delta` hören sondern vor allem auf insgesamt zurückgelegte Strecke (sodass berechenbarer)
      onVerticalDragUpdate: (details) =>
          dragged(details.primaryDelta ?? 0.0, threshold: 20),
      onVerticalDragStart: (details) {
        // TODO andeuten? (ein bisschen in die Richtung gehen)
        // details.
      },
      child: FittedBox(
        fit: BoxFit.contain,
        alignment: Alignment.center,
        child: AnimatedContainer(
          transform: Matrix4.translationValues(
              0,
              status == Status.neutral
                  ? 0
                  : status == Status.disliked
                      ? distance
                      : -distance,
              0),
          curve: Curves.easeInOutCubicEmphasized,
          duration: const Duration(milliseconds: 200),
          child: Image.file(widget.file),
        ),
      ),
    );
  }
}*/