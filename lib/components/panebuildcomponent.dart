import 'package:gamo_gl/components/gameobjectcomponent.dart';
import 'package:gamo_gl/gl/vertex.dart';
import 'package:vector_math/vector_math.dart';

class PaneBuildComponent extends GameObjectComponent<VertexP3C4> {
  @override
  List<VertexP3C4> onBuild() {
    return [
      VertexP3C4(Vector3( 1,  1, 0), Colors.white),
      VertexP3C4(Vector3(-1,  1, 0), Colors.white),
      VertexP3C4(Vector3( 1, -1, 0), Colors.white),
      VertexP3C4(Vector3(-1, -1, 0), Colors.white)
    ];
  }
}