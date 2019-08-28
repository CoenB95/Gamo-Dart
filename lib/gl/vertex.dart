import 'dart:typed_data';

import 'package:vector_math/vector_math.dart';

abstract class Vertex {
  Float32List storage();
}

class VertexP3C4 extends Vertex {
  final Vector3 position;
  final Vector4 color;

  VertexP3C4(this.position, this.color);

  Float32List storage() => Float32List.fromList(position.storage + color.storage);
}
