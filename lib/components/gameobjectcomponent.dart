import 'package:gamo_gl/gl/vertex.dart';
import 'package:gamo_gl/objects/gameobject.dart';

abstract class GameObjectComponent<T extends Vertex> {
  GameObject<T> _parentObject;
  GameObject<T> get parentObject => _parentObject;
  set parentObject(GameObject value) {
    onDetach();
    _parentObject = value;
    onAttach();
  }

  void onAttach() {}
  List<T> onBuild() { return []; }
  void onDetach() {}
  void onDraw() {}
  void onUpdate(double elapsedSeconds) {}
}
