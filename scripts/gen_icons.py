#!/usr/bin/env python3
"""
FluentEcho App Icon Generator
Design: solid blue background, upward echo arcs fading outward.

Requirements: pip install Pillow numpy
Usage:        python scripts/gen_icons.py
"""

import os
import sys
import numpy as np

try:
    from PIL import Image, ImageDraw, ImageFilter
except ImportError:
    print("Error: pip install Pillow numpy")
    sys.exit(1)

SOURCE_SIZE = 1024

ANDROID_SIZES = [
    ("mipmap-mdpi",    48),
    ("mipmap-hdpi",    72),
    ("mipmap-xhdpi",   96),
    ("mipmap-xxhdpi",  144),
    ("mipmap-xxxhdpi", 192),
]

# ── helpers ──────────────────────────────────────────────────────────────────

def hex_rgb(h):
    h = h.lstrip("#")
    return tuple(int(h[i:i+2], 16) for i in (0, 2, 4))

def lerp_c(c1, c2, t):
    return tuple(int(c1[i] + (c2[i] - c1[i]) * t) for i in range(3))

def safe_paste(base, overlay, pos):
    px, py = int(pos[0]), int(pos[1])
    ow, oh = overlay.size
    bw, bh = base.size
    cx1, cy1 = max(0, -px), max(0, -py)
    cx2, cy2 = min(ow, bw - px), min(oh, bh - py)
    if cx2 > cx1 and cy2 > cy1:
        base.alpha_composite(overlay.crop((cx1, cy1, cx2, cy2)),
                             (max(0, px), max(0, py)))
    return base

def rounded_rect_mask(w, h, r, draw):
    r = min(r, w // 2, h // 2)
    try:
        draw.rounded_rectangle([0, 0, w - 1, h - 1], radius=r, fill=255)
    except AttributeError:
        draw.rectangle([r, 0, w - 1 - r, h - 1], fill=255)
        draw.rectangle([0, r, w - 1, h - 1 - r], fill=255)
        for ex, ey in [(0, 0), (w - 1 - r*2, 0), (0, h - 1 - r*2), (w - 1 - r*2, h - 1 - r*2)]:
            draw.ellipse([ex, ey, ex + r*2, ey + r*2], fill=255)

# ── drawing primitives ───────────────────────────────────────────────────────

def make_bg(size):
    """Solid blue background (#0A6EFF)."""
    yg, xg = np.mgrid[0:size, 0:size]
    # t = 0 at bottom-right, 1 at top-left
    t = np.clip(((size - 1 - xg) * 0.38 + (size - 1 - yg) * 0.62) / (size - 1), 0, 1)

    stops = [
        (0.00, np.array([10, 110, 255])),  # #0A6EFF
        (1.00, np.array([10, 110, 255])),  # #0A6EFF
    ]

    arr = np.zeros((size, size, 4), dtype=np.float64)
    for c in range(3):
        channel = np.zeros_like(t)
        for k in range(len(stops) - 1):
            t0, c0 = stops[k]
            t1, c1 = stops[k + 1]
            mask = (t >= t0) & (t <= t1)
            local = np.where(mask, (t - t0) / (t1 - t0), 0.0)
            channel += mask * (c0[c] * (1 - local) + c1[c] * local)
        arr[:, :, c] = channel
    arr[:, :, 3] = 255
    return Image.fromarray(np.clip(arr, 0, 255).astype(np.uint8), "RGBA")


def radial_glow(img, cx, cy, radius, color, intensity):
    yg, xg = np.mgrid[0:img.height, 0:img.width]
    d = np.sqrt((xg - cx)**2 + (yg - cy)**2)
    t = np.clip(1 - d / radius, 0, 1) ** 2
    arr = np.zeros((img.height, img.width, 4), dtype=np.uint8)
    for c, v in enumerate(color):
        arr[:, :, c] = v
    arr[:, :, 3] = np.clip(t * intensity * 255, 0, 255).astype(np.uint8)
    return Image.alpha_composite(img, Image.fromarray(arr, "RGBA"))


def bar_glow(base, x, y_top, w, h, color, blur):
    pad = blur * 4
    g = Image.new("RGBA", (w + pad*2, h + pad*2), (0, 0, 0, 0))
    ImageDraw.Draw(g).rectangle([pad, pad, pad+w-1, pad+h-1], fill=(*color, 190))
    g = g.filter(ImageFilter.GaussianBlur(blur))
    return safe_paste(base, g, (x - pad, y_top - pad))


def gradient_bar(base, x, y_top, w, h, c_top, c_bot, radius, alpha=255):
    arr = np.zeros((h, w, 4), dtype=np.uint8)
    t = np.linspace(0, 1, h)[:, np.newaxis]   # 0=top 1=bottom
    for c in range(3):
        arr[:, :, c] = np.clip(c_top[c]*(1-t) + c_bot[c]*t, 0, 255).astype(np.uint8)
    arr[:, :, 3] = alpha
    bar = Image.fromarray(arr, "RGBA")
    mask = Image.new("L", (w, h), 0)
    rounded_rect_mask(w, h, radius, ImageDraw.Draw(mask))
    bar.putalpha(mask)
    return safe_paste(base, bar, (x, y_top))


def echo_arc(base, cx, cy, r, color, stroke_w, opacity, blur):
    pad = blur * 5 + stroke_w + 4
    sz = int(r * 2 + pad * 2)
    arc = Image.new("RGBA", (sz, sz), (0, 0, 0, 0))
    acx = acy = sz // 2
    ImageDraw.Draw(arc).arc(
        [acx - r, acy - r, acx + r, acy + r],
        start=180, end=360,
        fill=(*color, opacity), width=stroke_w
    )
    if blur > 0:
        glow = arc.filter(ImageFilter.GaussianBlur(blur))
        arc = Image.alpha_composite(glow, arc)
    return safe_paste(base, arc, (cx - sz//2, cy - sz//2))


def draw_E_ghost(base, cx, cy, height, width, stroke, color):
    """Subtle ghost 'E' letterform blended into the background."""
    left   = cx - width // 2
    right  = cx + width // 2
    top    = cy - height // 2
    bottom = cy + height // 2
    mid    = (top + bottom) // 2
    s      = stroke

    # Draw solid E on a separate layer
    e_layer = Image.new("RGBA", base.size, (0, 0, 0, 0))
    d = ImageDraw.Draw(e_layer)
    fill = (*color, 255)
    d.rectangle([left,          top,         left + s,               bottom      ], fill=fill)  # vertical stroke
    d.rectangle([left,          top,         right,                  top + s     ], fill=fill)  # top bar
    d.rectangle([left, mid - s//2, left + int(width * 0.78), mid + s//2         ], fill=fill)  # middle bar (slightly shorter)
    d.rectangle([left,          bottom - s,  right,                  bottom      ], fill=fill)  # bottom bar

    # Soft blur to make the E a gentle shape impression
    soft = e_layer.filter(ImageFilter.GaussianBlur(8))
    soft_arr = np.array(soft, dtype=np.float32)
    soft_arr[:, :, 3] = np.clip(soft_arr[:, :, 3] * 0.22, 0, 255)
    soft = Image.fromarray(soft_arr.astype(np.uint8), "RGBA")

    base = Image.alpha_composite(base, soft)
    return base

# ── composition ──────────────────────────────────────────────────────────────

def create_icon(size=SOURCE_SIZE):
    s = size / SOURCE_SIZE

    # 1. Background
    img = make_bg(size)

    # 2. Arc emission center (below the icon, arcs fan upward from the bottom)
    arc_cx = int(512 * s)
    arc_cy = int(840 * s)

    # 3. Ambient glow around the arc center
    img = radial_glow(img, arc_cx, arc_cy, int(520*s), hex_rgb("#2860DD"), 0.50)
    img = radial_glow(img, arc_cx, int(380*s), int(350*s), hex_rgb("#40AAEE"), 0.38)

    # 4. Echo arcs radiating upward (5 arcs, white inner to light blue outer)
    # Each arc: (radius, color, stroke_width, opacity, blur_radius)
    arcs = [
        (int(112*s), hex_rgb("#FFFFFF"), max(3, int(11*s)), 240, 0),
        (int(200*s), hex_rgb("#E8F2FF"), max(3, int(10*s)), 215, 0),
        (int(298*s), hex_rgb("#D0E4FF"), max(2, int(9*s)),  190, 0),
        (int(400*s), hex_rgb("#B8D6FF"), max(2, int(7*s)),  165, 0),
        (int(492*s), hex_rgb("#A0C8FF"), max(2, int(5*s)),  140, 0),
    ]
    for r, col, w, op, bl in arcs:
        img = echo_arc(img, arc_cx, arc_cy, r, col, w, op, bl)

    # 5. Rounded corner mask
    mask = Image.new("L", img.size, 0)
    rounded_rect_mask(img.width, img.height, int(200*s), ImageDraw.Draw(mask))
    img.putalpha(mask)

    return img

# ── output ───────────────────────────────────────────────────────────────────

def save_icons(source, project_root):
    for folder, sz in ANDROID_SIZES:
        out = os.path.join(project_root, "android", "app", "src", "main",
                           "res", folder, "ic_launcher.png")
        os.makedirs(os.path.dirname(out), exist_ok=True)
        resized = source.resize((sz, sz), Image.LANCZOS)
        resized.save(out)
        print(f"  Android {folder}: {sz}x{sz}")

    src_out = os.path.join(project_root, "assets", "icons", "app_icon_1024.png")
    os.makedirs(os.path.dirname(src_out), exist_ok=True)
    source.save(src_out)
    print(f"  Source 1024x1024 → assets/icons/app_icon_1024.png")


if __name__ == "__main__":
    print("Generating FluentEcho icon...")
    icon = create_icon(SOURCE_SIZE)
    root = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
    save_icons(icon, root)
    print("\nDone. Run: flutter clean && flutter pub get")
