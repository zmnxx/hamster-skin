#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""渲染字体变体的工具栏对照预览图（在 runner 上跑，产物随 artifact 下载）。

几何全部取自用户皮肤 元书皮肤/dark 成品 yaml：
  toolbarHeight 42 / toolbarStyle insets L10 R10 / 8 键等宽 46.25pt
  toolbarButtonBackgroundStyle cornerRadius 15, insets T4 B4 L3 R3
  toolbar按键颜色 E5E5E5 / 高亮底 3D3D3D99 / 键盘背景 1C1C1E
  键帽 alphabeticBackgroundStyle cornerRadius 14, #414144→#212122,
       border #5D5D60, lowerEdge #000000, insets T3 B3 L4 R4
"""
import argparse
import glob
import os
from PIL import Image, ImageDraw, ImageFont

S = 3
SCREEN_W = 390
TB_H = 42
CAND_H = 42
KEY_H = 54
INSET_LR = 10
N = 8
CELL_W = (SCREEN_W - INSET_LR * 2) / N

KB_BG = (28, 28, 30)
FG = (229, 229, 229)
HL = (61, 61, 61, 153)
TEAL = (95, 199, 188)

LABELS = ["菜单", "搜索", "网址", "商店", "常用", "剪贴", "脚本", "收起"]


def pick_latin():
    for p in ("/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf",
              "/usr/share/fonts/dejavu/DejaVuSans.ttf"):
        if os.path.exists(p):
            return p
    return None


def pick_cjk():
    for pat in ("/usr/share/fonts/**/NotoSansCJK*.ttc",
                "/usr/share/fonts/**/NotoSansCJK*.otf",
                "/usr/share/fonts/opentype/noto/*CJK*"):
        m = glob.glob(pat, recursive=True)
        if m:
            return m[0]
    return None


def ctext(d, cx, cy, s, f, fill):
    bb = d.textbbox((0, 0), s, font=f)
    d.text((cx - (bb[2] + bb[0]) / 2, cy - (bb[3] + bb[1]) / 2), s, font=f, fill=fill)


def tracked(d, cx, cy, s, f, fill, tr):
    if not tr:
        ctext(d, cx, cy, s, f, fill)
        return
    bbs = [d.textbbox((0, 0), c, font=f) for c in s]
    ws = [b[2] - b[0] for b in bbs]
    total = sum(ws) + tr * S * (len(s) - 1)
    x = cx - total / 2
    for c, w, b in zip(s, ws, bbs):
        d.text((x - b[0], cy - (b[3] + b[1]) / 2), c, font=f, fill=fill)
        x += w + tr * S


def cx(i):
    return (INSET_LR + (i + 0.5) * CELL_W) * S


def fit_pt(fontpath, text, avail_w_pt, max_h_pt, tr=0.0):
    """二分找最大字号：宽不超格、高不超栏"""
    lo, hi, best = 4.0, 60.0, 4.0
    d = ImageDraw.Draw(Image.new("L", (1, 1)))
    for _ in range(40):
        mid = (lo + hi) / 2
        f = ImageFont.truetype(fontpath, int(mid * S))
        bbs = [d.textbbox((0, 0), c, font=f) for c in text]
        w = (sum(b[2] - b[0] for b in bbs) + tr * S * (len(text) - 1)) / S
        h = max(b[3] - b[1] for b in bbs) / S
        if w <= avail_w_pt and h <= max_h_pt:
            best, lo = mid, mid
        else:
            hi = mid
    return best


def vgrad(size, top, bot):
    w, h = size
    g = Image.new("RGB", (1, h))
    for y in range(h):
        t = y / max(1, h - 1)
        g.putpixel((0, y), tuple(int(top[k] + (bot[k] - top[k]) * t) for k in range(3)))
    return g.resize((w, h))


def keycap(im, x, y, w, h):
    ix, iy = 4 * S, 3 * S
    x0, y0, x1, y1 = int(x + ix), int(y + iy), int(x + w - ix), int(y + h - iy)
    r = int(14 * S)
    sh = Image.new("RGBA", im.size, (0, 0, 0, 0))
    ImageDraw.Draw(sh).rounded_rectangle([x0, y0 + int(2 * S), x1, y1 + int(2.4 * S)],
                                         radius=r, fill=(0, 0, 0, 235))
    im.alpha_composite(sh)
    g = vgrad((x1 - x0, y1 - y0), (65, 65, 68), (33, 33, 34)).convert("RGBA")
    mask = Image.new("L", (x1 - x0, y1 - y0), 0)
    ImageDraw.Draw(mask).rounded_rectangle([0, 0, x1 - x0 - 1, y1 - y0 - 1],
                                           radius=r, fill=255)
    im.paste(g, (x0, y0), mask)
    ImageDraw.Draw(im, "RGBA").rounded_rectangle(
        [x0, y0, x1, y1], radius=r, outline=(93, 93, 96, 255), width=max(1, int(S)))


def toolbar(fontpath, pt, tr, accent=True, sep=True, dim=True, press=2):
    im = Image.new("RGBA", (SCREEN_W * S, TB_H * S), KB_BG + (255,))
    d = ImageDraw.Draw(im, "RGBA")
    if press is not None:
        d.rounded_rectangle([(INSET_LR + press * CELL_W + 3) * S, 4 * S,
                             (INSET_LR + (press + 1) * CELL_W - 3) * S, (TB_H - 4) * S],
                            radius=15 * S, fill=HL)
    f = ImageFont.truetype(fontpath, int(pt * S))
    for i, s in enumerate(LABELS):
        if accent and i == 0:
            col = TEAL
        elif dim and 0 < i < N - 1:
            col = (198, 198, 203)
        else:
            col = (245, 245, 245)
        tracked(ImageDraw.Draw(im), cx(i), TB_H * S / 2, s, f, col, tr)
    if sep:
        xs = (INSET_LR + (N - 1) * CELL_W) * S
        for yy in range(int(11 * S), int(31 * S), int(3.3 * S)):
            d.line([xs, yy, xs, yy + int(1.5 * S)], fill=(100, 100, 106),
                   width=max(1, int(1.1 * S)))
    return im


def candbar(cjk):
    im = Image.new("RGBA", (SCREEN_W * S, CAND_H * S), KB_BG + (255,))
    d = ImageDraw.Draw(im, "RGBA")
    if not cjk:
        return im
    f = ImageFont.truetype(cjk, int(18 * S))
    x = 15 * S
    for i, c in enumerate(["元书", "元素", "缘书", "原书", "圆熟"]):
        bb = d.textbbox((0, 0), c, font=f)
        w = bb[2] - bb[0]
        if i == 0:
            d.rounded_rectangle([x - 8 * S, 6 * S, x + w + 8 * S, (CAND_H - 6) * S],
                                radius=8 * S, fill=(61, 61, 61, 255))
        d.text((x - bb[0], CAND_H * S / 2 - (bb[3] + bb[1]) / 2), c, font=f,
               fill=(255, 255, 255) if i == 0 else (180, 180, 184))
        x += w + 26 * S
        if x > (SCREEN_W - 50) * S:
            break
    return im


def keyrow(latin):
    im = Image.new("RGBA", (SCREEN_W * S, KEY_H * S), KB_BG + (255,))
    chars = "QWERTYUIOP"
    w = SCREEN_W * S / len(chars)
    f = ImageFont.truetype(latin, int(22 * S)) if latin else None
    fh = ImageFont.truetype(latin, int(9 * S)) if latin else None
    for i, ch in enumerate(chars):
        keycap(im, i * w, 0, w, KEY_H * S)
        if f:
            d = ImageDraw.Draw(im)
            ctext(d, i * w + w / 2, KEY_H * S * 0.60, ch, f, (242, 242, 242))
            ctext(d, i * w + w / 2, KEY_H * S * 0.20, str((i + 1) % 10), fh,
                  (150, 150, 156))
    return im


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--fontdir", required=True)
    ap.add_argument("--out", required=True)
    a = ap.parse_args()
    os.makedirs(a.out, exist_ok=True)

    latin, cjk = pick_latin(), pick_cjk()
    print("latin:", latin, "cjk:", cjk)

    fonts = sorted(glob.glob(os.path.join(a.fontdir, "*.ttf")))
    if not fonts:
        raise SystemExit("没找到字体")

    vis_w = CELL_W - 6
    rows = []
    # 基准行：系统 CJK 15pt（用户现状）
    if cjk:
        rows.append((cjk, 15.0, 0.0, "现状对照：系统黑体 15pt regular"))
    for fp in fonts:
        pt = fit_pt(fp, "收起", vis_w, TB_H * 0.95, tr=0.8)
        rows.append((fp, pt, 0.8,
                     f"{os.path.basename(fp)[:-4]}  自动定档 {pt:.1f}pt"))

    PAD, LBL, GAP = 18, 30, 18
    BLK = TB_H + CAND_H + KEY_H
    W = SCREEN_W * S + PAD * 2 * S
    rh = (LBL + BLK + GAP) * S
    canvas = Image.new("RGB", (W, int(rh * len(rows) + PAD * S)), (14, 14, 16))
    cd = ImageDraw.Draw(canvas)
    flab = ImageFont.truetype(cjk or latin, int(10.5 * S))

    y = PAD * S
    for fp, pt, tr, cap in rows:
        cd.text((PAD * S, y), cap, font=flab, fill=(152, 152, 160))
        yy = int(y + LBL * S * 0.72)
        canvas.paste(toolbar(fp, pt, tr).convert("RGB"), (PAD * S, yy))
        canvas.paste(candbar(cjk).convert("RGB"), (PAD * S, yy + TB_H * S))
        canvas.paste(keyrow(latin).convert("RGB"), (PAD * S, yy + (TB_H + CAND_H) * S))
        y += rh

    out = os.path.join(a.out, "toolbar_font_compare.png")
    canvas.save(out)
    print("saved", out, canvas.size)

    # 单独出一张纯工具栏放大图，便于看字形细节
    for fp, pt, tr, cap in rows:
        im = toolbar(fp, pt, tr, press=None)
        big = im.resize((im.width * 2, im.height * 2), Image.LANCZOS)
        big.convert("RGB").save(
            os.path.join(a.out, f"bar_{os.path.basename(fp)[:-4]}.png"))
    print("done")


if __name__ == "__main__":
    main()
