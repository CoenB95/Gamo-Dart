import 'package:gamo_dart/components/gameobjectcomponent.dart';

class DespawnComponent extends GameObjectComponent {
  double _remainingSeconds = 0;

  DespawnComponent(this._remainingSeconds);

  @override
  void onUpdate(double elapsedSeconds) {
    super.onUpdate(elapsedSeconds);

    _remainingSeconds -= elapsedSeconds;
    if (_remainingSeconds <= 0) {
      parentObject.parentGroup.removeObject(parentObject);
    }
  }
}