import 'package:gamo_gl/gl/vertex.dart';
import 'package:gamo_gl/objects/gameobject.dart';

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
  void onDraw() {}
  void onUpdate(double elapsedSeconds) {}
}
