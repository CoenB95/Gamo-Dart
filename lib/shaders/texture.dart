import 'dart:web_gl' as gl;

import 'package:gamo_dart/shaders/shader.dart';

class Textures {
  static Texture loadTextureFromCanvas(gl.RenderingContext context, dynamic image) {
    gl.Texture texture = context.createTexture();
    context.bindTexture(gl.WebGL.TEXTURE_2D, texture);
    context.texImage2D(
      gl.WebGL.TEXTURE_2D,
      0,
      gl.WebGL.RGBA,
      gl.WebGL.RGBA,
      gl.WebGL.UNSIGNED_BYTE,
      image,
    );
    context.texParameteri(gl.WebGL.TEXTURE_2D, gl.WebGL.TEXTURE_MAG_FILTER, gl.WebGL.NEAREST);
    context.texParameteri(gl.WebGL.TEXTURE_2D, gl.WebGL.TEXTURE_MIN_FILTER, gl.WebGL.NEAREST);
    //context.generateMipmap(gl.WebGL.TEXTURE_2D);
    context.bindTexture(gl.WebGL.TEXTURE_2D, null);

    return Texture()..id = texture;
  }
}


