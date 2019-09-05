import 'package:gamo_dart/objects/cube.dart';
import 'package:gamo_dart/objects/emitter.dart';
import 'package:gamo_dart/stage.dart';
import 'package:vector_math/vector_math.dart';

class TestScene extends Stage {
  //@override
  //void onAttach(GameObjectGroup newParent) {
  void onStart() {
    //super.onAttach(newParent);

    Cube cube = Cube.textured();
    cube.position = Vector3(-1.5, 0.0, -7.0);
    textured.addObject(cube);

    Cube cube2 = Cube();
    cube2.position = Vector3(1.5, 0.0, -7.0);
    colored.addObject(cube2);

    Emitter emitter = Emitter();
    emitter.position = Vector3(0, 0, -7);
    colored.addObject(emitter);
  }
}