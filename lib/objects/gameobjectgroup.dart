import 'dart:web_gl';

import 'package:gamo_gl/gl/vertex.dart';

import 'gameobject.dart';

class GameObjectGroup<T extends Vertex> extends GameObject {
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
  void draw() {
    super.draw();
    objects.forEach((o) => o.draw());
  }

  @override
  void update(double elapsedSeconds) {
    super.update(elapsedSeconds);
    objects.forEach((o) => o.update(elapsedSeconds));
  }

  void removeObject(GameObject object) {
    objects.remove(object);
  }

  void removeObjects(Iterable<GameObject> objects) {
    this.objects.forEach((o) => removeObject(o));
  }

/*void setCamera(Camera camera) {
  group.getScene().setCamera(camera.camera);
  addObject(camera);
  }*/
}
