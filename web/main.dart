import 'dart:html';

import 'package:gamo_dart/gamo.dart';
import 'package:gamo_dart/scenes/testscene.dart';

CanvasElement canvas = querySelector("#canvas");
Gamo gamo;

void main() {
  gamo = Gamo(canvas);
  gamo.stage.addObject(TestScene());
}