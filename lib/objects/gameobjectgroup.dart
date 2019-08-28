import 'gameobject.dart';

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
