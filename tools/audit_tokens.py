#!/usr/bin/env python3
"""审计 center.libsonnet 与 fontSize.libsonnet 里未被引用的偏移/字号项。

注意：只算「未注释」的引用。被 // 注释掉的引用不算引用 —— 那正是死代码。
"""
import os, re, sys

ROOT = sys.argv[1]
files = []
for dp, _, fns in os.walk(ROOT):
    for fn in fns:
        if fn.endswith(('.libsonnet', '.jsonnet')):
            files.append(os.path.join(dp, fn))


def strip_comments(t):
    t = re.sub(r'/\*.*?\*/', '', t, flags=re.S)
    return re.sub(r'//[^\n]*', '', t)


code = {f: strip_comments(open(f, encoding='utf-8').read()) for f in files}

for rel in ('shared/styles/center.libsonnet',
            'shared/styles/fontSize.libsonnet',
            'shared/styles/animation.libsonnet',
            'shared/styles/others.libsonnet'):
    path = os.path.join(ROOT, rel)
    if not path in code:
        continue
    print('\n== %s ==' % rel)
    found = False
    for m in re.finditer(r"^\s{2}'([^']+)':", code[path], re.M):
        k = m.group(1)
        hits = sum(1 for f, t in code.items()
                   if f != path and ("'%s'" % k) in t)
        if hits == 0:
            print('  未引用: %s' % k)
            found = True
    if not found:
        print('  （全部有引用）')
