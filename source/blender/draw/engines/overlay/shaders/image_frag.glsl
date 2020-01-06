
uniform sampler2D imgTexture;
uniform bool imgPremultiplied;
uniform bool imgAlphaBlend;
uniform bool imgLinear;
uniform vec4 color;

in vec2 uvs;

out vec4 fragColor;

void main()
{
  vec2 uvs_clamped = clamp(uvs, 0.0, 1.0);
  vec4 tex_color;
  if (imgLinear) {
    tex_color = texture_read_as_linearrgb(imgTexture, imgPremultiplied, uvs_clamped);
  }
  else {
    tex_color = texture_read_as_srgb(imgTexture, imgPremultiplied, uvs_clamped);
  }
  fragColor = tex_color * color;

  if (!imgAlphaBlend) {
    /* Arbitrary discard anything below 5% opacity.
     * Note that this could be exposed to the User. */
    if (tex_color.a < 0.05) {
      discard;
    }
    else {
      fragColor.a = 1.0;
    }
  }
}
