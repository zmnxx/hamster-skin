#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""构建元书皮肤专用工具栏 TTF 字体包（在 GitHub Actions 上跑）。

为什么要自建字体
----------------
iOS 中文系统字体 PingFang SC 字重只到 Semibold，而 2024 皮肤工具栏的
笔画/字高 = 13.5%、墨量 = 50%（实测其 88x44 PNG 图标）。用 text +
fontWeight 达不到这个重量。本脚本从 Noto Sans SC 可变字体抽 wght=900
静态实例（笔画/字高 17.5%），再横向压缩做长体化，让同宽度下能用更大字号。

横向压缩的副作用是竖笔变细：17.5% × xscale ≈ 目标值。xscale=0.78 时
约 13.7%，正好落在 2024 的 13.5% 附近。

流程
----
  1) 抽 wght 静态实例
  2) 子集化（只留工具栏汉字，17MB → 几十 KB）
  3) 长体化（横向 xscale，字形轮廓 + hmtx + 全局度量一起变换）
  4) 重命名字族（OFL 要求改名）
  5) 校验 + 量化统计（笔画/字高、墨量），与 2024 基准对比
"""
import argparse
import os
import numpy as np
from fontTools.ttLib import TTFont
from fontTools.varLib import instancer
from fontTools import subset
from fontTools.pens.recordingPen import DecomposingRecordingPen
from fontTools.pens.ttGlyphPen import TTGlyphPen
from fontTools.pens.transformPen import TransformPen
from fontTools.misc.transform import Transform
from PIL import Image, ImageDraw, ImageFont

# 2024 皮肤实测基准（12 张 toolbar_*.png 的平均值）
REF_STROKE_RATIO = 0.135
REF_INK = 0.501

DEFAULT_CHARS = "菜单搜索网址商店常用剪贴脚本收起"


def log(m):
    print(m, flush=True)


def build(src, out_path, chars, wght, xscale, family, style):
    log(f"\n{'='*66}\n构建 {os.path.basename(out_path)}  wght={wght} xscale={xscale}\n{'='*66}")

    # --- 1. 抽静态实例 ---
    f = TTFont(src)
    axes = {a.axisTag: (a.minValue, a.maxValue) for a in f["fvar"].axes}
    log(f"  源字体轴: {axes}")
    instancer.instantiateVariableFont(f, {"wght": wght}, inplace=True,
                                      updateFontNames=False)
    stage1 = out_path + ".s1.ttf"
    f.save(stage1)
    f.close()
    log(f"  [1] 静态实例 {os.path.getsize(stage1)/1e6:.1f}MB")

    # --- 2. 子集化 ---
    stage2 = out_path + ".s2.ttf"
    subset.main([
        stage1,
        f"--text={chars}",
        f"--output-file={stage2}",
        "--layout-features=",
        "--no-hinting",
        "--drop-tables+=DSIG",
        "--name-IDs=*",
        "--recalc-bounds",
    ])
    log(f"  [2] 子集化 {os.path.getsize(stage2)/1024:.1f}KB "
        f"({len(set(chars))} 字)")

    # --- 3. 长体化 ---
    f = TTFont(stage2)
    if abs(xscale - 1.0) > 1e-6:
        glyf, hmtx, gs = f["glyf"], f["hmtx"], f.getGlyphSet()
        newg = {}
        for name in list(glyf.keys()):
            rec = DecomposingRecordingPen(gs)      # 先分解复合字形
            gs[name].draw(rec)
            pen = TTGlyphPen(None)
            rec.replay(TransformPen(pen, Transform(xscale, 0, 0, 1.0, 0, 0)))
            newg[name] = pen.glyph()
        for name, g in newg.items():
            glyf[name] = g
            g.recalcBounds(glyf)
            aw, lsb = hmtx[name]
            hmtx[name] = (int(round(aw * xscale)), int(round(lsb * xscale)))
        head, hhea = f["head"], f["hhea"]
        head.xMin = int(round(head.xMin * xscale))
        head.xMax = int(round(head.xMax * xscale))
        for attr in ("advanceWidthMax", "minLeftSideBearing",
                     "minRightSideBearing", "xMaxExtent"):
            setattr(hhea, attr, int(round(getattr(hhea, attr) * xscale)))
        log(f"  [3] 长体化 ×{xscale}  ({len(newg)} 字形)")
    else:
        log("  [3] 长体化 跳过")

    # --- 4. 重命名 ---
    full, ps = f"{family} {style}", f"{family}-{style.replace(' ', '')}"
    nm = {1: family, 2: style, 3: f"{ps}:2026", 4: full, 6: ps,
          16: family, 17: style}
    for rec in f["name"].names:
        if rec.nameID in nm:
            rec.string = nm[rec.nameID]
    f.save(out_path)
    f.close()
    log(f"  [4] 重命名 family='{family}' ps='{ps}'")

    for t in (stage1, stage2):
        os.remove(t)

    # --- 5. 校验 ---
    chk = TTFont(out_path)
    cmap = chk.getBestCmap()
    missing = [c for c in set(chars) if ord(c) not in cmap]
    chk.close()
    size = os.path.getsize(out_path)
    log(f"  [5] 校验 {size/1024:.1f}KB  cmap {len(cmap)} 码位  "
        f"缺字 {missing if missing else '无'}")
    if missing:
        raise SystemExit(f"缺字: {missing}")
    return size


def measure(ttf, text="收起", target_h=42):
    """量笔画/字高与墨量，归一到统一字高后比较"""
    f = ImageFont.truetype(ttf, 120)
    im = Image.new("RGBA", (600, 300), (0, 0, 0, 0))
    d = ImageDraw.Draw(im)
    d.text((20, 40), text, font=f, fill=(0, 0, 0, 255))
    bb = im.getbbox()
    if not bb:
        return None
    im = im.crop(bb)
    r = target_h / im.height
    im = im.resize((max(1, int(im.width * r)), target_h), Image.LANCZOS)
    m = np.asarray(im)[:, :, 3] > 128
    rows = np.nonzero(m.sum(axis=1) > 0)[0]
    cols = np.nonzero(m.sum(axis=0) > 0)[0]
    h = rows[-1] - rows[0] + 1
    w = cols[-1] - cols[0] + 1
    ink = m.sum() / (h * w)
    runs = []
    for y in range(rows[0], rows[-1] + 1):
        c = 0
        for v in m[y]:
            if v:
                c += 1
            elif c:
                runs.append(c); c = 0
        if c:
            runs.append(c)
    return dict(stroke_ratio=float(np.median(runs) / h), ink=float(ink),
                aspect=w / h)


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--src", required=True)
    ap.add_argument("--outdir", required=True)
    ap.add_argument("--chars", default=DEFAULT_CHARS)
    ap.add_argument("--family", default="YuanshuToolbar")
    ap.add_argument("--variants", default="900:0.78,900:0.85,900:1.00,700:0.85",
                    help="wght:xscale 逗号分隔")
    a = ap.parse_args()
    os.makedirs(a.outdir, exist_ok=True)

    results = []
    for v in a.variants.split(","):
        wght, xs = v.split(":")
        wght, xs = int(wght), float(xs)
        style = f"W{wght}X{int(xs*100)}"
        out = os.path.join(a.outdir, f"{a.family}-{style}.ttf")
        size = build(a.src, out, a.chars, wght, xs, a.family, style)
        st = measure(out)
        st.update(name=os.path.basename(out), size=size, wght=wght, xscale=xs)
        results.append(st)

    log(f"\n{'='*78}\n对比 2024 基准（笔画/字高 {REF_STROKE_RATIO:.1%}  "
        f"墨量 {REF_INK:.1%}）\n{'='*78}")
    log(f"  {'字体':32s} {'体积':>8s} {'笔画/字高':>10s} {'墨量':>7s} "
        f"{'宽高比':>7s} {'vs2024':>7s}")
    log("  " + "-" * 76)
    for r in results:
        log(f"  {r['name']:32s} {r['size']/1024:6.1f}KB "
            f"{r['stroke_ratio']:9.1%} {r['ink']:6.1%} {r['aspect']:7.2f} "
            f"{r['stroke_ratio']/REF_STROKE_RATIO:6.2f}x")

    import json
    with open(os.path.join(a.outdir, "report.json"), "w") as fh:
        json.dump(dict(reference=dict(stroke_ratio=REF_STROKE_RATIO, ink=REF_INK),
                       variants=results), fh, ensure_ascii=False, indent=2)
    log(f"\n报告 → {a.outdir}/report.json")


if __name__ == "__main__":
    main()
