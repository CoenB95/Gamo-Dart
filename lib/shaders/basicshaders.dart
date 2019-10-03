import 'dart:web_gl' as gl;

import 'package:gamo_dart/shaders/shader.dart';

class ShaderP3C4 extends Shader {
  final Matrix4Uniform _modelViewMatrix = Matrix4Uniform('uMVMatrix');
  final Matrix4Uniform _perspectiveMatrix = Matrix4Uniform('uPMatrix');
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
              gl_PointSize = 10.0;
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

  ShaderP3C4(gl.RenderingContext2 gl) : super(gl) {
    _modelViewMatrix.bindValue = () => modelViewMatrix;
    _perspectiveMatrix.bindValue = () => projectionMatrix;
    init(_vertSrc, _fragSrc, [_location, _color],
        [_modelViewMatrix, _perspectiveMatrix]);
  }
}

class ShaderP3T2 extends Shader {
  final Uniform _modelViewMatrix = Matrix4Uniform('uMVMatrix');
  final Uniform _perspectiveMatrix = Matrix4Uniform('uPMatrix');
  final Uniform _textureSampler = IntegerUniform('uTextureSampler');
  final Attribute _location = Attribute('aVertexPosition', 3);
  final Attribute _texCoord = Attribute('aVertexTexCoord', 2);

  final String _vertSrc = '''
          attribute vec3 aVertexPosition;
          attribute vec2 aVertexTexCoord;
          uniform mat4 uMVMatrix;
          uniform mat4 uPMatrix;
          varying vec2 vVertexTexCoord;
          void main(void) {
              gl_Position = uPMatrix * uMVMatrix * vec4(aVertexPosition, 1.0);
              vVertexTexCoord = aVertexTexCoord;
          }
        ''';
  final String _fragSrc = '''
          precision mediump float;
          uniform sampler2D uTextureSampler;
          varying vec2 vVertexTexCoord;
          void main(void) {
              gl_FragColor = texture2D(uTextureSampler, vVertexTexCoord);
          }
        ''';

  ShaderP3T2(gl.RenderingContext2 gl) : super(gl) {
    _modelViewMatrix.bindValue = () => modelViewMatrix;
    _perspectiveMatrix.bindValue = () => projectionMatrix;
    init(_vertSrc, _fragSrc, [_location, _texCoord],
        [_modelViewMatrix, _perspectiveMatrix, _textureSampler]);
  }
}