shader_type canvas_item;
render_mode world_vertex_coords;

uniform float pixel_size = 4.0;

void fragment() {
    // Snap lighting and shadows to pixel grid.
    LIGHT_VERTEX.xy = ceil(LIGHT_VERTEX.xy / pixel_size) * pixel_size;
    SHADOW_VERTEX = ceil(SHADOW_VERTEX / pixel_size) * pixel_size;

    // Normal rendering.
    COLOR = texture(TEXTURE, UV);
}
