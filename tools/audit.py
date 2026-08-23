#!/usr/bin/env python3
"""皮肤源码静态审计：找未被引用的颜色令牌 / 字号项 / 导出函数 / import。

只做文本级引用计数，不求精确（jsonnet 有动态字段名），
目的是给出「值得人工复核」的候选清单。
"""
import os, re, sys, collections

ROOT = sys.argv[1] if len(sys.argv) > 1 else '.'

files = []
for dp, _, fns in os.walk(ROOT):
    for fn in fns:
        if fn.endswith(('.libsonnet', '.jsonnet')):
            files.append(os.path.join(dp, fn))

src = {f: open(f, encoding='utf-8').read() for f in files}


def strip_comments(t):
    t = re.sub(r'/\*.*?\*/', '', t, flags=re.S)
    return re.sub(r'//[^\n]*', '', t)


code = {f: strip_comments(t) for f, t in src.items()}
allcode = '\n'.join(code.values())


def report(title, items):
    print('\n== %s ==' % title)
    if not items:
        print('  （无）')
    for i in items:
        print('  ' + i)


# ---------- 1. 颜色令牌 ----------
cf = os.path.join(ROOT, 'shared/styles/color.libsonnet')
tokens = collections.OrderedDict()
for m in re.finditer(r"^\s{2}'([^']+)':", code[cf], re.M):
    tokens[m.group(1)] = True
unused = []
for t in tokens:
    # 引用形式： ['令牌'] 或 '令牌' 出现在 color.libsonnet 之外
    hits = 0
    for f, t2 in code.items():
        if f == cf:
            continue
        if ("'%s'" % t) in t2:
            hits += 1
    if hits == 0:
        unused.append(t)
report('color.libsonnet 中未被其他文件引用的令牌', unused)

# ---------- 2. 字号项 ----------
ff = os.path.join(ROOT, 'shared/styles/fontSize.libsonnet')
if os.path.exists(ff):
    unused = []
    for m in re.finditer(r"^\s{2}'([^']+)':", code[ff], re.M):
        k = m.group(1)
        if sum(1 for f, t2 in code.items() if f != ff and ("'%s'" % k) in t2) == 0:
            unused.append(k)
    report('fontSize.libsonnet 中未被引用的字号项', unused)

# ---------- 3. 各 libsonnet 的导出函数/字段是否被引用 ----------
# 注意：jsonnet 里 `:: ` 成员既可能被别的文件用 `模块.名字` 调用，
# 也可能在本文件内用 `$.名字` / `self.名字` 自引用（万象大量这么写）。
# 两种都要算，否则会把大批活代码误报成死代码。
out = []
for f, t in code.items():
    base = os.path.basename(f)
    for m in re.finditer(r'^\s{2}(\w+)\s*(\([^)]*\))?::', t, re.M):
        name = m.group(1)
        pat = r'\.%s\b' % re.escape(name)
        # 本文件内的 $.name / self.name / this.name 自引用
        selfref = re.findall(r'(?:\$|self|this)\.%s\b' % re.escape(name), t)
        if selfref:
            continue
        hits = sum(1 for f2, t2 in code.items()
                   if f2 != f and re.search(pat, t2))
        if hits == 0:
            out.append('%-42s %s' % (base, name))
report('模块导出成员既无外部调用也无自引用', out)

# ---------- 4. import 是否使用 ----------
out = []
for f, t in code.items():
    for m in re.finditer(r"^local\s+(\w+)\s*=\s*import\s+'([^']+)'", t, re.M):
        alias, path = m.group(1), m.group(2)
        body = t[m.end():]
        if not re.search(r'\b%s\b' % re.escape(alias), body):
            out.append('%-42s %-22s (%s)' % (os.path.basename(f), alias, path))
report('声明了但未使用的 import', out)

# ---------- 5. local 变量未使用 ----------
out = []
for f, t in code.items():
    for m in re.finditer(r'^\s*local\s+(\w+)\s*=', t, re.M):
        name = m.group(1)
        if re.match(r"^local\s+\w+\s*=\s*import", m.group(0).strip()):
            continue
        n = len(re.findall(r'\b%s\b' % re.escape(name), t))
        if n <= 1:
            out.append('%-42s %s' % (os.path.basename(f), name))
report('local 变量声明后未再使用', out)

# ---------- 6. 孤立文件（没有任何地方 import） ----------
out = []
for f in files:
    base = os.path.basename(f)
    if base in ('main.jsonnet',):
        continue
    if sum(1 for f2, t2 in code.items() if f2 != f and base in t2) == 0:
        out.append(os.path.relpath(f, ROOT))
report('没有被任何文件 import 的孤立文件', out)

print('\n共扫描 %d 个 jsonnet 文件' % len(files))
