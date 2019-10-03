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
  double _emitInterval = 0.1;
  double _lastEmit = 0;
  List<Particle> particles = [];

  Emitter() : super.standalone() {
    addComponent(ColoredPointsDrawComponent());
  }

  @override
  void update(double elapsedSeconds) {
    super.update(elapsedSeconds);

    _lastEmit -= elapsedSeconds;
    if (_lastEmit < 0) {
      Particle particle = particles.firstWhere((p) => p.done,
          orElse: () {
            Particle p = Particle(
                size: 0.1,
                color: Colors.blue);
            p.forceComponent.acceleration = Vector3(0, -10, 0);

            particles.add(p);
            addObject(p);
            return p;
          });
      Vector3 direction = Vector3(0, 1, 0).normalized();
      Vector3 jitter = (Vector3.all(0.5) - Vector3.random(_random)) * 0.05;
      double power = 10.0;
      Vector3 force = (direction + jitter) * power;

      particle.forceComponent.setForce(force);
      particle.reset();

      _lastEmit = _emitInterval;
    }
  }
}

class Particle extends GameObject {
  bool done;
  DespawnComponent despawnComponent;
  ForceComponent forceComponent;

  Particle({double size = 1, Vector4 color}) {
    despawnComponent = DespawnComponent(2, onDespawn: () => done = true);
    forceComponent = ForceComponent();
    reset();

    addComponent(SpinComponent(Quaternion.random(_random)));
    addComponent(SolidPointBuildComponent(color));
    addComponent(ColoredPointsDrawComponent());
    addComponent(despawnComponent);
    addComponent(forceComponent);
  }

  void reset() {
    position = Vector3.zero();
    despawnComponent.resetTimer(2);
    done = false;
  }
}