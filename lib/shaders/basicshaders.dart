import 'dart:web_gl';

import 'package:gamo_dart/shaders/shader.dart';

class ShaderP3C4 extends ShaderProgram {
  final Matrix4Uniform _modelViewMatrix = Matrix4Uniform('uMVMatrix', () => ShaderProgram.modelViewMatrix);
  final Matrix4Uniform _perspectiveMatrix = Matrix4Uniform('uPMatrix', () => ShaderProgram.projectionMatrix);
  final Attribute _location = Attribute('aVertexPosition', 3);
  final Attribute _color = Attribute('aVertexColor', 4);

  final String _vertSrc = '''
          attribute vec3 aVertexPosition;
          attribute vec4 aVertexColor;
          uniform mat4 uMVMatrix;
          uniform mat4 uPMatrix;
          varying vec4 color;
          void main(void) {
              gl_Position = uPMatrix * uMVMatrix * vec4(aVertexPosition, 1.0);
              color = aVertexColor;
          }
        ''';
  final String _fragSrc = '''
          precision mediump float;
          varying vec4 color;
          void main(void) {
              gl_FragColor = color;
          }
        ''';

  ShaderP3C4(RenderingContext gl) : super(gl) {
    init(_vertSrc, _fragSrc, [_location, _color],
        [_modelViewMatrix, _perspectiveMatrix]);
  }
}