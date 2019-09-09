import 'package:gamo_dart/components/gameobjectcomponent.dart';

class DespawnComponent extends GameObjectComponent {
  double _remainingSeconds = 0;
  Function onDespawn;

  DespawnComponent(this._remainingSeconds, {this.onDespawn});

  @override
  void onUpdate(double elapsedSeconds) {
    super.onUpdate(elapsedSeconds);

    _remainingSeconds -= elapsedSeconds;
    if (_remainingSeconds <= 0) {
      if (onDespawn != null) {
        onDespawn();
      } else {
        parentObject.parentGroup.removeObject(parentObject);
      }
    }
  }

  void resetTimer(double remainingSeconds) {
    this._remainingSeconds = remainingSeconds;
  }
}