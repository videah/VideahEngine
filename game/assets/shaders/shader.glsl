varying vec3 f_normal;

#ifdef VERTEX
	uniform mat4 u_model, u_viewProjection;

	attribute vec3 VertexNormal;
	attribute vec4 VertexWeight;

	vec4 position(mat4 mvp, vec4 v_position) {
		f_normal = (u_model * vec4(VertexNormal, 1.0)).xyz;
		return u_viewProjection * u_model * v_position;
	}
#endif

#ifdef PIXEL
	uniform int use_fresnel;

	vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords) {
		vec4 tex = texture2D(texture, texture_coords);

		if (use_fresnel == 1) {
			float shade = pow(clamp(dot(f_normal, vec3(0.0, 0.0, 1.0)), 0.0001, 1.0), 0.9) * 0.1;
			float fresnel = pow(clamp(dot(f_normal, vec3(0.0, 1.0, 0.0)), 0.0001, 1.0), 2.05);
			float factor = clamp(fresnel + 0.9 - shade, 0.0, 1.0);
			return mix(vec4(1.0), tex, factor) * color;
		}
		return tex * color;
	}
#endif
