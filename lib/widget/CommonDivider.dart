import 'package:flutter/material.dart';

class CommonDivider {
  static Widget buildDivider() {
    return new Padding(
      padding: const EdgeInsets.only(left: 12.0, right: 12.0),
      child: new Divider(height: 1.0),
    );
  }
}
