"""demo 预览图合成。

体积说明：这张图曾占包体 550KB（36%）。两个来源都已处理：
  1) AI 生成的影棚背景带胶片颗粒，PNG 无法有效压缩 —— 换成程序生成的
     平滑径向渐变，数学光滑，压缩率极高；
  2) 键盘本体来自 JPEG 截图，块噪声同样破坏压缩 —— 对大面积平坦区做
     保边降噪，文字与描边不动。
"""
from PIL import Image, ImageDraw, ImageFilter, ImageFont
import math

SHOT = "/var/minis/attachments/uploads/photo_DD01E1E6.jpeg"
OUT = "/var/minis/workspace/hs/demo.png"

SHOT_TOP = 58          # 背板上边界 18 + 让开 preedit 预留空区 40px
CORNER = 26
W, H = 1200, 900


def backdrop(w, h):
    """程序生成影棚背景：顶部柔光 + 四周轻微暗角。全平滑，PNG 压得极小。"""
    img = Image.new("RGB", (w, h))
    px = img.load()
    cx, cy = w / 2, h * 0.30          # 光源略偏上
    maxd = math.hypot(w / 2, h / 2)
    for y in range(h):
        for x in range(w):
            d = math.hypot(x - cx, y - cy) / maxd
            v = 246 - 26 * d * d       # 中心 246 → 边缘 220
            px[x, y] = (int(v), int(v), int(v + 2))
    return img


def denoise(im):
    """保边降噪：中值滤波抹掉 JPEG 块噪声，再与原图按边缘强度混合，
    保住文字和 1px 描边的锐度。"""
    smooth = im.filter(ImageFilter.MedianFilter(3))
    # 边缘图作为混合权重：边缘处用原图，平坦处用平滑图
    edge = im.convert("L").filter(ImageFilter.FIND_EDGES)
    edge = edge.filter(ImageFilter.MaxFilter(3)).point(lambda v: min(255, v * 4))
    return Image.composite(im, smooth, edge)


bg = backdrop(W, H)

kb = Image.open(SHOT).convert("RGB").crop((0, SHOT_TOP, 1170, 912))
target_w = 900
kb = kb.resize((target_w, round(kb.height * target_w / kb.width)), Image.LANCZOS)
kb = denoise(kb)

mask = Image.new("L", kb.size, 0)
ImageDraw.Draw(mask).rounded_rectangle([0, 0, kb.width - 1, kb.height - 1],
                                       CORNER, fill=255)
kb.putalpha(mask)

kx, ky = (W - kb.width) // 2, 96

sd = Image.new("RGBA", (W, H), (0, 0, 0, 0))
ImageDraw.Draw(sd).rounded_rectangle(
    [kx + 6, ky + 16, kx + kb.width - 6, ky + kb.height + 10],
    CORNER + 8, fill=(0, 0, 0, 68))
sd = sd.filter(ImageFilter.GaussianBlur(22))

out = bg.convert("RGBA")
out.alpha_composite(sd)
out.alpha_composite(kb, (kx, ky))

dr = ImageDraw.Draw(out)
BOLD = "/usr/share/fonts/noto/NotoSansCJK-Bold.ttc"
REG = "/usr/share/fonts/noto/NotoSansCJK-Regular.ttc"
cy = ky + kb.height + 46
dr.text((W // 2, cy), "元书皮肤", font=ImageFont.truetype(BOLD, 34),
        fill=(0x1C, 0x1C, 0x1E, 255), anchor="mm")
dr.text((W // 2, cy + 34), "万象 · 空山键帽 · 深色",
        font=ImageFont.truetype(REG, 17), fill=(0x86, 0x86, 0x8B, 255), anchor="mm")

# 调色板量化：这张图色彩本就集中（深灰键帽 + 浅灰底），192 色足够，
# 抖动避免渐变色带。
final = out.convert("RGB").quantize(colors=192, method=Image.MEDIANCUT,
                                   dither=Image.FLOYDSTEINBERG)
final.save(OUT, "PNG", optimize=True)

import os
print("saved", OUT, final.size, os.path.getsize(OUT) // 1024, "KB")
