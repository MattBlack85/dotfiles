#!/usr/bin/env python3
"""Cyberpunk idle screensaver: a wallpaper brought to life by one GPU shader.

Slow camera drift, glowing neon that breathes and flickers, scanlines, a sweeping scan bar,
chromatic aberration and occasional glitch bursts (horizontal slice shifts + RGB split).
Full-screen overlay window (gtk-layer-shell, GTK3 GLArea, GLES via ctypes), one per monitor.

    neon-saver.py --image PATH [--index N] [--fps 30]        (started by screensaver.sh)

Needs python-gobject, gtk3, gtk-layer-shell, python-pillow, python-cairo and Mesa (libGLESv2).
"""
import argparse
import ctypes
import time

import cairo
import gi
from PIL import Image

gi.require_version("Gtk", "3.0")
gi.require_version("Gdk", "3.0")
gi.require_version("GtkLayerShell", "0.1")
from gi.repository import Gdk, GLib, Gtk, GtkLayerShell  # noqa: E402

VERT = """#version 300 es
void main() {
    float x = float((gl_VertexID << 1) & 2);
    float y = float(gl_VertexID & 2);
    gl_Position = vec4(x * 2.0 - 1.0, y * 2.0 - 1.0, 0.0, 1.0);
}
"""

FRAG = """#version 300 es
precision highp float;
uniform sampler2D u_img;
uniform vec2  u_res, u_imgres;
uniform float u_time;
out vec4 o;

float h11(float p) { p = fract(p * .1031); p *= p + 33.33; p *= p + p; return fract(p); }
float h21(vec2 p) { vec3 q = fract(vec3(p.xyx) * .1031); q += dot(q, q.yzx + 33.33); return fract((q.x + q.y) * q.z); }

// screen uv (0..1, y down) -> image uv: cover-fit, slow zoom and drift
vec2 cover(vec2 uv) {
    float sa = u_res.x / u_res.y, ia = u_imgres.x / u_imgres.y;
    vec2 s = (sa > ia) ? vec2(1., ia / sa) : vec2(sa / ia, 1.);
    float z = 1. / (1.07 + .05 * sin(u_time * .045));
    vec2 c = vec2(.5) + vec2(.014 * sin(u_time * .031), .009 * cos(u_time * .027));
    return clamp(c + (uv - .5) * s * z, 0., 1.);
}
vec3 tex(vec2 uv) { return texture(u_img, cover(uv)).rgb; }

void main() {
    vec2 uv = vec2(gl_FragCoord.x / u_res.x, 1. - gl_FragCoord.y / u_res.y);
    float t = u_time;

    // glitch burst: ~0.3 s every 7 s slot (most slots), horizontal slices jump sideways
    float slot  = floor(t / 7.);
    float burst = step(fract(t / 7.), .045) * step(.3, h11(slot));
    float band  = floor(uv.y * 30.);
    float fr    = floor(t * 30.);
    float shift = burst * (h21(vec2(band, fr)) - .5) * .07 * step(.55, h21(vec2(band + 3., fr)));
    vec2 g = vec2(uv.x + shift, uv.y);

    // chromatic aberration: a little everywhere, more at the edges and in bursts
    float ca = .0012 + .004 * length(uv - .5) + burst * .012;
    vec3 col = vec3(tex(g + vec2(ca, 0.)).r, tex(g).g, tex(g - vec2(ca, 0.)).b);

    // glow: two rings of taps, only the bright parts bleed
    vec3 bl = vec3(0.);
    float asp = u_res.x / u_res.y;
    for (int i = 0; i < 12; i++) {
        float a = float(i) * .5236;
        vec2 d = vec2(cos(a), sin(a) * asp);
        bl += tex(g + d * .004) + tex(g + d * .011);
    }
    bl /= 24.;
    col += max(bl - .30, 0.) * 1.1 * (.85 + .15 * sin(t * 1.6));

    // neon breathes, and random blocks of bright saturated pixels flicker
    float lum = dot(col, vec3(.299, .587, .114));
    float sat = max(col.r, max(col.g, col.b)) - min(col.r, min(col.g, col.b));
    float neon = smoothstep(.40, .85, lum) * smoothstep(.15, .45, sat);
    vec2 cell = floor(uv * vec2(16., 9.));
    float flick = step(.94, h21(cell + floor(t * 10.)));
    col *= 1. + neon * (.10 * sin(t * 2.2 + h21(cell) * 6.28) + .55 * flick);

    // scanlines, a slow sweeping scan bar, vignette, grain
    col *= .93 + .07 * sin(gl_FragCoord.y * 3.14159);
    float bar = exp(-pow((uv.y - fract(t / 9.)) * 16., 2.));
    col += vec3(.20, .45, .65) * bar * .07;
    col *= 1. - .55 * pow(length(uv - .5) * 1.1, 2.2);
    col += (h21(gl_FragCoord.xy + t) - .5) * .03;

    o = vec4(clamp(col, 0., 1.), 1.);
}
"""

GL_VERTEX_SHADER, GL_FRAGMENT_SHADER = 0x8B31, 0x8B30
GL_COMPILE_STATUS, GL_LINK_STATUS = 0x8B81, 0x8B82
GL_TRIANGLES, GL_TEXTURE_2D, GL_TEXTURE0 = 4, 0x0DE1, 0x84C0
GL_RGB, GL_UNSIGNED_BYTE, GL_UNPACK_ALIGNMENT = 0x1907, 0x1401, 0x0CF5
GL_LINEAR, GL_CLAMP_TO_EDGE = 0x2601, 0x812F
GL_MIN, GL_MAG, GL_WRAP_S, GL_WRAP_T = 0x2801, 0x2800, 0x2802, 0x2803


class GL:
    """The few OpenGL ES calls we need, straight from libGLESv2."""

    def __init__(self):
        L = self.lib = ctypes.CDLL("libGLESv2.so.2")
        u32, i32, f32, vp = ctypes.c_uint, ctypes.c_int, ctypes.c_float, ctypes.c_void_p
        sig = {
            "glCreateShader": (u32, [u32]), "glShaderSource": (None, [u32, i32, vp, vp]),
            "glCompileShader": (None, [u32]), "glGetShaderiv": (None, [u32, u32, vp]),
            "glGetShaderInfoLog": (None, [u32, i32, vp, ctypes.c_char_p]),
            "glCreateProgram": (u32, []), "glAttachShader": (None, [u32, u32]),
            "glLinkProgram": (None, [u32]), "glGetProgramiv": (None, [u32, u32, vp]),
            "glGetProgramInfoLog": (None, [u32, i32, vp, ctypes.c_char_p]),
            "glUseProgram": (None, [u32]), "glGetUniformLocation": (i32, [u32, ctypes.c_char_p]),
            "glUniform1f": (None, [i32, f32]), "glUniform2f": (None, [i32, f32, f32]),
            "glUniform1i": (None, [i32, i32]), "glViewport": (None, [i32, i32, i32, i32]),
            "glDrawArrays": (None, [u32, i32, i32]), "glGenTextures": (None, [i32, vp]),
            "glBindTexture": (None, [u32, u32]), "glActiveTexture": (None, [u32]),
            "glPixelStorei": (None, [u32, i32]), "glTexParameteri": (None, [u32, u32, i32]),
            "glTexImage2D": (None, [u32, i32, i32, i32, i32, i32, u32, u32, vp]),
        }
        for name, (res, args) in sig.items():
            fn = getattr(L, name)
            fn.restype, fn.argtypes = res, args

    def _compile(self, kind, src):
        L = self.lib
        sh = L.glCreateShader(kind)
        buf = ctypes.c_char_p(src.encode())
        L.glShaderSource(sh, 1, ctypes.byref(buf), None)
        L.glCompileShader(sh)
        ok = ctypes.c_int()
        L.glGetShaderiv(sh, GL_COMPILE_STATUS, ctypes.byref(ok))
        if not ok.value:
            log = ctypes.create_string_buffer(4096)
            L.glGetShaderInfoLog(sh, 4096, None, log)
            raise RuntimeError("shader compile failed:\n" + log.value.decode(errors="replace"))
        return sh

    def program(self, vsrc, fsrc):
        L = self.lib
        prog = L.glCreateProgram()
        L.glAttachShader(prog, self._compile(GL_VERTEX_SHADER, vsrc))
        L.glAttachShader(prog, self._compile(GL_FRAGMENT_SHADER, fsrc))
        L.glLinkProgram(prog)
        ok = ctypes.c_int()
        L.glGetProgramiv(prog, GL_LINK_STATUS, ctypes.byref(ok))
        if not ok.value:
            log = ctypes.create_string_buffer(4096)
            L.glGetProgramInfoLog(prog, 4096, None, log)
            raise RuntimeError("program link failed:\n" + log.value.decode(errors="replace"))
        return prog


class Saver:
    def __init__(self, image_path):
        img = Image.open(image_path).convert("RGB")
        if img.width > 3840:
            img = img.resize((3840, round(img.height * 3840 / img.width)), Image.LANCZOS)
        self.img, self.t0 = img, time.monotonic()

    def realize(self, area):
        area.make_current()
        if area.get_error() is not None:
            raise SystemExit("GL context error: %s" % area.get_error().message)
        self.gl = GL()
        L = self.gl.lib
        self.prog = self.gl.program(VERT, FRAG)
        self.u = {n: L.glGetUniformLocation(self.prog, n.encode())
                  for n in ("u_img", "u_res", "u_imgres", "u_time")}
        tex = ctypes.c_uint()
        L.glGenTextures(1, ctypes.byref(tex))
        self.tex = tex.value
        L.glBindTexture(GL_TEXTURE_2D, self.tex)
        L.glPixelStorei(GL_UNPACK_ALIGNMENT, 1)
        data = self.img.tobytes()
        L.glTexImage2D(GL_TEXTURE_2D, 0, GL_RGB, self.img.width, self.img.height, 0,
                       GL_RGB, GL_UNSIGNED_BYTE, ctypes.c_char_p(data))
        for p, v in ((GL_MIN, GL_LINEAR), (GL_MAG, GL_LINEAR),
                     (GL_WRAP_S, GL_CLAMP_TO_EDGE), (GL_WRAP_T, GL_CLAMP_TO_EDGE)):
            L.glTexParameteri(GL_TEXTURE_2D, p, v)

    def render(self, area, _ctx):
        L = self.gl.lib
        s = area.get_scale_factor()
        w, h = area.get_allocated_width() * s, area.get_allocated_height() * s
        L.glViewport(0, 0, w, h)
        L.glUseProgram(self.prog)
        L.glActiveTexture(GL_TEXTURE0)
        L.glBindTexture(GL_TEXTURE_2D, self.tex)
        L.glUniform1i(self.u["u_img"], 0)
        L.glUniform2f(self.u["u_res"], w, h)
        L.glUniform2f(self.u["u_imgres"], self.img.width, self.img.height)
        L.glUniform1f(self.u["u_time"], time.monotonic() - self.t0)
        L.glDrawArrays(GL_TRIANGLES, 0, 3)
        return True


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawTextHelpFormatter)
    ap.add_argument("--image", required=True)
    ap.add_argument("--index", type=int, default=0, help="monitor index (same order as hyprctl monitors)")
    ap.add_argument("--fps", type=int, default=30)
    args = ap.parse_args()

    display = Gdk.Display.get_default()
    n = display.get_n_monitors()
    monitor = display.get_monitor(min(args.index, n - 1))

    win = Gtk.Window()
    win.set_decorated(False)
    GtkLayerShell.init_for_window(win)
    GtkLayerShell.set_namespace(win, "neon-saver")
    GtkLayerShell.set_layer(win, GtkLayerShell.Layer.OVERLAY)
    for edge in (GtkLayerShell.Edge.TOP, GtkLayerShell.Edge.BOTTOM,
                 GtkLayerShell.Edge.LEFT, GtkLayerShell.Edge.RIGHT):
        GtkLayerShell.set_anchor(win, edge, True)
    GtkLayerShell.set_exclusive_zone(win, -1)                 # cover the bars too
    GtkLayerShell.set_keyboard_mode(win, GtkLayerShell.KeyboardMode.NONE)
    GtkLayerShell.set_monitor(win, monitor)

    saver = Saver(args.image)
    area = Gtk.GLArea()
    area.set_use_es(True)
    area.set_required_version(3, 0)
    area.set_auto_render(False)
    area.connect("realize", saver.realize)
    area.connect("render", saver.render)
    win.add(area)
    win.show_all()
    win.get_window().input_shape_combine_region(cairo.Region(), 0, 0)   # never steal input

    state = {"last": 0.0}
    min_dt = 1.0 / args.fps - 0.002

    def tick(_w, _clock):
        now = time.monotonic()
        if now - state["last"] >= min_dt:
            state["last"] = now
            area.queue_render()
        return GLib.SOURCE_CONTINUE

    area.add_tick_callback(tick)
    try:
        from gi.repository import GLibUnix
        add_signal = GLibUnix.signal_add
    except ImportError:
        add_signal = GLib.unix_signal_add
    add_signal(GLib.PRIORITY_DEFAULT, 2, Gtk.main_quit)    # SIGINT
    add_signal(GLib.PRIORITY_DEFAULT, 15, Gtk.main_quit)   # SIGTERM
    Gtk.main()


if __name__ == "__main__":
    main()
