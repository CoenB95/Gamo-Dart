import 'dart:html';

import 'package:gamo_dart/gamo.dart';
import 'package:gamo_dart/scenes/testscene.dart';

CanvasElement canvas2D = querySelector("#canvas2D");
CanvasElement canvas3D = querySelector("#canvas3D");
Gamo gamo;

void main() {
  gamo = Gamo(canvas2D, canvas3D, TestScene());
}