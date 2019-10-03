import 'dart:math';

import 'package:gamo_dart/objects/cube.dart';
import 'package:gamo_dart/objects/emitter.dart';
import 'package:gamo_dart/stage.dart';
import 'package:vector_math/vector_math.dart';

class TestScene extends Stage {
  Random _random = Random();
  double _lastChange = 0;
  int _nozzleCount = 7;
  List<Emitter> _nozzles = [];

  void onStart() {
    Cube cube = Cube.textured();
    cube.position = Vector3(-1.5, 0.0, -7.0);
    //textured.addObject(cube);

    Cube cube2 = Cube();
    cube2.position = Vector3(1.5, 0.0, -7.0);
    colored.addObject(cube2);

    for (int i = 0; i < _nozzleCount; i++) {
      Emitter nozzle = Emitter();
      nozzle.position = Vector3(-3 + i / _nozzleCount * 6, -3, -7);
      colored.addObject(nozzle);
      _nozzles.add(nozzle);
    }
  }

  @override
  void onUpdate(double elapsedSeconds) {
    _lastChange -= elapsedSeconds;

    if (_lastChange < 0) {
      _lastChange = 0.1;

      int noz = _random.nextInt(_nozzleCount);
      _nozzles[noz].active = !_nozzles[noz].active;
    }
  }
}