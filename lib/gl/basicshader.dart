import 'dart:web_gl';

import 'package:gamo_gl/gl/vertex.dart';
import 'package:gamo_gl/gl/shader.dart';

class BasicShader extends ShaderProgram<VertexP3C4> {
  final Matrix4Uniform modelViewMatrix = Matrix4Uniform('uMVMatrix');
  final Matrix4Uniform perspectiveMatrix = Matrix4Uniform('uPMatrix');

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

  BasicShader(RenderingContext gl) : super(gl) {
    init(_vertSrc, _fragSrc, [_location, _color],
        [modelViewMatrix, perspectiveMatrix]);
  }
}