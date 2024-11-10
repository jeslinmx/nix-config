precision mediump float;
varying vec2 v_texcoord;
uniform sampler2D tex;

// Function to convert RGB to HSV
vec3 rgbToHsv(vec3 c) {
    float maxC = max(c.r, max(c.g, c.b));
    float minC = min(c.r, min(c.g, c.b));
    float delta = maxC - minC;
    
    float h = 0.0;
    if (delta > 0.0) {
        if (maxC == c.r) {
            h = mod((c.g - c.b) / delta, 6.0);
        } else if (maxC == c.g) {
            h = (c.b - c.r) / delta + 2.0;
        } else {
            h = (c.r - c.g) / delta + 4.0;
        }
        h /= 6.0;
    }

    float s = (maxC == 0.0) ? 0.0 : delta / maxC;
    float v = maxC;

    return vec3(h, s, v);
}

// Function to convert HSV to RGB
vec3 hsvToRgb(vec3 c) {
    float h = c.x * 6.0;
    float s = c.y;
    float v = c.z;

    int i = int(floor(h));
    float f = h - float(i);
    float p = v * (1.0 - s);
    float q = v * (1.0 - f * s);
    float t = v * (1.0 - (1.0 - f) * s);

    if (i == 0) return vec3(v, t, p);
    else if (i == 1) return vec3(q, v, p);
    else if (i == 2) return vec3(p, v, t);
    else if (i == 3) return vec3(p, q, v);
    else if (i == 4) return vec3(t, p, v);
    else return vec3(v, p, q);
}

// Function to apply f(x) = -0.5 * x^2 + x to the Value component
float applyValueTransform(float v) {
    return -0.5 * v * v + v;
}

void main() {
    vec4 pixColor = texture2D(tex, v_texcoord);

    // Convert RGB to HSV
    vec3 hsv = rgbToHsv(pixColor.rgb);

    // Apply the function to the Value (V) component
    hsv.z = applyValueTransform(hsv.z);

    // Convert back to RGB
    vec3 rgb = hsvToRgb(hsv);

    // Set the output color
    gl_FragColor = vec4(rgb, pixColor.a);
}
