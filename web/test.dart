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
  //Matrix4 pMatrix;
  //Matrix4 mvMatrix;

  ArrayBuffer<VertexP3C4> triangleBuffer, squareBuffer;

  Lesson1(this.gl) {
    /*program = new ShaderProgram(gl,
      '''
          precision mediump float;
          varying vec4 color;
          void main(void) {
              gl_FragColor = color;
          }
        ''',
      '''
          attribute vec3 aVertexPosition;
          attribute vec4 aVertexColor;
          uniform mat4 uMVMatrix;
          uniform mat4 uPMatrix;
          varying vec4 color;
          void main(void) {
              gl_Position = uPMatrix * uMVMatrix * vec4(aVertexPosition, 1.0);
              color = aVertexColor;
          }
        ''',
      ['aVertexPosition', 'aVertexColor'],
      ['uMVMatrix', 'uPMatrix'],
    );
    gl.useProgram(program.program);*/
    shader = BasicShader(gl);
    shader.use();

    /*// Allocate and build the two buffers we need to draw a triangle and box.
    // createBuffer() asks the WebGL system to allocate some data for us
    triangleVertexPositionBuffer = gl.createBuffer();

    // bindBuffer() tells the WebGL system the target of future calls
    gl.bindBuffer(WebGL.ARRAY_BUFFER, triangleVertexPositionBuffer);
    gl.bufferData(
        WebGL.ARRAY_BUFFER,
        new Float32List.fromList(
            [0.0, 1.0, 0.0, 1.0, 0.0, 0.0, 1.0,
              -1.0, -1.0, 0.0, 0.0, 1.0, 0.0, 1.0,
              1.0, -1.0, 0.0, 0.0, 0.0, 1.0, 1.0]),
        WebGL.STATIC_DRAW);*/
    triangleBuffer = ArrayBuffer<VertexP3C4>(gl, DrawMode.triangles, [
      VertexP3C4(Vector3( 0,  1, 0), Colors.red),
      VertexP3C4(Vector3(-1, -1, 0), Colors.green),
      VertexP3C4(Vector3( 1, -1, 0), Colors.blue)
    ]);

    /*squareVertexPositionBuffer = gl.createBuffer();
    gl.bindBuffer(WebGL.ARRAY_BUFFER, squareVertexPositionBuffer);
    gl.bufferData(
        WebGL.ARRAY_BUFFER,
        new Float32List.fromList(
            [1.0, 1.0, 0.0, 1.0, 1.0, 1.0, 1.0,
              -1.0, 1.0, 0.0, 1.0, 1.0, 1.0, 1.0,
              1.0, -1.0, 0.0, 1.0, 1.0, 1.0, 1.0,
              -1.0, -1.0, 0.0, 1.0, 1.0, 1.0, 1.0]),
        WebGL.STATIC_DRAW);*/

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
    //pMatrix = makePerspectiveMatrix(45.0, aspect, 0.1, 100.0);
    //mvMatrix = Matrix4.identity();
    shader.perspectiveMatrix.value = makePerspectiveMatrix(45.0, aspect, 0.1, 100.0);
    shader.modelViewMatrix.value = Matrix4.identity();

    // First stash the current model view matrix before we start moving around.
    mvPushMatrix();

    //mvMatrix.translate(-1.5, 0.0, -7.0);
    shader.modelViewMatrix.value.translate(-1.5, 0.0, -7.0);

    /*// Here's that bindBuffer() again, as seen in the constructor
    //gl.bindBuffer(WebGL.ARRAY_BUFFER, triangleVertexPositionBuffer);
    // Set the vertex attribute to the size of each individual element (x,y,z)
    triangleBuffer.bind();
    gl.vertexAttribPointer(
        program.attributes['aVertexPosition'], 3, WebGL.FLOAT, false, 7*4, 0);
    gl.vertexAttribPointer(
        program.attributes['aVertexColor'], 4, WebGL.FLOAT, false, 7*4, 3*4);
    setMatrixUniforms();
    // Now draw 3 vertices
    //gl.drawArrays(WebGL.TRIANGLES, 0, 3);
    triangleBuffer.draw();*/
    shader.draw(triangleBuffer);

    // Move 3 units to the right
    //mvMatrix.translate(3.0, 0.0, 0.0);
    shader.modelViewMatrix.value.translate(3.0, 0.0, 0.0);

    /*// And get ready to draw the square just like we did the triangle...
    //gl.bindBuffer(WebGL.ARRAY_BUFFER, squareVertexPositionBuffer);
    squareBuffer.bind();
    gl.vertexAttribPointer(
        program.attributes['aVertexPosition'], 3, WebGL.FLOAT, false, 7*4, 0);
    gl.vertexAttribPointer(
        program.attributes['aVertexColor'], 4, WebGL.FLOAT, false, 7*4, 3*4);
    setMatrixUniforms();
    // Except now draw 2 triangles, re-using the vertices found in the buffer.
    //gl.drawArrays(WebGL.TRIANGLE_STRIP, 0, 4);
    squareBuffer.draw();*/
    shader.draw(squareBuffer);

    // Finally, reset the matrix back to what it was before we moved around.
    mvPopMatrix();
  }

  /*/// Write the matrix uniforms (model view matrix and perspective matrix) so
  /// WebGL knows what to do with them.
  setMatrixUniforms() {
    gl.uniformMatrix4fv(program.uniforms['uPMatrix'], false, pMatrix.storage);
    gl.uniformMatrix4fv(program.uniforms['uMVMatrix'], false, mvMatrix.storage);
  }*/

  void animate(num now) {
    // We're not animating the scene, but if you want to experiment, here's
    // where you get to play around.
  }

  void handleKeys() {
    // We're not handling keys right now, but if you want to experiment, here's
    // where you'd get to play around.
  }
}