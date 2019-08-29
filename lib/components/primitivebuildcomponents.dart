import 'package:gamo_gl/components/gameobjectcomponent.dart';
import 'package:gamo_gl/gl/vertex.dart';
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
  Vector4 color = Colors.blue;

  bool top = true;
  bool left = true;
  bool front = true;
  bool right = true;
  bool back = true;
  bool bottom = true;

  double get _hw => width / 2;
  double get _hh => height / 2;
  double get _hd => depth / 2;

  SolidCubeBuildComponent({this.width = 1, this.height = 1, this.depth = 1});

  @override
  List<Vertex> onBuild() {
    List<VertexP3C4> vertices = [];
    if (front) {
      vertices.addAll([
        VertexP3C4(Vector3(_hw, _hh, _hd), Colors.red),
        VertexP3C4(Vector3(-_hw, _hh, _hd), Colors.green),
        VertexP3C4(Vector3(-_hw, -_hh, _hd), Colors.blue),
        VertexP3C4(Vector3(_hw, _hh, _hd), color),
        VertexP3C4(Vector3(-_hw, -_hh, _hd), color),
        VertexP3C4(Vector3(_hw, -_hh, _hd), color)
      ]);
    }

    if (left) {
      vertices.addAll([
        VertexP3C4(Vector3(-_hw, _hh, _hd), color),
        VertexP3C4(Vector3(-_hw, _hh, -_hd), color),
        VertexP3C4(Vector3(-_hw, -_hh, -_hd), color),
        VertexP3C4(Vector3(-_hw, _hh, _hd), color),
        VertexP3C4(Vector3(-_hw, -_hh, -_hd), color),
        VertexP3C4(Vector3(-_hw, -_hh, _hd), color)
      ]);
    }

    if (right) {
      vertices.addAll([
        VertexP3C4(Vector3(_hw, _hh, -_hd), color),
        VertexP3C4(Vector3(_hw, _hh, _hd), color),
        VertexP3C4(Vector3(_hw, -_hh, _hd), color),
        VertexP3C4(Vector3(_hw, _hh, -_hd), color),
        VertexP3C4(Vector3(_hw, -_hh, _hd), color),
        VertexP3C4(Vector3(_hw, -_hh, -_hd), color)
      ]);
    }
    return vertices;
  }
}