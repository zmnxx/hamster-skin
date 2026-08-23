// 定义九键字母分组与符号数据。
{
  lettersUpper: {
    '2': 'ABC',
    '3': 'DEF',
    '4': 'GHI',
    '5': 'JKL',
    '6': 'MNO',
    '7': 'PQRS',
    '8': 'TUV',
    '9': 'WXYZ',
  },

  lettersLower: {
    '2': 'abc',
    '3': 'def',
    '4': 'ghi',
    '5': 'jkl',
    '6': 'mno',
    '7': 'pqrs',
    '8': 'tuv',
    '9': 'wxyz',
  },

  getLetters(isCapital)::
    if isCapital then self.lettersUpper else self.lettersLower,

  digitKeys: [std.toString(num) for num in std.range(2, 9)],

  symbols: [
    // 九键左侧符号栏的数据源。
    //
    // 这一列原本用 type: 't9Symbols'，数据由元书「键盘设置 → 中文九键符号设定」
    // 提供，皮肤的 dataSource 被忽略。但 t9Symbols 同时也**不认** cellStyle 里的
    // 文字颜色（元书作者自己的官方 T9 皮肤压根没给它写 cellStyle），一律用系统
    // label 色 —— 于是被强制浅色的 App 里这一列变成黑字，而同一份 yaml 里
    // 声明的是 F2F2F2。
    //
    // 改用 type: 'symbols' 后颜色归皮肤管（123 数字键盘一直用的就是 symbols，
    // 它在任何 App 里都是白字，这是最直接的对照）。代价是数据不再跟随 App 设置，
    // 所以这里照 App 默认显示的四项写死，观感不变。
    { label: ',', action: { character: '，' } },
    { label: '?', action: { character: '？' } },
    { label: '!', action: { character: '！' } },
    { label: '、', action: { character: '、' } },
  ],
}
