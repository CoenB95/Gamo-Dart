import 'package:gamo_dart/components/gameobjectcomponent.dart';
import 'package:gamo_dart/objects/gameobjectgroup.dart';
import 'package:gamo_dart/shaders/shader.dart';
import 'package:gamo_dart/shaders/vertex.dart';
import 'package:vector_math/vector_math.dart';

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

  void draw(Matrix4 transform) {
    Matrix4 innerTransform = transform * Matrix4.compose(position, orientation, scale);
    _components.forEach((c) => c.onDraw(innerTransform));
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
