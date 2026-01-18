shader_type canvas_item;

uniform sampler2D mask_tx : filter_nearest;
instance uniform int frame;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec4 colour = texture(TEXTURE, UV);
	vec2 mask_uv = UV;
	mask_uv.x = mod(UV.x, (1.0 + float(frame)/7.0));
	colour.a *= texture(mask_tx, mask_uv).r;
	//COLOR = colour;
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
