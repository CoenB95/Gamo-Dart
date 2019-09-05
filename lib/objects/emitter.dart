import 'dart:math';

import 'package:gamo_dart/components/despawncomponent.dart';
import 'package:gamo_dart/objects/cube.dart';
import 'package:gamo_dart/objects/gameobjectgroup.dart';
import 'package:vector_math/vector_math.dart';

class Emitter extends GameObjectGroup {
  double _emitInterval = 0.100;
  double _lastEmit = 0;
  Random _random = Random();

  Emitter() : super.embedded();

  @override
  void update(double elapsedSeconds) {
    super.update(elapsedSeconds);

    _lastEmit -= elapsedSeconds;
    if (_lastEmit < 0) {
      Vector3 pos = Quaternion.random(_random).rotate(Vector3(3, 0, 0));

      Cube particle = Cube(
          size: 0.4,
          color: Colors.orange);
      particle.addComponent(DespawnComponent(2));
      particle.position = pos;
      addObject(particle);

      _lastEmit = _emitInterval;
    }
  }
}