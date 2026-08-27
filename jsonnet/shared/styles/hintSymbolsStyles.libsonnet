// 定义长按提示气泡的共享样式。
local color = import 'color.libsonnet';
local fontSize = import 'fontSize.libsonnet';


// 文字前景样式
local textStyle(text, fs, theme) = {  //fs 字体大小
  buttonStyleType: 'text',
  text: text,
  fontSize: fs,
  normalColor: color[theme]['长按非选中字体颜色'],
  highlightColor: color[theme]['长按选中字体颜色'],
};

// sf符号前景样式
local systemImageStyle(systemImageName, fs, theme) = {
  buttonStyleType: 'systemImage',
  systemImageName: systemImageName,
  fontSize: fs,
  normalColor: color[theme]['长按非选中字体颜色'],
  highlightColor: color[theme]['长按选中字体颜色'],
};

// 长按符号面板样式生成
local holdSymbolsStyle(key, selectedIndex, size, symbol_list, theme) = {
  [key + 'ButtonHintSymbolsStyle']: {
    insets: { top: 3, bottom: 3, left: 8, right: 8 },
    backgroundStyle: 'alphabeticHintSymbolsBackgroundStyle',
    [if size != {} then 'size']:
      {
        width: size.width,
        height: size.height,
      },
    symbolStyles: [
      key + 'ButtonHintSymbolsStyleOf' + std.toString(index)
      for index in std.range(0, std.length(symbol_list) - 1)
    ],
    selectedBackgroundStyle: 'alphabeticHintSymbolsSelectedStyle',
    selectedIndex: selectedIndex,
  },
} + {

  [key + 'ButtonHintSymbolsForegroundStyleOf' + std.toString(index)]:
    if std.objectHas(symbol_list[index].label, 'text') then
      textStyle(
        symbol_list[index].label.text,
        if std.objectHas(symbol_list[index], 'fontSize') then symbol_list[index].fontSize else fontSize['长按气泡文字大小'],
        theme
      )
    else
      systemImageStyle(
        symbol_list[index].label.systemImageName,
        if std.objectHas(symbol_list[index], 'fontSize') then symbol_list[index].fontSize else fontSize['长按气泡sf符号大小'],
        theme
      )
  for index in std.range(0, std.length(symbol_list) - 1)
} + {
  [key + 'ButtonHintSymbolsStyleOf' + std.toString(index)]: {
    action: symbol_list[index].action,
    foregroundStyle: key + 'ButtonHintSymbolsForegroundStyleOf' + std.toString(index),
  }
  for index in std.range(0, std.length(symbol_list) - 1)
};

// 逐个键生成长按面板样式并合并。
local finalStyles(theme, hintSymbolsData) = {
  style: std.foldl(
    function(acc, key) acc + holdSymbolsStyle(
      key,
      hintSymbolsData[key].selectedIndex,
      if std.objectHas(hintSymbolsData[key], 'size') then hintSymbolsData[key].size else {},
      hintSymbolsData[key].list,
      theme
    ),
    std.objectFields(hintSymbolsData),
    {}
  ),
};

{
  getStyle(theme, hintSymbolsData):: finalStyles(theme, hintSymbolsData).style,

  // 贴图版长按面板背景。只在 keycap_style = 'default'（或关掉
  // keycap_config.apply_to_long_press_panel）时用到，否则由
  // keycap.longPressPanelBackground / longPressPanelSelected 换成 geometry 版。
  //
  // fileImage 的常态与按下态分别读取，只写 normalImage 时按下会画空白，
  // 所以两个状态都要给（同图也要写两遍）。
  '长按背景样式': {
    buttonStyleType: 'fileImage',
    normalImage: { file: 'hold_back', image: 'IMG1' },
    highlightImage: { file: 'hold_back', image: 'IMG1' },
  },
  '长按选中背景样式': {
    buttonStyleType: 'fileImage',
    insets: { left: 4, right: 3, top: 8, bottom: 8 },
    normalImage: { file: 'hint', image: 'IMG1' },
    highlightImage: { file: 'hint', image: 'IMG1' },
  },
}
