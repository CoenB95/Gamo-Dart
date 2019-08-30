import 'package:gamo_dart/components/gameobjectcomponent.dart';
import 'package:gamo_dart/shaders/shader.dart';
import 'package:gamo_dart/shaders/vertex.dart';
import 'package:vector_math/vector_math.dart';

class ColorDrawComponent extends GameObjectComponent {
  DrawMode drawMode;

  ArrayBuffer _buffer;

  ColorDrawComponent(this.drawMode);

  @override
  void onDraw(Matrix4 transform) {
    ShaderProgram.shaderP3C4.use();
    if (_buffer == null) {
      _buffer = ArrayBuffer(ShaderProgram.shaderP3C4.gl, drawMode);
    }
    if (parentObject.vertices.isEmpty) {
      return;
    }
    Vertex v = parentObject.vertices.firstWhere((v) => !(v is VertexP3C4),
        orElse: () {
          return;
        });
    if (v != null) {
      throw StateError('Tryed to draw a ${v.runtimeType.toString()} as a P3C4');
    }
    _buffer.setData(parentObject.vertices);
    ShaderProgram.modelMatrix = transform;
    ShaderProgram.active.draw(_buffer);
  }
}