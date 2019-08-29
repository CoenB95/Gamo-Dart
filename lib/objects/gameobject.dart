import 'package:gamo_gl/components/gameobjectcomponent.dart';
import 'package:gamo_gl/gl/vertex.dart';
import 'package:vector_math/vector_math.dart';

import 'gameobjectgroup.dart';

abstract class GameObject {
  GameObjectGroup _parentGroup;
  List<GameObjectComponent> _components = [];
  List<Vertex> vertices = [];
  Vector3 position;
  Quaternion orientation;
  Vector3 scale;
  bool isDirty = true;

  GameObject() {
    position = Vector3.zero();
    orientation = Quaternion.identity();
    scale = Vector3.all(1);
  }

  void addComponent(GameObjectComponent component) {
    if (component == null) {
      return;
    }

    component.parentObject = this;
    _components.add(component);
  }

  void build({bool force = false}) {
    if (isDirty || force) {
      vertices.clear();
      vertices.addAll(_components.map((c) => c.onBuild()).expand((e) => e));
    }
  }

  void draw() {
    _components.forEach((c) => c.onDraw());
  }

  List<GameObjectComponent> getComponents() {
    return List.unmodifiable(_components);
  }

  GameObjectGroup getParentGroup() {
    return _parentGroup;
  }

  void onAttach(GameObjectGroup newParent) {}

  void onDetach(GameObjectGroup oldParent) {}

  bool removeComponent(GameObjectComponent component) {
    if (component == null || !_components.contains(component)) {
      return false;
    }

    component.onDetach();
    _components.remove(component);
    return true;
  }

  void setParentGroup(GameObjectGroup parent) {
    if (_parentGroup != null) {
      onDetach(_parentGroup);
    }

    _parentGroup = parent;

    if (_parentGroup != null) {
      onAttach(_parentGroup);
    }
  }

  void update(double elapsedSeconds) {
    _components.forEach((c) => c.onUpdate(elapsedSeconds));
  }
}
