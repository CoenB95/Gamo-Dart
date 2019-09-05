import 'package:gamo_dart/objects/gameobject.dart';
import 'package:gamo_dart/shaders/shader.dart';
import 'package:gamo_dart/shaders/vertex.dart';
import 'package:vector_math/vector_math.dart';

abstract class GameObjectComponent {
  GameObject _parentObject;
  GameObject get parentObject => _parentObject;
  set parentObject(GameObject value) {
    onDetach();
    _parentObject = value;
    onAttach();
  }

  void onAttach() {}
  List<Vertex> onBuild() { return []; }
  void onDetach() {}
  void onDraw(Shader shader, Matrix4 parentTransform) {}
  void onUpdate(double elapsedSeconds) {}
}
