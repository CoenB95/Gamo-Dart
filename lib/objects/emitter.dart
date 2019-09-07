import 'dart:math';

import 'package:gamo_dart/components/colordrawcomponent.dart';
import 'package:gamo_dart/components/despawncomponent.dart';
import 'package:gamo_dart/components/forcecomponent.dart';
import 'package:gamo_dart/components/primitivebuildcomponents.dart';
import 'package:gamo_dart/components/spincomponent.dart';
import 'package:gamo_dart/objects/gameobject.dart';
import 'package:gamo_dart/objects/gameobjectgroup.dart';
import 'package:vector_math/vector_math.dart';

Random _random = Random();

class Emitter extends GameObjectGroup {
  double _emitInterval = 0.05;
  double _lastEmit = 0;

  Emitter() : super.embedded();

  @override
  void update(double elapsedSeconds) {
    super.update(elapsedSeconds);

    _lastEmit -= elapsedSeconds;
    if (_lastEmit < 0) {
      Vector3 direction = Vector3(0, 1, 0).normalized();
      Vector3 jitter = (Vector3.all(0.5) - Vector3.random(_random)) * 0.05;
      double power = 10.0;
      Vector3 force = (direction + jitter) * power;

      GameObject particle = Particle(
          size: 0.1,
          color: Colors.blue);
      particle.addComponent(DespawnComponent(2));
      particle.addComponent(ForceComponent()
        ..addForce(force)
        ..acceleration = Vector3(0, -10, 0));
      //particle.position = pos;
      addObject(particle);

      _lastEmit = _emitInterval;
    }
  }
}

class Particle extends GameObject {
  Particle({double size = 1, Vector4 color}) {
    addComponent(SpinComponent(Quaternion.random(_random)));
    addComponent(SolidPaneBuildComponent(
      width: size,
      height: size,
      color: color,
    ));
    addComponent(ColoredTrianglesDrawComponent());
  }
}