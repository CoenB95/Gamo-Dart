import 'package:gamo_dart/components/colordrawcomponent.dart';
import 'package:gamo_dart/components/primitivebuildcomponents.dart';
import 'package:gamo_dart/components/spincomponent.dart';
import 'package:gamo_dart/components/texturedrawcomponent.dart';
import 'package:gamo_dart/objects/gameobject.dart';
import 'package:gamo_dart/shaders/shader.dart';
import 'package:vector_math/vector_math.dart';

class Cube extends GameObject {
  Cube({double size = 1, Vector4 color}) {
    addComponent(SpinComponent(Quaternion.euler(10.0, 0.0, 0.0)));
    addComponent(SolidCubeBuildComponent(
        width: size,
        height: size,
        depth: size,
        color: color,
    ));
    addComponent(ColorDrawComponent());
  }

  Cube.textured({double size = 1, Vector4 color}) {
    addComponent(SpinComponent(Quaternion.euler(10.0, 0.0, 0.0)));
    addComponent(TexturedCubeBuildComponent(
      width: size,
      height: size,
      depth: size,
    ));
    addComponent(TextureDrawComponent());
  }
}