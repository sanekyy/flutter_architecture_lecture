

import 'package:uuid/uuid.dart';

class IDGenerator {
  static const _uuid = Uuid();

  String generate() =>  _uuid.v4();
}