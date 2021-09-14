import 'dart:io';

import 'package:path/path.dart';

enum Status { neutral, liked, disliked }

extension RealPath on Status {
  String get statusDirectory {
    switch (this) {
      case Status.neutral:
        return "";
      case Status.liked:
        return "liked";
      case Status.disliked:
        return "disliked";
    }
  }

  String realPath(Directory directory, String filename) =>
      join(directory.path, statusDirectory, filename);
}