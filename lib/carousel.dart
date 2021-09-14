import 'dart:io';

import 'package:flutter/material.dart';

import 'item.dart';
import 'status.dart';

class Carousel extends StatefulWidget {
  // TODO Position merken (bzw. ableiten können aus echtem Pfad (nachdem verschoben wurde))

  late final List<File> files;

  Carousel(
      {Key? key,
      required this.showContext,
      required this.files,
      required this.directory})
      : super(key: key) {
    // items = files.map((file) => Item(file: file));
  }

  final bool showContext;
  final Directory directory;

  @override
  State<StatefulWidget> createState() => _CarouselState();
}

class _CarouselState extends State<Carousel> {
  // late final Iterable<Item> items = widget.files.map((file) => Item(file: file));
  late final List<Item> items;

  @override
  void initState() {
    super.initState();
    items = widget.files
        .asMap()
        .entries
        .map((entry) {
      void setStatus(Status status) {
        setState(() {
          items[entry.key] =
              Item(file: entry.value, status: status, setStatus: setStatus);
        });
      }

      return Item(file: entry.value, setStatus: setStatus);
    }).toList(growable: false);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.showContext) {
      // SafeArea
    } else {}

    return PageView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: items.length + 1,
        itemBuilder: (context, index) => index == items.length
            ? const Center(child: Text("You've reached the end."))
            : items.elementAt(index));
  }
}