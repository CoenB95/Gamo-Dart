import 'package:gamo_gl/components/colordrawcomponent.dart';
import 'package:gamo_gl/components/primitivebuildcomponents.dart';
import 'package:gamo_gl/components/spincomponent.dart';
import 'package:gamo_gl/gl/shader.dart';
import 'package:gamo_gl/objects/gameobject.dart';
import 'package:vector_math/vector_math.dart';

class Cube extends GameObject {
  Cube() {
    addComponent(SpinComponent(Quaternion.euler(10.0, 0.0, 0.0)));
    addComponent(SolidCubeBuildComponent());
    addComponent(ColorDrawComponent(DrawMode.triangles));
  }
}