import 'dart:typed_data';
import 'dart:web_gl' as gl;

import 'package:gamo_dart/shaders/basicshaders.dart';
import 'package:gamo_dart/shaders/vertex.dart';
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
      case gl.WebGL.FLOAT: return 4;
      default: return 0;
    }
  }

  Attribute(this.name, this.size, [this.type = gl.WebGL.FLOAT]);
}

abstract class Uniform<T> {
  final String name;
  gl.UniformLocation id;
  T value;
  T Function() bindValue;

  Uniform(this.name, this.value, [this.bindValue]);

  void _update(gl.RenderingContext gl);
}

class Matrix4Uniform extends Uniform<Matrix4> {
  Matrix4Uniform(String name, [Matrix4 Function() valueBind]) : super(name, Matrix4.identity(), valueBind);

  @override
  void _update(gl.RenderingContext gl) {
    if (bindValue != null) {
      value = bindValue();
    }

    if (value != null) {
      gl.uniformMatrix4fv(id, false, value.storage);
    }
  }
}

class IntegerUniform extends Uniform<int> {
  IntegerUniform(String name, [int Function() valueBind]) : super(name, 0, valueBind);

  @override
  void _update(gl.RenderingContext gl) {
    if (bindValue != null) {
      value = bindValue();
    }

    if (value != null) {
      gl.uniform1i(id, value);
    }
  }
}

class ArrayBuffer {
  gl.Buffer _buffer;
  gl.RenderingContext _gl;
  Float32List _data;

  final DrawMode mode;
  int get length => _data.length;

  ArrayBuffer(this._gl, this.mode, [Iterable<Vertex> data]) {
    if (data != null) {
      setData(data);
    }
  }

  void _bind() {
    if (_buffer == null) {
      return;
    }
    _gl.bindBuffer(gl.WebGL.ARRAY_BUFFER, _buffer);
  }

  void setData(Iterable<Vertex> data) {
    if (_buffer == null) {
      _buffer = _gl.createBuffer();
    }
    _bind();
    _data = data.map((t) => t.storage()).reduce((l1, l2) => Float32List.fromList(l1 + l2));
    _gl.bufferData(
        gl.WebGL.ARRAY_BUFFER,
        _data,
        gl.WebGL.STATIC_DRAW);
  }

  void _draw() {
    switch (mode) {
      case DrawMode.triangles:
        _gl.drawArrays(gl.WebGL.TRIANGLES, 0, length);
        break;
      case DrawMode.triangleStrip:
        _gl.drawArrays(gl.WebGL.TRIANGLE_STRIP, 0, length);
        break;
      default:
        break;
    }
  }
}

class Texture {
  gl.Texture id;

  void bind(gl.RenderingContext context) {
    context.bindTexture(gl.WebGL.TEXTURE_2D, id);
  }
}

class Shader {
  Matrix4 modelMatrix = Matrix4.identity();
  Matrix4 viewMatrix = Matrix4.identity();
  Matrix4 projectionMatrix = Matrix4.identity();
  Matrix4 get modelViewMatrix => viewMatrix * modelMatrix;

  gl.RenderingContext _context;

  List<Attribute> _attributes = [];
  List<Uniform> _uniforms = [];
  gl.Program _program;
  gl.Shader _fragShader, _vertShader;

  Shader(this._context);

  void init(String vertSrc, String fragSrc,
      List<Attribute> attributes, List<Uniform> uniforms) {
    _attributes.addAll(attributes);
    _uniforms.addAll(uniforms);

    _fragShader = _context.createShader(gl.WebGL.FRAGMENT_SHADER);
    _context.shaderSource(_fragShader, fragSrc);
    _context.compileShader(_fragShader);

    _vertShader = _context.createShader(gl.WebGL.VERTEX_SHADER);
    _context.shaderSource(_vertShader, vertSrc);
    _context.compileShader(_vertShader);

    _program = _context.createProgram();
    _context.attachShader(_program, _vertShader);
    _context.attachShader(_program, _fragShader);
    _context.linkProgram(_program);

    if (!_context.getProgramParameter(_program, gl.WebGL.LINK_STATUS)) {
      print("Could not initialise shaders");
    }

    for (Attribute attrib in attributes) {
      int attributeLocation = _context.getAttribLocation(_program, attrib.name);
      _context.enableVertexAttribArray(attributeLocation);
      attrib.id = attributeLocation;
    }

    for (Uniform uniform in uniforms) {
      gl.UniformLocation uniformLocation = _context.getUniformLocation(_program, uniform.name);
      uniform.id = uniformLocation;
    }
  }

  void draw(ArrayBuffer buffer) {
    buffer._bind();
    _bindAttributeBuffer();
    _updateUniforms();
    buffer._draw();
  }

  void _bindAttributeBuffer() {
    int attributeStride = _attributes.fold(0, (p, e) => p + e.size * e.bytes);
    int attributeOffset = 0;

    for (Attribute attribute in _attributes) {
      _context.vertexAttribPointer(attribute.id, attribute.size, gl.WebGL.FLOAT, false,
          attributeStride, attributeOffset);
      attributeOffset += attribute.size * attribute.bytes;
    }
  }

  void _updateUniforms() {
    for (Uniform uniform in _uniforms) {
      uniform._update(_context);
    }
  }

  void use() {
    _context.useProgram(_program);
  }
}
