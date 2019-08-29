import 'package:gamo_gl/components/gameobjectcomponent.dart';
import 'package:vector_math/vector_math.dart';

class SpinComponent extends GameObjectComponent {
  final Quaternion rotationPerSecond;
  double _progress = 0;

  SpinComponent(this.rotationPerSecond);

  @override
  void onUpdate(double elapsedSeconds) {
    _progress += elapsedSeconds;
    parentObject.orientation = Quaternion.axisAngle(rotationPerSecond.axis, rotationPerSecond.radians * _progress);
  }
}