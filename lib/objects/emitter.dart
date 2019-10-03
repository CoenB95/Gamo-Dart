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
  bool active = true;

  double _emitInterval = 0.05;
  double _lastEmit = 0;
  List<Particle> _particles = [];

  Emitter() : super.standalone() {
    addComponent(ColoredPointsDrawComponent());
  }

  @override
  void update(double elapsedSeconds) {
    super.update(elapsedSeconds);

    _lastEmit -= elapsedSeconds;
    if (active && _lastEmit < 0) {
      Particle particle = _particles.firstWhere((p) => p.done,
          orElse: () {
            Particle p = Particle(
                size: 0.1,
                color: Colors.blue);
            p.forceComponent.acceleration = Vector3(0, -10, 0);

            _particles.add(p);
            addObject(p);
            return p;
          });
      Vector3 direction = Vector3(0, 1, 0).normalized();
      Vector3 jitter = (Vector3.all(0.5) - Vector3.random(_random)) * 0.02;
      double power = 10.0;
      Vector3 force = (direction + jitter) * power;

      particle.forceComponent.setForce(force);
      particle.reset();

      _lastEmit = _emitInterval;
    }
  }
}

class Particle extends GameObject {
  Vector4 color;
  bool done;
  SolidPointBuildComponent buildComponent;
  DespawnComponent despawnComponent;
  ForceComponent forceComponent;

  Particle({double size = 1, this.color}) {
    buildComponent = SolidPointBuildComponent(Vector4.copy(color));
    despawnComponent = DespawnComponent(2, onDespawn: () => done = true);
    forceComponent = ForceComponent();
    reset();

    addComponent(SpinComponent(Quaternion.random(_random)));
    addComponent(buildComponent);
    addComponent(ColoredPointsDrawComponent());
    addComponent(despawnComponent);
    addComponent(forceComponent);
  }

  @override
  void update(double elapsedSeconds) {
    super.update(elapsedSeconds);
    Vector4.mix(Colors.black, color, despawnComponent.remainingSeconds / 2, buildComponent.color);
  }

  void reset() {
    position = Vector3.zero();
    despawnComponent.resetTimer(2);
    done = false;
  }
}