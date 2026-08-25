// 定义键盘元素共用的字号令牌。
local Settings = import '../../Custom.libsonnet';
local customFontSize = if std.objectHas(Settings, 'font_size_config') then Settings.font_size_config else {};

{
  '未展开候选字体选中字体大小': 20,
  '未展开comment字体大小': 10,
  '展开候选字体选中字体大小': 20,
  'preedit区字体大小': 13,

  '上划文字大小': 9,
  '下划文字大小': 9,
  // 英文 26 键角标：压在键角上，比中文的上下划标记小一号
  '英文划动角标文字大小': 8,
  '划动气泡前景文字大小': 28,
  '划动气泡前景sf符号大小': 28,

  '长按气泡文字大小': 20,
  '长按气泡sf符号大小': 12,

  '按键前景文字大小': 20,
  '26键字母前景文字大小': if std.objectHas(customFontSize, 'pinyin_26_letter_font_size') then customFontSize.pinyin_26_letter_font_size else 20,
  '功能按键sf符号大小': 17,

  'toolbar按键前景sf符号大小': 18,
  // 工具栏文字。与下方功能行对齐：功能行用 17pt、常规字重、center y=0.5，
  // 这里同步到 17pt，使两条区域的汉字大小一致、竖直居中一致。
  'toolbar按键前景文字大小': 17,

  // 数字键盘
  'collection前景字体大小': 18,
  '数字键盘数字前景字体大小': if std.objectHas(customFontSize, 'numeric_digit_font_size') then customFontSize.numeric_digit_font_size else 20,

  // 中文九键
  '中文九键字符键前景文字大小': if std.objectHas(customFontSize, 'pinyin_9_letter_font_size') then customFontSize.pinyin_9_letter_font_size else 15,

  // 符号键盘
  '符号键盘左侧collection前景字体大小': 13,
  '符号键盘右侧collection前景字体大小': 16,

  // panel键盘
  'panel按键前景文字大小': 12,
  'panel按键前景sf符号大小': 20,
}
