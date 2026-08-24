// 存放英文键盘的滑动动作数据。
//
// 26 键英文全覆盖上下划：q~m 每个键都有上划 + 下划，并且带角标显示。
// 布局对照用户提供的参考图（某输入法 26 英文键盘）逐键对齐：
//   · 第一行 上划 = 数字 1~0；下划以 Tab / 省略号 / 顿号开头，其余多为无
//   · 第二行 上划 = 常用符号（! ^ / ; ( - # { "）；下划 = 编辑/配对符号（全 % \ : ) _ + } '）
//   · 第三行 上划 = 符号（@ * ` = [ & ?）；下划 = 编辑动作（撤/剪/复/贴）+ 配对符号（] ~ $）
// r/t/u/y 下划在参考图中为「无」，故不定义，角标自然不显示。
//
// 角标位置为「上划右上、下划左上」，
// 定位值见 shared/styles/center.libsonnet 的『英文上划/下划文字偏移』。

local genSwipeenData(deviceType) = {  // 英文键盘与通用配置不同的同字母滑动动作，在此覆盖通用数据。
  swipe_up: {
    // 第一行：数字 1~0
    q: { action: { character: '1' }, label: { text: '1' } },
    w: { action: { character: '2' }, label: { text: '2' } },
    e: { action: { character: '3' }, label: { text: '3' } },
    r: { action: { character: '4' }, label: { text: '4' } },
    t: { action: { character: '5' }, label: { text: '5' } },
    y: { action: { character: '6' }, label: { text: '6' } },
    u: { action: { character: '7' }, label: { text: '7' } },
    i: { action: { character: '8' }, label: { text: '8' } },
    o: { action: { character: '9' }, label: { text: '9' } },
    p: { action: { character: '0' }, label: { text: '0' } },

    // 第二行：常用符号
    a: { action: { character: '!' }, label: { text: '!' } },
    s: { action: { character: '^' }, label: { text: '^' } },
    d: { action: { character: '/' }, label: { text: '/' } },
    f: { action: { character: ';' }, label: { text: ';' } },
    g: { action: { character: '(' }, label: { text: '(' } },
    h: { action: { character: '-' }, label: { text: '-' } },
    j: { action: { character: '#' }, label: { text: '#' } },
    k: { action: { character: '{' }, label: { text: '{' } },
    l: { action: { character: '"' }, label: { text: '"' } },

    // 第三行：符号
    z: { action: { character: '@' }, label: { text: '@' } },
    x: { action: { character: '*' }, label: { text: '*' } },
    c: { action: { character: '`' }, label: { text: '`' } },
    v: { action: { character: '=' }, label: { text: '=' } },
    b: { action: { character: '[' }, label: { text: '[' } },
    n: { action: { character: '&' }, label: { text: '&' } },
    m: { action: { character: '?' }, label: { text: '?' } },

    // 功能键（不显示滑动角标）
    spaceLeft: { action: { symbol: '.' } },
    spaceRight: { action: { symbol: '.' } },
    backspace: { action: { shortcut: '#deleteText' } },
    enter: { action: { shortcut: '#换行' } },
  },
  swipe_down: {
    // 第一行：Tab / 省略号 / 顿号，r/t/u/y 无下划（参考图）
    q: { action: { character: '\t' }, label: { text: '⇥' } },
    w: { action: { character: '…' }, label: { text: '…' } },
    e: { action: { character: '、' }, label: { text: '、' } },
    i: { action: { character: '|' }, label: { text: '|' } },
    o: { action: { character: '<' }, label: { text: '<' } },
    p: { action: { character: '>' }, label: { text: '>' } },

    // 第二行：编辑/配对符号
    a: { action: { shortcut: '#selectText' }, label: { text: '全' } },
    s: { action: { character: '%' }, label: { text: '%' } },
    d: { action: { character: '\\' }, label: { text: '\\' } },
    f: { action: { character: ':' }, label: { text: ':' } },
    g: { action: { character: ')' }, label: { text: ')' } },
    h: { action: { character: '_' }, label: { text: '_' } },
    j: { action: { character: '+' }, label: { text: '+' } },
    k: { action: { character: '}' }, label: { text: '}' } },
    l: { action: { character: "'" }, label: { text: "'" } },

    // 第三行：编辑动作 + 配对符号
    z: { action: { shortcut: '#undo' }, label: { text: '撤' } },
    x: { action: { shortcut: '#cut' }, label: { text: '剪' } },
    c: { action: { shortcut: '#copy' }, label: { text: '复' } },
    v: { action: { shortcut: '#paste' }, label: { text: '贴' } },
    b: { action: { character: ']' }, label: { text: ']' } },
    n: { action: { character: '~' }, label: { text: '~' } },
    m: { action: { character: '$' }, label: { text: '$' } },

    backspace: { action: { shortcut: '#undo' } },
  },
};

// 下面的不要动
{
  genSwipeenData(deviceType): genSwipeenData(deviceType),
}
