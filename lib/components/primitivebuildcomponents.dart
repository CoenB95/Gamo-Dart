import 'package:gamo_dart/components/gameobjectcomponent.dart';
import 'package:gamo_dart/shaders/vertex.dart';
import 'package:vector_math/vector_math.dart';

class PaneBuildComponent extends GameObjectComponent {
  @override
  List<Vertex> onBuild() {
    return [
      VertexP3C4(Vector3( 1,  1, 0), Colors.white),
      VertexP3C4(Vector3(-1,  1, 0), Colors.white),
      VertexP3C4(Vector3( 1, -1, 0), Colors.white),
      VertexP3C4(Vector3(-1, -1, 0), Colors.white)
    ];
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