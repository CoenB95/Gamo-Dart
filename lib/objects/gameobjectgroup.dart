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
    isDirty = true;
  }

  void addObjects(Iterable<GameObject> objects) {
    objects.forEach((o) => addObject(o));
  }

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
      (parentObject as GameObjectGroup).objects.forEach((o) => o.build(force: true));
      return vertices;
    }
    return null;
  }

  @override
  void onDraw(Shader shader, Matrix4 parentTransform) {
    if (parentObject is GameObjectGroup) {
      Matrix4 transform = parentTransform * Matrix4.compose(
          parentObject.position, parentObject.orientation, parentObject.scale);
      (parentObject as GameObjectGroup).objects.forEach((o) {
          o.getComponents().forEach((c) => c.onDraw(shader, transform));
      });
    }
  }
}
