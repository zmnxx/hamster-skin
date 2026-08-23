// 存放英文键盘的滑动动作数据。
//
// 本表参考 Write 2023 皮肤的 26 键英文方案重写，q~m 全部 26 键都有上划 + 下划，
// 并且带角标显示：
//   · 第一行 上划 = 数字 1~0，下划 = 对应的 shift 符号
//   · 第二行 上划 = 运算与引号类符号，下划 = 括号类符号，两端是左手/右手模式
//   · 第三行 上划 = 中文标点，下划 = 编辑动作（全选/剪切/复制/粘贴/方案/行首/行尾）
// 全表已去重，同一个符号不会出现在两个键上。
//
// 角标位置为「上划右上、下划左上」，与 Write 2023 一致，
// 定位值见 shared/styles/center.libsonnet 的『英文上划/下划文字偏移』。


local genSwipeenData(deviceType) = {  // 英文键盘与通用配置不同的同字母滑动动作，在此覆盖通用数据。
  swipe_up: {
    // 第一行：数字 1~0
    q: { action: { symbol: '1' }, label: { text: '1' } },  // action同仓皮肤定义，label可选text/systemImageName, 具体见仓皮肤文档，若不想显示，可设置为text: ""
    w: { action: { symbol: '2' }, label: { text: '2' } },
    e: { action: { symbol: '3' }, label: { text: '3' } },
    r: { action: { symbol: '4' }, label: { text: '4' } },
    t: { action: { symbol: '5' }, label: { text: '5' } },
    y: { action: { symbol: '6' }, label: { text: '6' } },
    u: { action: { symbol: '7' }, label: { text: '7' } },
    i: { action: { symbol: '8' }, label: { text: '8' } },
    o: { action: { symbol: '9' }, label: { text: '9' } },
    p: { action: { symbol: '0' }, label: { text: '0' } },

    // 第二行：运算符与引号
    a: { action: { character: '-' }, label: { text: '-' } },
    s: { action: { character: '=' }, label: { text: '=' } },
    d: { action: { character: '/' }, label: { text: '/' } },
    f: { action: { character: '\\' }, label: { text: '\\' } },
    g: { action: { character: '|' }, label: { text: '|' } },
    h: { action: { character: '`' }, label: { text: '`' } },
    j: { action: { character: ':' }, label: { text: ':' } },
    k: { action: { character: '"' }, label: { text: '"' } },
    l: { action: { character: "'" }, label: { text: "'" } },

    // 第三行：中文标点
    z: { action: { character: '、' }, label: { text: '、' } },
    x: { action: { character: '。' }, label: { text: '。' } },
    c: { action: { character: '？' }, label: { text: '？' } },
    v: { action: { character: '！' }, label: { text: '！' } },
    b: { action: { character: '…' }, label: { text: '…' } },
    n: { action: { character: '《' }, label: { text: '《' } },
    m: { action: { character: '》' }, label: { text: '》' } },

    // 功能键（保持万象原有行为，不显示角标）
    spaceLeft: { action: { symbol: '.' } },
    spaceRight: { action: { symbol: '.' } },
    backspace: { action: { shortcut: '#deleteText' } },
    enter: { action: { shortcut: '#换行' } },
  },
  swipe_down: {
    // 第一行：数字键对应的 shift 符号
    q: { action: { character: '~' }, label: { text: '~' } },
    w: { action: { character: '@' }, label: { text: '@' } },
    e: { action: { character: '#' }, label: { text: '#' } },
    r: { action: { character: '$' }, label: { text: '$' } },
    t: { action: { character: '%' }, label: { text: '%' } },
    y: { action: { character: '^' }, label: { text: '^' } },
    u: { action: { character: '&' }, label: { text: '&' } },
    i: { action: { character: '*' }, label: { text: '*' } },
    o: { action: { character: '(' }, label: { text: '(' } },
    p: { action: { character: ')' }, label: { text: ')' } },

    // 第二行：括号类；两端放单手模式，拇指能自然够到
    a: { action: { shortcut: '#左手模式' }, label: { text: '左' } },
    s: { action: { character: '_' }, label: { text: '_' } },
    d: { action: { character: '+' }, label: { text: '+' } },
    f: { action: { character: '[' }, label: { text: '[' } },
    g: { action: { character: ']' }, label: { text: ']' } },
    h: { action: { character: '{' }, label: { text: '{' } },
    j: { action: { character: '}' }, label: { text: '}' } },
    k: { action: { character: ';' }, label: { text: ';' } },
    l: { action: { shortcut: '#右手模式' }, label: { text: '右' } },

    // 第三行：编辑动作，用单个汉字做角标，一眼能认出
    z: { action: { shortcut: '#selectText' }, label: { text: '全' } },
    x: { action: { shortcut: '#cut' }, label: { text: '剪' } },
    c: { action: { shortcut: '#copy' }, label: { text: '复' } },
    v: { action: { shortcut: '#paste' }, label: { text: '贴' } },
    b: { action: { shortcut: '#RimeSwitcher' }, label: { text: '方' } },
    n: { action: { shortcut: '#行首' }, label: { text: '首' } },
    m: { action: { shortcut: '#行尾' }, label: { text: '尾' } },

    backspace: { action: { shortcut: '#undo' } },
  },
};

// 下面的不要动
{
  genSwipeenData(deviceType): genSwipeenData(deviceType),
}
