shader_type spatial;

uniform sampler2D noiseTexture;
uniform sampler2D wearTexture;
uniform vec3 mainColor : source_color;
uniform vec3 wearColor : source_color;
uniform float wear : hint_range(0.0, 1.0);

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	ALBEDO = (1.0-wear) *  mainColor + (wear) * wearColor;
	METALLIC = 0.0;
	ROUGHNESS = 1.0;
	float wearLevel = 0.8*texture(noiseTexture,vec2(UV.x,UV.y)).r + (1.0 - wear);
	if(wearLevel < 1.0){
		ALBEDO = (1.0-wear) * (0.7 *  mainColor + 0.3 * wearColor) + (wear) * wearColor;
	}
	if(wearLevel <= 0.8){
		ALBEDO = wearColor * texture(wearTexture,vec2(UV.x,UV.y)).r;
	}
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
