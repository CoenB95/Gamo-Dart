import 'package:gamo_dart/objects/cube.dart';
import 'package:gamo_dart/objects/emitter.dart';
import 'package:gamo_dart/objects/gameobjectgroup.dart';
import 'package:vector_math/vector_math.dart';

class TestScene extends GameObjectGroup {
  @override
  void onAttach(GameObjectGroup newParent) {
    super.onAttach(newParent);

    Cube cube = Cube();
    cube.position = Vector3(-1.5, 0.0, -7.0);
    addObject(cube);

    Cube cube2 = Cube();
    cube2.position = Vector3(1.5, 0.0, -7.0);
    addObject(cube2);

    Emitter emitter = Emitter();
    emitter.position = Vector3(0, 0, -7);
    addObject(emitter);
  }
}