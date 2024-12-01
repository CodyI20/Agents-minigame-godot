shader_type spatial;
render_mode unshaded, shadows_disabled;
#include "funcs.gdshaderinc"

uniform float fresnel_power: hint_range(1.0, 7.0) = 3.0;
uniform vec3 color: source_color;
uniform float lines1: hint_range(0.0, 200.0, 1.0) = 2.0;
uniform float lines2: hint_range(0.0, 200.0, 1.0) = 2.0;
uniform float emission_strength : hint_range(0.0,10.0) = 1.0;
uniform float flicker_probabilty : hint_range(0.005, 0.015) = 0.006;

varying float random_dist;

void vertex(){
	float distortion = sin(TIME*10.0 + VERTEX.y*20.0) *0.02;
	float random_time = random(TIME);
	random_dist = step(random_time,flicker_probabilty);
	
	VERTEX.x += distortion * random_dist;
}

void fragment(){
	float n = random2_1(SCREEN_UV);
	float f = fresnel(fresnel_power,NORMAL, VIEW);
	
	// LINES
	vec2 igrid = floor(SCREEN_UV * lines1);
	float l1 = mod(igrid.y, 2.0);
	l1 = mix(0.4,1.0,l1);
	
	// RANDOM LINES
	vec2 uv2 = SCREEN_UV;
	uv2.y -= TIME * 0.06;
	vec2 igrid2 = floor(uv2*lines2);
	float l2 = random(igrid2.y);
	l2 = step(0.2,l2);
	l2 = mix(0.2,1.0,l2);
	
	float m = f*n*l1*l2;
	ALPHA = m;
	ALBEDO = color * mix(emission_strength-2.0, emission_strength, random_dist);
	EMISSION = color * emission_strength;
}
