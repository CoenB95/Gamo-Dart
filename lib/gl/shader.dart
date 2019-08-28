import 'dart:typed_data';
import 'dart:web_gl';

import 'package:gamo_gl/gl/vertex.dart';
import 'package:vector_math/vector_math.dart';

enum DrawMode {
  triangles,
  triangleStrip
}

class Attribute {
  final String name;
  int id;
  int size;
  int type;
  int get bytes {
    switch (type) {
      case WebGL.FLOAT: return 4;
      default: return 0;
    }
  }

  Attribute(this.name, this.size, [this.type = WebGL.FLOAT]);
}

abstract class Uniform<T> {
  final String name;
  UniformLocation id;
  T value;

  Uniform(this.name, this.value);

  void _update(RenderingContext gl);
}

class Matrix4Uniform extends Uniform<Matrix4> {
  Matrix4Uniform(String name) : super(name, Matrix4.identity());

  @override
  void _update(RenderingContext gl) =>
      gl.uniformMatrix4fv(id, false, value.storage);
}

class ArrayBuffer<T extends Vertex> {
  Buffer _buffer;
  RenderingContext _gl;
  Float32List _data;

  final DrawMode mode;
  int get length => _data.length;

  ArrayBuffer(this._gl, this.mode, [Iterable<T> data]) {
    if (data != null) {
      setData(data);
    }
  }

  void _bind() {
    if (_buffer == null) {
      return;
    }
    _gl.bindBuffer(WebGL.ARRAY_BUFFER, _buffer);
  }

  void setData(Iterable<T> data) {
    if (_buffer == null) {
      _buffer = _gl.createBuffer();
    }
    _bind();
    _data = data.map((t) => t.storage()).reduce((l1, l2) => Float32List.fromList(l1 + l2));
    _gl.bufferData(
        WebGL.ARRAY_BUFFER,
        _data,
        WebGL.STATIC_DRAW);
  }

  void _draw() {
    switch (mode) {
      case DrawMode.triangles:
        _gl.drawArrays(WebGL.TRIANGLES, 0, length);
        break;
      case DrawMode.triangleStrip:
        _gl.drawArrays(WebGL.TRIANGLE_STRIP, 0, length);
        break;
      default:
        break;
    }
  }
}

class ShaderProgram<T extends Vertex> {
  static ShaderProgram active;

  RenderingContext gl;

  List<Attribute> _attributes = [];
  List<Uniform> _uniforms = [];
  Program _program;
  Shader _fragShader, _vertShader;

  ShaderProgram(this.gl);

  void init(String vertSrc, String fragSrc,
      List<Attribute> attributes, List<Uniform> uniforms) {
    _attributes.addAll(attributes);
    _uniforms.addAll(uniforms);

    _fragShader = gl.createShader(WebGL.FRAGMENT_SHADER);
    gl.shaderSource(_fragShader, fragSrc);
    gl.compileShader(_fragShader);

    _vertShader = gl.createShader(WebGL.VERTEX_SHADER);
    gl.shaderSource(_vertShader, vertSrc);
    gl.compileShader(_vertShader);

    _program = gl.createProgram();
    gl.attachShader(_program, _vertShader);
    gl.attachShader(_program, _fragShader);
    gl.linkProgram(_program);

    if (!gl.getProgramParameter(_program, WebGL.LINK_STATUS)) {
      print("Could not initialise shaders");
    }

    for (Attribute attrib in attributes) {
      int attributeLocation = gl.getAttribLocation(_program, attrib.name);
      gl.enableVertexAttribArray(attributeLocation);
      attrib.id = attributeLocation;
    }

    for (Uniform uniform in uniforms) {
      UniformLocation uniformLocation = gl.getUniformLocation(_program, uniform.name);
      uniform.id = uniformLocation;
    }
  }

  void draw(ArrayBuffer<T> buffer) {
    buffer._bind();
    _bindAttributeBuffer();
    _updateUniforms();
    buffer._draw();
  }

  void _bindAttributeBuffer() {
    int attributeStride = _attributes.fold(0, (p, e) => p + e.size * e.bytes);
    int attributeOffset = 0;

    for (Attribute attribute in _attributes) {
      gl.vertexAttribPointer(attribute.id, attribute.size, WebGL.FLOAT, false,
          attributeStride, attributeOffset);
      attributeOffset += attribute.size * attribute.bytes;
    }
  }

  void _updateUniforms() {
    for (Uniform uniform in _uniforms) {
      uniform._update(gl);
    }
  }

  void use() {
    gl.useProgram(_program);
    active = this;
  }
}
