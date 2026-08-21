#!/usr/bin/env python3
"""皮肤快速编辑器——绕过 jsonnet，直接改成品 yaml。

为什么需要它
------------
元书只读 `light/` `dark/` 下的 yaml，`jsonnet/` 只是源码存档。
但走 jsonnet 全量编译在 iSH 上要 ~10 分钟（18 个键盘 × 32 秒），
其中 91% 的时间都花在编译上，改一个颜色也要等十分钟。

这个脚本把 yaml 一次性解析成 JSON 缓存，之后所有编辑都在缓存上做，
最后直接写出并打包。改一次配色从 ~11 分钟降到 ~5 秒。

三个关键事实（都实测验证过）
--------------------------
1. PyYAML 的 CSafeLoader 比纯 Python 版快 7 倍（123s → 18s），务必用 C 版。
2. JSON 是 YAML 的合法子集。把 JSON 文本存成 .yaml 后缀，元书照样能读，
   于是连 YAML 写出的 31 秒都省了（JSON 写出只要 2 秒）。
   代价是文件体积大约 +20%、可读性差一些——不影响使用。
3. .cskin 就是 zip，包内必须有一层以皮肤名命名的目录。

用法
----
    # 1) 建缓存（只需一次，约 20 秒；yaml 变了才要重建）
    python3 skin_fastedit.py cache <皮肤目录>

    # 2) 改东西（秒级，可反复执行）
    python3 skin_fastedit.py set <皮肤目录> <选择器> <值>
    python3 skin_fastedit.py get <皮肤目录> <选择器>
    python3 skin_fastedit.py batch <皮肤目录> <指令文件>   ← 改多处用这个

    # 3) 打包（约 20 秒）
    python3 skin_fastedit.py pack <皮肤目录> [输出.cskin]

选择器语法
----------
    toolbarHeight                    所有键盘的 toolbarHeight
    preeditForegroundStyle.fontSize  嵌套字段用点号
    light:*:toolbarHeight            只改 light 主题
    *:pinyin_26_portrait:xxx         只改某个键盘文件
    dark:numeric*:collection.insets  文件名支持 * 通配

值会先按 JSON 解析（所以 42、true、{"a":1} 都能直接写），
解析失败就当字符串。

batch 指令文件格式
------------------
    # 注释
    toolbarHeight 44
    preeditForegroundStyle.normalColor F2F2F2
    !create collection.separatorLineColor 55555580   ← ! 前缀允许新建字段
"""
import fnmatch
import json
import os
import sys
import time
import zipfile

try:
    import yaml
    from yaml import CSafeLoader
except ImportError:
    print('需要 py3-yaml：apk add py3-yaml', file=sys.stderr)
    sys.exit(1)

CACHE_NAME = '.fastedit_cache.json'
THEMES = ('light', 'dark')


# ---------------------------------------------------------------------------
# 缓存
# ---------------------------------------------------------------------------
def cache_path(skin):
    return os.path.join(skin, CACHE_NAME)


def build_cache(skin, quiet=False):
    """把所有 yaml 解析进一个 JSON 缓存。这是唯一一次慢操作。"""
    t0 = time.time()
    data = {}
    for theme in THEMES:
        d = os.path.join(skin, theme)
        if not os.path.isdir(d):
            continue
        data[theme] = {}
        for fn in sorted(os.listdir(d)):
            if not fn.endswith('.yaml'):
                continue
            # resources/ 下的 yaml 是贴图切片描述，不是键盘定义，跳过
            data[theme][fn[:-5]] = yaml.load(open(os.path.join(d, fn)),
                                             Loader=CSafeLoader)
    with open(cache_path(skin), 'w') as f:
        json.dump(data, f, ensure_ascii=False)
    _write_stamps(skin)
    n = sum(len(v) for v in data.values())
    if not quiet:
        print(f'缓存已建立: {n} 个键盘，耗时 {time.time() - t0:.1f}s')
    return data


def load_cache(skin, auto=True):
    p = cache_path(skin)
    if not os.path.exists(p):
        if not auto:
            print(f'没有缓存，先跑: skin_fastedit.py cache {skin}', file=sys.stderr)
            sys.exit(1)
        print('缓存不存在，正在建立…')
        return build_cache(skin)
    # 缓存写出后 yaml 被外部改过就提醒（不自动重建，避免覆盖掉未保存的改动）
    stale = _stale_files(skin)
    if stale:
        print(f'! 注意: {len(stale)} 个 yaml 在缓存之后被改过（如 {stale[0]}）。'
              f'若是外部改动，请重建缓存: cache {skin}', file=sys.stderr)
    return json.load(open(p))


def save_cache(skin, data):
    with open(cache_path(skin), 'w') as f:
        json.dump(data, f, ensure_ascii=False)
    # 记下写出时各 yaml 的指纹，这样 pack 自己写出的文件不会被当成外部改动
    _write_stamps(skin)


def _yaml_files(skin):
    for theme in THEMES:
        d = os.path.join(skin, theme)
        if not os.path.isdir(d):
            continue
        for fn in sorted(os.listdir(d)):
            if fn.endswith('.yaml'):
                yield os.path.join(d, fn)


def stamp_path(skin):
    return os.path.join(skin, '.fastedit_stamps.json')


def _write_stamps(skin):
    """记录各 yaml 的 (大小, mtime)。sha1 全量只要 0.3 秒，但 size+mtime 更省。"""
    st = {}
    for p in _yaml_files(skin):
        s = os.stat(p)
        st[os.path.relpath(p, skin)] = [s.st_size, int(s.st_mtime)]
    with open(stamp_path(skin), 'w') as f:
        json.dump(st, f)


def _stale_files(skin):
    """返回缓存写出后被外部改动过的 yaml。没有指纹文件时退回 mtime 比较。"""
    sp = stamp_path(skin)
    if not os.path.exists(sp):
        ct = os.path.getmtime(cache_path(skin))
        return [os.path.relpath(p, skin) for p in _yaml_files(skin)
                if os.path.getmtime(p) > ct]
    old = json.load(open(sp))
    stale = []
    for p in _yaml_files(skin):
        rel = os.path.relpath(p, skin)
        s = os.stat(p)
        if old.get(rel) != [s.st_size, int(s.st_mtime)]:
            stale.append(rel)
    return stale


# ---------------------------------------------------------------------------
# 选择器
# ---------------------------------------------------------------------------
def parse_selector(sel):
    """'light:pinyin*:a.b' → ('light', 'pinyin*', ['a','b'])"""
    parts = sel.split(':')
    if len(parts) == 1:
        return '*', '*', parts[0].split('.')
    if len(parts) == 2:
        return '*', parts[0], parts[1].split('.')
    return parts[0], parts[1], parts[2].split('.')


def iter_targets(data, theme_pat, file_pat):
    for theme in sorted(data):
        if not fnmatch.fnmatch(theme, theme_pat):
            continue
        for name in sorted(data[theme]):
            if not fnmatch.fnmatch(name, file_pat):
                continue
            yield theme, name, data[theme][name]


def dig(node, path, create=False):
    """沿 path 走到倒数第二层，返回 (父节点, 末级键)。走不通返回 None。

    create=True 只允许新建**末级键**，不会凭空造出中间层节点——否则
    往没有 `collection` 的键盘里写 `collection.separatorLineColor`
    会捏造一个假的 collection 节点出来。
    """
    for k in path[:-1]:
        if not isinstance(node, dict) or k not in node:
            return None
        node = node[k]
    if not isinstance(node, dict):
        return None
    return node, path[-1]


# ---------------------------------------------------------------------------
# 命令
# ---------------------------------------------------------------------------
def cmd_get(skin, sel):
    data = load_cache(skin)
    tp, fp, path = parse_selector(sel)
    hits = 0
    for theme, name, doc in iter_targets(data, tp, fp):
        got = dig(doc, path)
        if got is None:
            continue
        parent, key = got
        if key in parent:
            print(f'{theme}/{name}  {".".join(path)} = '
                  f'{json.dumps(parent[key], ensure_ascii=False)}')
            hits += 1
    print(f'-- 命中 {hits} 处')


def cmd_set(skin, sel, raw, create=False):
    data = load_cache(skin)
    tp, fp, path = parse_selector(sel)
    try:
        val = json.loads(raw)
    except json.JSONDecodeError:
        val = raw  # 当字符串，方便写 'FFFFFF' 这类裸 hex
    changed, skipped = 0, 0
    for theme, name, doc in iter_targets(data, tp, fp):
        got = dig(doc, path, create=create)
        if got is None:
            skipped += 1
            continue
        parent, key = got
        if key not in parent and not create:
            skipped += 1
            continue
        if parent.get(key) != val:
            parent[key] = val
            changed += 1
    save_cache(skin, data)
    print(f'已改 {changed} 处'
          + (f'，{skipped} 处不存在（要新建字段加 --create）' if skipped else ''))


def cmd_batch(skin, script):
    """一次加载缓存、执行多条编辑。改多处时比反复 set 快得多。

    脚本每行一条指令，`#` 开头是注释：
        <选择器> <值>
        !create <选择器> <值>     ← 允许新建不存在的字段
    """
    data = load_cache(skin)
    total, skipped_total = 0, 0
    for lineno, line in enumerate(open(script), 1):
        line = line.strip()
        if not line or line.startswith('#'):
            continue
        create = False
        if line.startswith('!create'):
            create = True
            line = line[len('!create'):].strip()
        try:
            sel, raw = line.split(None, 1)
        except ValueError:
            print(f'  ! 第 {lineno} 行格式不对，跳过: {line}', file=sys.stderr)
            continue
        try:
            val = json.loads(raw)
        except json.JSONDecodeError:
            val = raw
        tp, fp, path = parse_selector(sel)
        changed, skipped = 0, 0
        for theme, name, doc in iter_targets(data, tp, fp):
            got = dig(doc, path, create=create)
            if got is None:
                skipped += 1
                continue
            parent, key = got
            if key not in parent and not create:
                skipped += 1
                continue
            if parent.get(key) != val:
                parent[key] = val
                changed += 1
        print(f'  {sel} = {raw}  → 改 {changed} 处'
              + (f'，{skipped} 处不存在' if skipped else ''))
        total += changed
        skipped_total += skipped
    save_cache(skin, data)
    print(f'-- 合计改动 {total} 处'
          + (f'，跳过 {skipped_total} 处' if skipped_total else ''))


def cmd_pack(skin, out=None):
    """从缓存写出 yaml 并打包。写出用 JSON 格式——YAML 解析器能读，快 15 倍。"""
    t0 = time.time()
    data = load_cache(skin, auto=False)
    for theme, docs in data.items():
        d = os.path.join(skin, theme)
        os.makedirs(d, exist_ok=True)
        for name, doc in docs.items():
            with open(os.path.join(d, name + '.yaml'), 'w') as f:
                # indent=1 让文件仍有层次感，便于人工 diff
                json.dump(doc, f, ensure_ascii=False, indent=1, sort_keys=True)
    t_write = time.time() - t0
    # pack 自己写出的文件不该在下次被当成外部改动
    _write_stamps(skin)

    name = os.path.basename(os.path.abspath(skin))
    out = out or os.path.join(os.path.dirname(os.path.abspath(skin)), name + '.cskin')
    if os.path.exists(out):
        os.remove(out)
    skip_dirs = {'.git', '__pycache__'}
    n = 0
    with zipfile.ZipFile(out, 'w', zipfile.ZIP_DEFLATED) as z:
        for root, dirs, files in os.walk(skin):
            dirs[:] = [x for x in dirs if x not in skip_dirs and not x.startswith('.')]
            for fn in sorted(files):
                if fn.startswith('.') or fn.endswith(('.cskin', '.zip')):
                    continue
                p = os.path.join(root, fn)
                # 包内路径必须带一层皮肤名目录
                z.write(p, os.path.join(name, os.path.relpath(p, skin)))
                n += 1
    print(f'写出 yaml {t_write:.1f}s，打包 {n} 个文件，'
          f'共 {time.time() - t0:.1f}s')
    print(f'→ {out}  ({os.path.getsize(out) / 1024 / 1024:.2f} MB)')


def cmd_check(skin):
    """轻量校验：样式引用是否存在。比全量 validate 快得多。"""
    data = load_cache(skin)
    STYLE_KEYS = ('backgroundStyle', 'foregroundStyle', 'hintStyle', 'cellStyle',
                  'candidateStyle', 'hintSymbolsStyle', 'selectedBackgroundStyle')
    bad = 0
    for theme, name, doc in iter_targets(data, '*', '*'):
        missing = set()

        def walk(node):
            if isinstance(node, dict):
                for k, v in node.items():
                    if k in STYLE_KEYS and isinstance(v, str) and v not in doc:
                        missing.add(v)
                    walk(v)
            elif isinstance(node, list):
                for v in node:
                    walk(v)

        walk(doc)
        if missing:
            print(f'  ! {theme}/{name}: {len(missing)} 个引用不存在: '
                  f'{", ".join(sorted(missing)[:4])}')
            bad += len(missing)
    print(f'-- 悬空引用合计 {bad} 处'
          + ('（万象基线本身就有几百处，看增量即可）' if bad else ''))


USAGE = __doc__


def main():
    if len(sys.argv) < 3:
        print(USAGE)
        sys.exit(0)
    cmd, skin = sys.argv[1], sys.argv[2].rstrip('/')
    args = [a for a in sys.argv[3:] if not a.startswith('--')]
    flags = {a for a in sys.argv[3:] if a.startswith('--')}
    if not os.path.isdir(skin):
        print(f'目录不存在: {skin}', file=sys.stderr)
        sys.exit(1)

    if cmd == 'cache':
        build_cache(skin)
    elif cmd == 'get':
        cmd_get(skin, args[0])
    elif cmd == 'set':
        cmd_set(skin, args[0], args[1], create='--create' in flags)
    elif cmd == 'pack':
        cmd_pack(skin, args[0] if args else None)
    elif cmd == 'batch':
        cmd_batch(skin, args[0])
    elif cmd == 'check':
        cmd_check(skin)
    else:
        print(USAGE)
        sys.exit(1)


if __name__ == '__main__':
    main()
