import 'dart:web_gl';

import 'package:gamo_dart/components/gameobjectcomponent.dart';
import 'package:gamo_dart/shaders/shader.dart';
import 'package:vector_math/vector_math.dart';

class ColoredPointsDrawComponent extends GameObjectComponent {

  ColoredPointsDrawComponent();

  @override
  void onDraw(Shader shader, Matrix4 parentTransform) {
    Matrix4 transform = parentTransform * Matrix4.compose(
        parentObject.position, parentObject.orientation, parentObject.scale);
    shader.modelMatrix = transform;
    shader.draw(parentObject.vertexBuffer, DrawMode.points);
  }
}

class ColoredTrianglesDrawComponent extends GameObjectComponent {

  ColoredTrianglesDrawComponent();

  @override
  void onDraw(Shader shader, Matrix4 parentTransform) {
    Matrix4 transform = parentTransform * Matrix4.compose(
        parentObject.position, parentObject.orientation, parentObject.scale);
    shader.modelMatrix = transform;
    shader.draw(parentObject.vertexBuffer, DrawMode.triangles);
  }
}