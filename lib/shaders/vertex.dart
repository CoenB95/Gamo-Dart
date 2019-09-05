import 'dart:typed_data';

import 'package:vector_math/vector_math.dart';

abstract class Vertex {
  Float32List storage();

  Vertex operator +(Vector3 offset);
}

class VertexP3C4 extends Vertex {
  final Vector3 position;
  final Vector4 color;

  VertexP3C4(this.position, this.color);

  Float32List storage() => Float32List.fromList(position.storage + color.storage);

  @override
  Vertex operator +(Vector3 offset) {
    return VertexP3C4(position + offset, color);
  }
}

class VertexP3T2 extends Vertex {
  final Vector3 position;
  final Vector2 texCoords;

  VertexP3T2(this.position, this.texCoords);

  Float32List storage() => Float32List.fromList(position.storage + texCoords.storage);

  @override
  Vertex operator +(Vector3 offset) {
    return VertexP3T2(position + offset, texCoords);
  }
}
