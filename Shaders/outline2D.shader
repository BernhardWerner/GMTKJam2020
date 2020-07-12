shader_type canvas_item;

uniform bool active = false;
uniform vec4 rim_color : hint_color;

float oplus(float x, float y) {
	return x + y - x * y;
}

void fragment() {
	vec4 tex = texture(TEXTURE, UV);
	
	if(active) {
		float rim_size = float(TEXTURE_PIXEL_SIZE.x);
		
		float left  = texture(TEXTURE, UV + vec2(rim_size, 0.0)).a;
		float right = texture(TEXTURE, UV + vec2(-rim_size, 0.0)).a;
		float up    = texture(TEXTURE, UV + vec2(0.0, -rim_size)).a;
		float down  = texture(TEXTURE, UV + vec2(0.0, rim_size)).a;
		
		float rim = oplus(oplus(left, right), oplus(up, down)) - tex.a;
		
		COLOR = tex + 1.1 * rim_color * rim - tex * rim;
	} else {
		COLOR = tex;
	}
}