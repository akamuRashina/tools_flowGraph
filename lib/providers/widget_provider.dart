import 'package:flutter/material.dart';
import '../models/iot_widget.dart';
import 'dart:math';

class WidgetProvider extends ChangeNotifier {
  List<IoTWidget> widgets = [];

  void addWidget() {
    widgets.add(IoTWidget(
      id: Random().nextInt(99999).toString(),
      x: 60,
      y: 100,
      width: 140,
      height: 140,
      title: "Button",
    ));
    notifyListeners();
  }

  void update() {
    notifyListeners();
  }
}