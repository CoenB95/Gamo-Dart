import 'dart:async';
import 'dart:html';
import 'dart:web_gl';

import 'package:vector_math/vector_math.dart';

import 'test.dart';

CanvasElement canvas = querySelector("#canvas");
RenderingContext gl;
Lesson1 lesson;

void main() {
  mvMatrix = new Matrix4.identity();
  // Nab the context we'll be drawing to.
  gl = canvas.getContext3d();
  lesson = new Lesson1(gl);
  if (gl == null) {
    return;
  }

  // Set the fill color to black
  gl.clearColor(0, 0, 0, 1.0);

  // Hook into the window's onKeyDown and onKeyUp streams to track key states
  window.onKeyDown.listen((KeyboardEvent event) {
    currentlyPressedKeys.add(event.keyCode);
  });

  window.onKeyUp.listen((event) {
    currentlyPressedKeys.remove(event.keyCode);
  });

  // Start off the infinite animation loop
  tick(0);
}

/// This is the infinite animation loop; we request that the web browser
/// call us back every time its ready for a new frame to be rendered. The [time]
/// parameter is an increasing value based on when the animation loop started.
tick(time) {
  window.animationFrame.then(tick);
  /*if (trackFrameRate) frameCount(time);
  lesson.handleKeys();
  lesson.animate(time);*/
  lesson.drawScene(canvas.width, canvas.height, canvas.width / canvas.height);

}

/// The global key-state map.
Set<int> currentlyPressedKeys = new Set<int>();

/// Test if the given [KeyCode] is active.
bool isActive(int code) => currentlyPressedKeys.contains(code);

/// Test if any of the given [KeyCode]s are active, returning true.
bool anyActive(List<int> codes) {
  return codes.firstWhere((code) => currentlyPressedKeys.contains(code),
      orElse: () => null) !=
      null;
}



Map urlParameters = {};

/// Perspective matrix
Matrix4 pMatrix;

/// Model-View matrix.
Matrix4 mvMatrix;

List<Matrix4> mvStack = new List<Matrix4>();

/// Add a copy of the current Model-View matrix to the the stack for future
/// restoration.
mvPushMatrix() => mvStack.add(mvMatrix.clone());

/// Pop the last matrix off the stack and set the Model View matrix.
mvPopMatrix() => mvMatrix = mvStack.removeLast();

/// Handle common keys through callbacks, making lessons a little easier to code
void handleDirection({up(), down(), left(), right()}) {
  if (left != null && anyActive([KeyCode.A, KeyCode.LEFT])) {
    left();
  }
  if (right != null && anyActive([KeyCode.D, KeyCode.RIGHT])) {
    right();
  }
  if (down != null && anyActive([KeyCode.S, KeyCode.DOWN])) {
    down();
  }
  if (up != null && anyActive([KeyCode.W, KeyCode.UP])) {
    up();
  }
}

/// Load the given image at [url] and call [handle] to execute some GL code.
/// Return a [Future] to asynchronously notify when the texture is complete.
Future<Texture> loadTexture(String url, handle(Texture tex, ImageElement ele)) {
  var completer = new Completer<Texture>();
  var texture = gl.createTexture();
  var element = new ImageElement();
  element.onLoad.listen((e) {
    handle(texture, element);
    completer.complete(texture);
  });
  element.src = url;
  return completer.future;
}

/// This is a common handler for [loadTexture]. It will be explained in future
/// lessons that require textures.
void handleMipMapTexture(Texture texture, ImageElement image) {
  gl.pixelStorei(WebGL.UNPACK_FLIP_Y_WEBGL, 1);
  gl.bindTexture(WebGL.TEXTURE_2D, texture);
  gl.texImage2D(
    WebGL.TEXTURE_2D,
    0,
    WebGL.RGBA,
    WebGL.RGBA,
    WebGL.UNSIGNED_BYTE,
    image,
  );
  gl.texParameteri(
    WebGL.TEXTURE_2D,
    WebGL.TEXTURE_MAG_FILTER,
    WebGL.LINEAR,
  );
  gl.texParameteri(
    WebGL.TEXTURE_2D,
    WebGL.TEXTURE_MIN_FILTER,
    WebGL.LINEAR_MIPMAP_NEAREST,
  );
  gl.generateMipmap(WebGL.TEXTURE_2D);
  gl.bindTexture(WebGL.TEXTURE_2D, null);
}