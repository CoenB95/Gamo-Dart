import 'package:gamo_dart/gamo.dart';
import 'package:gamo_dart/shaders/shader.dart';
import 'package:gamo_dart/shaders/texture.dart';
import 'package:gamo_dart/shaders/vertex.dart';
import 'package:vector_math/vector_math.dart';

import 'gameobjectcomponent.dart';

class TextureDrawComponent extends GameObjectComponent {
  //DrawMode drawMode;
  Texture texture;
  //ArrayBuffer _buffer;

  TextureDrawComponent() {
    texture = Textures.loadTextureFromCanvas(Gamo.gl3d, Gamo.gl2d.canvas);
  }

  @override
  void onDraw(Shader shader, Matrix4 transform) {
    /*if (_buffer == null) {
      _buffer = ArrayBuffer(Gamo.gl3d, drawMode);
    }

    if (parentObject.vertices.isEmpty) {
      return;
    }

    Vertex v = parentObject.vertices.firstWhere((v) => !(v is VertexP3T2),
        orElse: () {
          return;
        });
    if (v != null) {
      throw StateError('Tryed to draw a ${v.runtimeType.toString()} as a P3T2');
    }*/
    texture.bind(Gamo.gl3d);
    //_buffer.setData(parentObject.vertices);

    Matrix4 innerTransform = transform * Matrix4.compose(
        parentObject.position, parentObject.orientation, parentObject.scale);
    shader.modelMatrix = innerTransform;
    shader.draw(parentObject.vertexBuffer);
  }
}
