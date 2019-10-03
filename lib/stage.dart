import 'dart:web_gl' as gl;

import 'package:gamo_dart/objects/gameobjectgroup.dart';
import 'package:gamo_dart/shaders/basicshaders.dart';
import 'package:gamo_dart/shaders/shader.dart';
import 'package:vector_math/vector_math.dart';

abstract class Stage {
  GameObjectGroup colored = GameObjectGroup.embedded();
  GameObjectGroup textured = GameObjectGroup.embedded();

  int width;
  int height;

  Shader _coloredShader;
  Shader _texturedShader;

  void init(gl.RenderingContext2 context, int width, int height) {
    _coloredShader = ShaderP3C4(context);
    _texturedShader = ShaderP3T2(context);
    this.width = width;
    this.height = height;

    onStart();
  }

  void onUpdate(double elapsedSeconds);
  void onStart();

  void build() {
    colored.build();
    textured.build();
  }

  void draw() {
    _coloredShader.use();
    _coloredShader.projectionMatrix = makePerspectiveMatrix(45.0, width / height, 0.1, 100.0);
    _coloredShader.viewMatrix = Matrix4.identity();
    _coloredShader.modelMatrix = Matrix4.identity();
    colored.draw(_coloredShader);

    _texturedShader.use();
    _texturedShader.projectionMatrix = makePerspectiveMatrix(45.0, width / height, 0.1, 100.0);
    _texturedShader.viewMatrix = Matrix4.identity();
    _texturedShader.modelMatrix = Matrix4.identity();
    textured.draw(_texturedShader);
  }

  void update(double elapsedSeconds) {
    onUpdate(elapsedSeconds);
    colored.update(elapsedSeconds);
    textured.update(elapsedSeconds);
  }
}