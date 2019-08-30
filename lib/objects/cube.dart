import 'package:gamo_dart/components/colordrawcomponent.dart';
import 'package:gamo_dart/components/primitivebuildcomponents.dart';
import 'package:gamo_dart/components/spincomponent.dart';
import 'package:gamo_dart/objects/gameobject.dart';
import 'package:gamo_dart/shaders/shader.dart';
import 'package:vector_math/vector_math.dart';

class Cube extends GameObject {
  Cube() {
    addComponent(SpinComponent(Quaternion.euler(10.0, 0.0, 0.0)));
    addComponent(SolidCubeBuildComponent());
    addComponent(ColorDrawComponent(DrawMode.triangles));
  }
}