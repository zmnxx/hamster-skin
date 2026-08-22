"""用真实截图合成 demo 预览图：截图作为本体，AI 生成的影棚背景作为展示台。
比让生图模型画键盘可靠——键帽渐变、描边、字距全是实机像素，零偏差。
"""
from PIL import Image, ImageDraw, ImageFilter, ImageFont

SHOT = "/var/minis/attachments/uploads/photo_DD01E1E6.jpeg"
STAGE = "/var/minis/workspace/skinwork/stage.png"
OUT = "/var/minis/workspace/hs/demo.png"

SHOT_TOP = 58          # 背板上边界 18 + preedit 预留空区 40px，裁掉后构图更紧凑
CORNER = 26            # 顶部圆角，裁切后自己重切

W, H = 1200, 900

# ---- 展示台 ----
stage = Image.open(STAGE).convert("RGB")
sw, sh = stage.size
sc = max(W / sw, H / sh)
stage = stage.resize((round(sw * sc), round(sh * sc)), Image.LANCZOS)
bg = stage.crop(((stage.width - W) // 2, (stage.height - H) // 2,
                 (stage.width - W) // 2 + W, (stage.height - H) // 2 + H))

# ---- 键盘本体 ----
kb = Image.open(SHOT).convert("RGB").crop((0, SHOT_TOP, 1170, 912))
target_w = 900
kb = kb.resize((target_w, round(kb.height * target_w / kb.width)), Image.LANCZOS)

# 四角统一切圆角
mask = Image.new("L", kb.size, 0)
ImageDraw.Draw(mask).rounded_rectangle([0, 0, kb.width - 1, kb.height - 1],
                                       CORNER, fill=255)
kb.putalpha(mask)

kx = (W - kb.width) // 2
ky = 96

# ---- 投影 ----
sd = Image.new("RGBA", (W, H), (0, 0, 0, 0))
ImageDraw.Draw(sd).rounded_rectangle(
    [kx + 6, ky + 16, kx + kb.width - 6, ky + kb.height + 10],
    CORNER + 8, fill=(0, 0, 0, 68))
sd = sd.filter(ImageFilter.GaussianBlur(22))

out = bg.convert("RGBA")
out.alpha_composite(sd)
out.alpha_composite(kb, (kx, ky))

# ---- 标题 ----
dr = ImageDraw.Draw(out)
BOLD = "/usr/share/fonts/noto/NotoSansCJK-Bold.ttc"
REG = "/usr/share/fonts/noto/NotoSansCJK-Regular.ttc"
cy = ky + kb.height + 46
dr.text((W // 2, cy), "元书皮肤", font=ImageFont.truetype(BOLD, 34),
        fill=(0x1C, 0x1C, 0x1E, 255), anchor="mm")
dr.text((W // 2, cy + 34), "万象 · 空山键帽 · 深色",
        font=ImageFont.truetype(REG, 17), fill=(0x86, 0x86, 0x8B, 255), anchor="mm")

out.convert("RGB").save(OUT, "PNG", optimize=True)
print("saved", OUT, out.size)
