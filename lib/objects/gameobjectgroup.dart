import 'package:gamo_dart/components/gameobjectcomponent.dart';
import 'package:gamo_dart/objects/gameobject.dart';
import 'package:gamo_dart/shaders/shader.dart';
import 'package:gamo_dart/shaders/vertex.dart';
import 'package:vector_math/vector_math.dart';

class GameObjectGroup extends GameObject {
  List<GameObject> objects = [];

  GameObjectGroup.embedded() {
    addComponent(EmbeddedComponent());
  }

  GameObjectGroup.standalone() {
    addComponent(StandaloneComponent());
  }

  void addObject(GameObject object) {
    object.setParentGroup(this);
    objects.add(object);
  }

  void addObjects(Iterable<GameObject> objects) {
    objects.forEach((o) => addObject(o));
  }

  /*@override
  Iterable<Vertex> build({bool force = false, Vector3 offset}) {
    List<Vertex> vertices = [];
    if (isDirty || force) {
      vertices.addAll(objects.map((o) => o.build(
          force: true,
          offset: offset ?? Vector3.zero()
      )).expand((e) => e));
      vertices.map((v) => v + offset);
      if (offset == null) {
        if (vertexBuffer == null) {
          vertexBuffer = ArrayBuffer(Gamo.gl3d, DrawMode.triangles);
        }
        vertexBuffer.setData(vertices);
      }
    }
    return vertices;
  }*/

  /*@override
  void draw(Matrix4 transform) {
    super.draw(transform);

    Matrix4 innerTransform = transform * Matrix4.compose(position, orientation, scale);
    objects.forEach((o) => o.draw(innerTransform));
  }*/

  @override
  void update(double elapsedSeconds) {
    super.update(elapsedSeconds);
    List.of(objects).forEach((o) => o.update(elapsedSeconds));
  }

  void removeObject(GameObject object) {
    objects.remove(object);
  }

  void removeObjects(Iterable<GameObject> objects) {
    this.objects.forEach((o) => removeObject(o));
  }
}

class StandaloneComponent extends GameObjectComponent {
  @override
  List<Vertex> onBuild() {
    List<Vertex> vertices = [];
    if (parentObject is GameObjectGroup) {
      vertices.addAll((parentObject as GameObjectGroup).objects.map((o) {
        return o.getComponents()
            .map((c) => c.onBuild().map((v) => v + o.position))
            .expand((e) => e);
      }).expand((e) => e));
    }
    return null;
  }
}

class EmbeddedComponent extends GameObjectComponent {
  @override
  List<Vertex> onBuild() {
    List<Vertex> vertices = [];
    if (parentObject is GameObjectGroup) {
      /*vertices.addAll((parentObject as GameObjectGroup).objects.map((o) {
        return o.getComponents()
            .map((c) => c.onBuild())
            .expand((e) => e);
      }).expand((e) => e));*/
      (parentObject as GameObjectGroup).objects.forEach((o) => o.build(force: true));
      return vertices;
    }
    return null;
  }

  @override
  void onDraw(Shader shader, Matrix4 transform) {
    if (parentObject is GameObjectGroup) {
      Matrix4 innerTransform = transform * Matrix4.compose(
          parentObject.position, parentObject.orientation, parentObject.scale);
      (parentObject as GameObjectGroup).objects.forEach((o) {
          o.getComponents().forEach((c) => c.onDraw(shader, innerTransform));
      });
    }
  }
}
