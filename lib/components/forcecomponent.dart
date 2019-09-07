import 'package:gamo_dart/components/gameobjectcomponent.dart';
import 'package:vector_math/vector_math.dart';

class ForceComponent extends GameObjectComponent {
  Vector3 acceleration = Vector3.zero();
  Vector3 velocity = Vector3.zero();

  void addForce(Vector3 force) {
    velocity += force;
  }

  @override
  void onUpdate(double elapsedSeconds) {
    parentObject.position += (velocity + acceleration / 2 * elapsedSeconds) * elapsedSeconds;
    velocity += acceleration * elapsedSeconds;
  }
}