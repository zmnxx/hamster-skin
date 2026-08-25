// 存放英文键盘的滑动动作数据。
//
// 26 键英文只保留「上划」：q~m 每个键一个上划，带角标显示，位于键帽上方。
// 下划已整体移除（swipe_down 置空），键帽下半区留白，为以后重新加入下划显示做准备。
//
// 关键修复：英文键盘的字母主键走的是 `symbol`（直接上屏），
// 之前上划用 `character` 会进入输入引擎、在英文键盘里不上屏，
// 表现为「角标显示了却划不出字符」。因此这里全部改用 `symbol`，与主键一致。
//
// 上划布局（对照用户重新规划）：
//   第一行 Q1 W2 E3 R4 T5 Y6 U7 I8 O9 P0
//   第二行 A! S^ D/ F; G( H- J# K{ L"
//   第三行 Z@ X* C` V= B[ N& M?
//
// 角标位置见 shared/styles/center.libsonnet 的『英文上划文字偏移』（键帽上方）。

local genSwipeenData(deviceType) = {  // 英文键盘与通用配置不同的同字母滑动动作，在此覆盖通用数据。
  swipe_up: {
    // 第一行：数字 1~0
    q: { action: { symbol: '1' }, label: { text: '1' } },
    w: { action: { symbol: '2' }, label: { text: '2' } },
    e: { action: { symbol: '3' }, label: { text: '3' } },
    r: { action: { symbol: '4' }, label: { text: '4' } },
    t: { action: { symbol: '5' }, label: { text: '5' } },
    y: { action: { symbol: '6' }, label: { text: '6' } },
    u: { action: { symbol: '7' }, label: { text: '7' } },
    i: { action: { symbol: '8' }, label: { text: '8' } },
    o: { action: { symbol: '9' }, label: { text: '9' } },
    p: { action: { symbol: '0' }, label: { text: '0' } },

    // 第二行：常用符号
    a: { action: { symbol: '!' }, label: { text: '!' } },
    s: { action: { symbol: '^' }, label: { text: '^' } },
    d: { action: { symbol: '/' }, label: { text: '/' } },
    f: { action: { symbol: ';' }, label: { text: ';' } },
    g: { action: { symbol: '(' }, label: { text: '(' } },
    h: { action: { symbol: '-' }, label: { text: '-' } },
    j: { action: { symbol: '#' }, label: { text: '#' } },
    k: { action: { symbol: '{' }, label: { text: '{' } },
    l: { action: { symbol: '"' }, label: { text: '"' } },

    // 第三行：符号
    z: { action: { symbol: '@' }, label: { text: '@' } },
    x: { action: { symbol: '*' }, label: { text: '*' } },
    c: { action: { symbol: '`' }, label: { text: '`' } },
    v: { action: { symbol: '=' }, label: { text: '=' } },
    b: { action: { symbol: '[' }, label: { text: '[' } },
    n: { action: { symbol: '&' }, label: { text: '&' } },
    m: { action: { symbol: '?' }, label: { text: '?' } },

    // 功能键（不显示滑动角标）
    spaceLeft: { action: { symbol: '.' } },
    backspace: { action: { shortcut: '#deleteText' } },
    enter: { action: { shortcut: '#换行' } },
  },
  // 下划整体移除：只保留上划。键帽下半区留白，为以后重新加入下划显示做准备。
  swipe_down: {},
};

// 下面的不要动
{
  genSwipeenData(deviceType): genSwipeenData(deviceType),
}
