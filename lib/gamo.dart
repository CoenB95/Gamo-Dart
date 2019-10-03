import 'dart:html';
import 'dart:web_gl';

import 'package:gamo_dart/stage.dart';
import 'package:vector_math/vector_math.dart';

class Gamo {
  final Stage stage;

  CanvasElement _canvas2d;
  CanvasElement _canvas3d;
  static CanvasRenderingContext2D _gl2d;
  static RenderingContext2 _gl3d;
  Set<int> _activeKeys = {};
  double _lastTime = -1;

  static CanvasRenderingContext2D get gl2d => _gl2d;
  static RenderingContext2 get gl3d => _gl3d;
  int get width => _canvas3d.width;
  int get height => _canvas3d.height;

  Gamo(this._canvas2d, this._canvas3d, this.stage) {
    _gl3d = _canvas3d.getContext('webgl2');
    _gl2d = _canvas2d.context2D;
    Vector4 color = Colors.purple;
    _gl2d.setFillColorRgb((color.r * 255).toInt(), (color.g * 255).toInt(), (color.b * 255).toInt());
    _gl2d.fillRect(0, 0, width / 2, height / 2);
    _gl2d.fillRect(width / 2, height / 2, width / 2, height / 2);
    color = Colors.black;
    _gl2d.setFillColorRgb((color.r * 255).toInt(), (color.g * 255).toInt(), (color.b * 255).toInt());
    _gl2d.fillRect(width / 2, 0, width / 2, height / 2);
    _gl2d.fillRect(0, height / 2, width / 2, height / 2);
    color = Colors.white;
    _gl2d.setFillColorRgb((color.r * 255).toInt(), (color.g * 255).toInt(), (color.b * 255).toInt());
    _gl2d.scale(10, 10);
    _gl2d.fillText('Test text', 10, 10);

    stage.init(_gl3d, width, height);

    // Hook into the window's onKeyDown and onKeyUp streams to track key states
    window.onKeyDown.listen((KeyboardEvent event) {
      _activeKeys.add(event.keyCode);
    });

    window.onKeyUp.listen((event) {
      _activeKeys.remove(event.keyCode);
    });

    buildThread();

    // Start off the infinite animation loop
    frame(0);
  }

  void buildThread() async {
    while(true) {
      stage.build();
      await Future.delayed(Duration(milliseconds: 10));
    }
  }

  /// This is the infinite animation loop; we request that the web browser
  /// call us back every time its ready for a new frame to be rendered. The [time]
  /// parameter is an increasing value based on when the animation loop started.
  void frame(time) {
    try {
      _lastTime = _lastTime < 0 ? time : _lastTime;
      double elapsedSeconds = (time - _lastTime) / 1000.0;
      _lastTime = time;

      stage.update(elapsedSeconds);

      // Basic viewport setup and clearing of the screen
      _gl3d.viewport(0, 0, width, height);
      _gl3d.clear(WebGL.COLOR_BUFFER_BIT | WebGL.DEPTH_BUFFER_BIT);
      _gl3d.enable(WebGL.DEPTH_TEST);
      _gl3d.disable(WebGL.BLEND);
      _gl3d.clearColor(0.0, 0.0, 0.0, 1.0);

      // Setup the perspective - you might be wondering why we do this every
      // time, and that will become clear in much later lessons. Just know, you
      // are not crazy for thinking of caching this.
      /*Shader.projectionMatrix =
        makePerspectiveMatrix(45.0, width / height, 0.1, 100.0);
    Shader.viewMatrix = Matrix4.identity();
    Shader.modelMatrix = Matrix4.identity();*/

      //TEMP! Should be on separate thread.
      //stage.build();

      stage.draw();

      window.animationFrame.then(frame);
    } on Error catch (e) {
      rethrow;
    }
  }

  /// Test if the given [KeyCode] is active.
  bool isPressed(int code) => _activeKeys.contains(code);
}