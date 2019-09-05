import 'package:gamo_dart/gamo.dart';
import 'package:gamo_dart/shaders/shader.dart';
import 'package:gamo_dart/shaders/texture.dart';
import 'package:vector_math/vector_math.dart';

import 'gameobjectcomponent.dart';

class TexturedTrianglesDrawComponent extends GameObjectComponent {
  Texture texture;

  TexturedTrianglesDrawComponent() {
    texture = Textures.loadTextureFromCanvas(Gamo.gl3d, Gamo.gl2d.canvas);
  }

  @override
  void onDraw(Shader shader, Matrix4 parentTransform) {
    texture.use(Gamo.gl3d, 0);

    Matrix4 transform = parentTransform * Matrix4.compose(
        parentObject.position, parentObject.orientation, parentObject.scale);
    shader.modelMatrix = transform;
    shader.draw(parentObject.vertexBuffer, DrawMode.triangles);
  }
}
