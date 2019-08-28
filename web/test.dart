import 'dart:web_gl';

import 'package:gamo_gl/gl/basicshader.dart';
import 'package:gamo_gl/gl/vertex.dart';
import 'package:gamo_gl/gl/shader.dart';
import 'package:vector_math/vector_math.dart';

import 'main.dart';

/// Staticly draw a triangle and a square!
class Lesson1 {
  BasicShader shader;
  RenderingContext gl;

  ArrayBuffer<VertexP3C4> triangleBuffer, squareBuffer;

  Lesson1(this.gl) {
    shader = BasicShader(gl);
    shader.use();

    // Allocate and build the two buffers we need to draw a triangle and box.
    // createBuffer() asks the WebGL system to allocate some data for us
    triangleBuffer = ArrayBuffer<VertexP3C4>(gl, DrawMode.triangles, [
      VertexP3C4(Vector3( 0,  1, 0), Colors.red),
      VertexP3C4(Vector3(-1, -1, 0), Colors.green),
      VertexP3C4(Vector3( 1, -1, 0), Colors.blue)
    ]);

    squareBuffer = ArrayBuffer<VertexP3C4>(gl, DrawMode.triangleStrip, [
      VertexP3C4(Vector3( 1,  1, 0), Colors.green),
      VertexP3C4(Vector3(-1,  1, 0), Colors.white),
      VertexP3C4(Vector3( 1, -1, 0), Colors.white),
      VertexP3C4(Vector3(-1, -1, 0), Colors.white)
    ]);

    // Specify the color to clear with (black with 100% alpha) and then enable
    // depth testing.
    gl.clearColor(0.0, 0.0, 0.0, 1.0);
  }

  void drawScene(num viewWidth, num viewHeight, num aspect) {
    // Basic viewport setup and clearing of the screen
    gl.viewport(0, 0, viewWidth, viewHeight);
    gl.clear(WebGL.COLOR_BUFFER_BIT | WebGL.DEPTH_BUFFER_BIT);
    gl.enable(WebGL.DEPTH_TEST);
    gl.disable(WebGL.BLEND);

    // Setup the perspective - you might be wondering why we do this every
    // time, and that will become clear in much later lessons. Just know, you
    // are not crazy for thinking of caching this.
    shader.perspectiveMatrix.value = makePerspectiveMatrix(45.0, aspect, 0.1, 100.0);
    shader.modelViewMatrix.value = Matrix4.identity();

    // First stash the current model view matrix before we start moving around.
    mvPushMatrix();

    shader.modelViewMatrix.value.translate(-1.5, 0.0, -7.0);
    shader.draw(triangleBuffer);

    // Move 3 units to the right
    shader.modelViewMatrix.value.translate(3.0, 0.0, 0.0);

    // And get ready to draw the square just like we did the triangle...
    // Except now draw 2 triangles, re-using the vertices found in the buffer.
    shader.draw(squareBuffer);

    // Finally, reset the matrix back to what it was before we moved around.
    mvPopMatrix();
  }

  void animate(num now) {
    // We're not animating the scene, but if you want to experiment, here's
    // where you get to play around.
  }

  void handleKeys() {
    // We're not handling keys right now, but if you want to experiment, here's
    // where you'd get to play around.
  }
}