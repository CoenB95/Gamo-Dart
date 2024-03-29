import 'package:gamo_dart/components/gameobjectcomponent.dart';
import 'package:gamo_dart/shaders/vertex.dart';
import 'package:vector_math/vector_math.dart';

class SolidPointBuildComponent extends GameObjectComponent {
  Vector4 color = Colors.white;

  SolidPointBuildComponent([this.color]);

  @override
  List<Vertex> onBuild() {
    List<Vertex> vertices = [];
    vertices.add(VertexP3C4(Vector3(0, 0, 0), color));
    return vertices;
  }
}

class SolidPaneBuildComponent extends GameObjectComponent {
  double width;
  double height;
  Vector4 color;

  double get _hw => width / 2;
  double get _hh => height / 2;

  SolidPaneBuildComponent({this.width = 1, this.height = 1, this.color});

  @override
  List<Vertex> onBuild() {
    List<Vertex> vertices = [];
    vertices.addAll([
      VertexP3C4(Vector3(_hw, _hh, 0), color),
      VertexP3C4(Vector3(-_hw, _hh, 0), color),
      VertexP3C4(Vector3(-_hw, -_hh, 0), color),
      VertexP3C4(Vector3(_hw, _hh, 0), color),
      VertexP3C4(Vector3(-_hw, -_hh, 0), color),
      VertexP3C4(Vector3(_hw, -_hh, 0), color)
    ]);
    return vertices;
  }
}

class SolidCubeBuildComponent extends GameObjectComponent {
  double width;
  double height;
  double depth;

  Vector4 topColor = Colors.red;
  Vector4 leftColor = Colors.green;
  Vector4 frontColor = Colors.blue;
  Vector4 rightColor = Colors.yellow;
  Vector4 backColor = Colors.cyan;
  Vector4 bottomColor = Colors.magenta;

  bool top = true;
  bool left = true;
  bool front = true;
  bool right = true;
  bool back = true;
  bool bottom = true;

  double get _hw => width / 2;
  double get _hh => height / 2;
  double get _hd => depth / 2;

  SolidCubeBuildComponent({this.width = 1, this.height = 1, this.depth = 1, Vector4 color}) {
    if (color != null) {
      topColor = color;
      leftColor = color;
      frontColor = color;
      rightColor = color;
      backColor = color;
      bottomColor = color;
    }
  }

  @override
  List<Vertex> onBuild() {
    List<VertexP3C4> vertices = [];
    if (front) {
      vertices.addAll([
        VertexP3C4(Vector3(_hw, _hh, _hd), frontColor),
        VertexP3C4(Vector3(-_hw, _hh, _hd), frontColor),
        VertexP3C4(Vector3(-_hw, -_hh, _hd), frontColor),
        VertexP3C4(Vector3(_hw, _hh, _hd), frontColor),
        VertexP3C4(Vector3(-_hw, -_hh, _hd), frontColor),
        VertexP3C4(Vector3(_hw, -_hh, _hd), frontColor)
      ]);
    }

    if (left) {
      vertices.addAll([
        VertexP3C4(Vector3(-_hw, _hh, _hd), leftColor),
        VertexP3C4(Vector3(-_hw, _hh, -_hd), leftColor),
        VertexP3C4(Vector3(-_hw, -_hh, -_hd), leftColor),
        VertexP3C4(Vector3(-_hw, _hh, _hd), leftColor),
        VertexP3C4(Vector3(-_hw, -_hh, -_hd), leftColor),
        VertexP3C4(Vector3(-_hw, -_hh, _hd), leftColor)
      ]);
    }

    if (right) {
      vertices.addAll([
        VertexP3C4(Vector3(_hw, _hh, -_hd), rightColor),
        VertexP3C4(Vector3(_hw, _hh, _hd), rightColor),
        VertexP3C4(Vector3(_hw, -_hh, _hd), rightColor),
        VertexP3C4(Vector3(_hw, _hh, -_hd), rightColor),
        VertexP3C4(Vector3(_hw, -_hh, _hd), rightColor),
        VertexP3C4(Vector3(_hw, -_hh, -_hd), rightColor)
      ]);
    }
    return vertices;
  }
}

class TexturedCubeBuildComponent extends GameObjectComponent {
  double width;
  double height;
  double depth;

  Vector4 topColor = Colors.red;
  Vector4 leftColor = Colors.green;
  Vector4 frontColor = Colors.blue;
  Vector4 rightColor = Colors.yellow;
  Vector4 backColor = Colors.cyan;
  Vector4 bottomColor = Colors.magenta;

  bool top = true;
  bool left = true;
  bool front = true;
  bool right = true;
  bool back = true;
  bool bottom = true;

  double get _hw => width / 2;
  double get _hh => height / 2;
  double get _hd => depth / 2;

  TexturedCubeBuildComponent({this.width = 1, this.height = 1, this.depth = 1, Vector4 color}) {
    if (color != null) {
      topColor = color;
      leftColor = color;
      frontColor = color;
      rightColor = color;
      backColor = color;
      bottomColor = color;
    }
  }

  @override
  List<Vertex> onBuild() {
    List<VertexP3T2> vertices = [];
    if (front) {
      vertices.addAll([
        VertexP3T2(Vector3(_hw, _hh, _hd), Vector2(1, 1)),
        VertexP3T2(Vector3(-_hw, _hh, _hd), Vector2(0, 1)),
        VertexP3T2(Vector3(-_hw, -_hh, _hd), Vector2(0, 0)),
        VertexP3T2(Vector3(_hw, _hh, _hd), Vector2(1, 1)),
        VertexP3T2(Vector3(-_hw, -_hh, _hd), Vector2(0, 0)),
        VertexP3T2(Vector3(_hw, -_hh, _hd), Vector2(1, 0))
      ]);
    }
    return vertices;
  }
}