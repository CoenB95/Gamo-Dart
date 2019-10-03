import 'package:gamo_dart/components/gameobjectcomponent.dart';

class DespawnComponent extends GameObjectComponent {
  double remainingSeconds = 0;
  Function onDespawn;

  DespawnComponent(this.remainingSeconds, {this.onDespawn});

  @override
  void onUpdate(double elapsedSeconds) {
    super.onUpdate(elapsedSeconds);

    remainingSeconds -= elapsedSeconds;
    if (remainingSeconds <= 0) {
      if (onDespawn != null) {
        onDespawn();
      } else {
        parentObject.parentGroup.removeObject(parentObject);
      }
    }
  }

  void resetTimer(double remainingSeconds) {
    this.remainingSeconds = remainingSeconds;
  }
}