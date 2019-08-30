import 'dart:async';
import 'dart:html';
import 'dart:web_gl';

import 'package:gamo_dart/objects/gameobjectgroup.dart';
import 'package:gamo_dart/shaders/shader.dart';
import 'package:vector_math/vector_math.dart';

class Gamo {
  final GameObjectGroup stage = GameObjectGroup();

  CanvasElement _canvas;
  RenderingContext _gl;
  Set<int> _activeKeys = {};
  double _lastTime = -1;

  Gamo(this._canvas) {
    _gl = _canvas.getContext3d();
    ShaderProgram.initShaders(_gl);

    // Hook into the window's onKeyDown and onKeyUp streams to track key states
    window.onKeyDown.listen((KeyboardEvent event) {
      _activeKeys.add(event.keyCode);
    });

    window.onKeyUp.listen((event) {
      _activeKeys.remove(event.keyCode);
    });

    // Start off the infinite animation loop
    frame(0);
  }

  /// This is the infinite animation loop; we request that the web browser
  /// call us back every time its ready for a new frame to be rendered. The [time]
  /// parameter is an increasing value based on when the animation loop started.
  void frame(time) {
    window.animationFrame.then(frame);

    _lastTime = _lastTime < 0 ? time : _lastTime;
    double elapsedSeconds = (time - _lastTime) / 1000.0;
    _lastTime = time;

    stage.update(elapsedSeconds);

    // Basic viewport setup and clearing of the screen
    _gl.viewport(0, 0, _canvas.width, _canvas.height);
    _gl.clear(WebGL.COLOR_BUFFER_BIT | WebGL.DEPTH_BUFFER_BIT);
    _gl.enable(WebGL.DEPTH_TEST);
    _gl.disable(WebGL.BLEND);
    _gl.clearColor(0.0, 0.0, 0.0, 1.0);

    // Setup the perspective - you might be wondering why we do this every
    // time, and that will become clear in much later lessons. Just know, you
    // are not crazy for thinking of caching this.
    ShaderProgram.projectionMatrix =
        makePerspectiveMatrix(45.0, _canvas.width / _canvas.height, 0.1, 100.0);
    ShaderProgram.viewMatrix = Matrix4.identity();
    ShaderProgram.modelMatrix = Matrix4.identity();

    //TEMP! Should be on separate thread.
    stage.build();

    stage.draw(Matrix4.identity());
  }

  /// Test if the given [KeyCode] is active.
  bool isPressed(int code) => _activeKeys.contains(code);

  /// Load the given image at [url] and call [handle] to execute some GL code.
  /// Return a [Future] to asynchronously notify when the texture is complete.
  Future<Texture> loadTexture(String url,
      handle(Texture tex, ImageElement ele)) {
    var completer = Completer<Texture>();
    var texture = _gl.createTexture();
    var element = ImageElement();
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
    _gl.pixelStorei(WebGL.UNPACK_FLIP_Y_WEBGL, 1);
    _gl.bindTexture(WebGL.TEXTURE_2D, texture);
    _gl.texImage2D(
      WebGL.TEXTURE_2D,
      0,
      WebGL.RGBA,
      WebGL.RGBA,
      WebGL.UNSIGNED_BYTE,
      image,
    );
    _gl.texParameteri(
      WebGL.TEXTURE_2D,
      WebGL.TEXTURE_MAG_FILTER,
      WebGL.LINEAR,
    );
    _gl.texParameteri(
      WebGL.TEXTURE_2D,
      WebGL.TEXTURE_MIN_FILTER,
      WebGL.LINEAR_MIPMAP_NEAREST,
    );
    _gl.generateMipmap(WebGL.TEXTURE_2D);
    _gl.bindTexture(WebGL.TEXTURE_2D, null);
  }
}