import 'package:gamo_dart/objects/gameobject.dart';
import 'package:vector_math/vector_math.dart';

class GameObjectGroup extends GameObject {
  List<GameObject> objects = [];

  GameObjectGroup();

  void addObject(GameObject object) {
    object.setParentGroup(this);
    objects.add(object);
  }

  void addObjects(Iterable<GameObject> objects) {
    objects.forEach((o) => addObject(o));
  }

  @override
  void build({bool force = false}) {
    super.build(force: force);
    if (isDirty || force) {
      objects.forEach((o) => o.build(force: true));
    }
  }

  @override
  void draw(Matrix4 transform) {
    super.draw(transform);

    Matrix4 innerTransform = transform * Matrix4.compose(position, orientation, scale);
    objects.forEach((o) => o.draw(innerTransform));
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
