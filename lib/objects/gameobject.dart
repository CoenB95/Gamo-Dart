import 'package:gamo_dart/components/gameobjectcomponent.dart';
import 'package:gamo_dart/gamo.dart';
import 'package:gamo_dart/objects/gameobjectgroup.dart';
import 'package:gamo_dart/shaders/shader.dart';
import 'package:gamo_dart/shaders/vertex.dart';
import 'package:vector_math/vector_math.dart';

abstract class GameObject {
  Vector3 position;
  Quaternion orientation;
  Vector3 scale;

  GameObjectGroup get parentGroup => _parentGroup;
  Vector3 get globalPosition => _parentGroup?.globalPosition ?? Vector3.zero() + position;

  ArrayBuffer vertexBuffer;
  bool _dirty = true;
  bool get isDirty => _dirty;
  set isDirty(bool val) {
    if (val) {
      _dirty = true;
      _parentGroup?._dirty = true;
    }
  }

  GameObjectGroup _parentGroup;
  List<GameObjectComponent> _components = [];

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

  Iterable<Vertex> build({bool force = false}) {
    List<Vertex> vertices = [];
    if (isDirty || force) {
      _components.forEach((c) {
        vertices.addAll(c.onBuild());
      });
      if (vertexBuffer == null) {
        vertexBuffer = ArrayBuffer(Gamo.gl3d);
      }
      vertexBuffer.setData(vertices);
      isDirty = false;
    }
    return vertices;
  }

  void draw(Shader shader) {
    Matrix4 innerTransform = Matrix4.identity();
    _components.forEach((c) => c.onDraw(shader, innerTransform));
  }

  List<GameObjectComponent> getComponents() {
    return List.unmodifiable(_components);
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
