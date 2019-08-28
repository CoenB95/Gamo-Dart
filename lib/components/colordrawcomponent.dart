import 'package:gamo_gl/components/gameobjectcomponent.dart';
import 'package:gamo_gl/gl/shader.dart';
import 'package:gamo_gl/gl/vertex.dart';

class ColorDrawComponent<T extends Vertex> extends GameObjectComponent<T> {
  DrawMode drawMode;

  ArrayBuffer<T> _buffer;

  ColorDrawComponent(this.drawMode);

  @override
  void onDraw() {
    if (_buffer == null) {
      _buffer = ArrayBuffer(ShaderProgram.active.gl, drawMode);
    }
    _buffer.setData(parentObject.vertices);
    ShaderProgram.active.draw(_buffer);
  }
}