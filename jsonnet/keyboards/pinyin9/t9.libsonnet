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
    // 注意：该列用 type: 't9Symbols'，元书**忽略**这里的 dataSource，
    // 实际显示的是「键盘设置 → 中文九键符号设定」里配的内容，而且打字时
    // 这一列会切换成拼音选择列。这份数据只是占位（不写 dataSource 时
    // 校验器会报缺引用），改它对设备上的显示没有影响。
    { label: ',', action: { character: ',' } },
    { label: '.', action: { character: '.' } },
    { label: '?', action: { character: '?' } },
    { label: '!', action: { character: '!' } },
    { label: '@', action: { character: '@' } },
  ],
}
