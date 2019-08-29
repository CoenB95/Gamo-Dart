import 'package:gamo_gl/components/gameobjectcomponent.dart';
import 'package:gamo_gl/gl/shader.dart';
import 'package:vector_math/vector_math.dart';

class ColorDrawComponent extends GameObjectComponent {
  DrawMode drawMode;

  ArrayBuffer _buffer;

  ColorDrawComponent(this.drawMode);

  @override
  void onDraw() {
    if (_buffer == null) {
      _buffer = ArrayBuffer(ShaderProgram.active.gl, drawMode);
    }
    if (parentObject.vertices.isEmpty) {
      return;
    }
    _buffer.setData(parentObject.vertices);
    ShaderProgram.modelMatrix = Matrix4.compose(
        parentObject.position, parentObject.orientation, parentObject.scale);
    ShaderProgram.active.draw(_buffer);
  }
}