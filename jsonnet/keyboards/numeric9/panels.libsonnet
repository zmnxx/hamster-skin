// 定义数字 9 键使用的面板型组件。
local color = import '../../shared/styles/color.libsonnet';
local fontSize = import '../../shared/styles/fontSize.libsonnet';
local keycap = import '../../shared/styles/keycap.libsonnet';
local styleFactories = import '../../shared/styles/styleFactories.libsonnet';

local numericSymbols = [
  { label: '+', action: { character: '+' } },
  { label: '-', action: { character: '-' } },
  { label: '×', action: { character: '*' } },
  { label: '/', action: { character: '/' } },
  { label: '(', action: { character: '(' } },
  { label: ')', action: { character: ')' } },
  '.',
  '@',
  ',',
  '#',
  ':',
  '_',
  '?',
  '￥',
];

{
  build(context, theme, orientation)::
    local makePanelGeometryStyle(normalColor, extra={}) =
      // 生成 collection 与单元格共用的 geometry 样式。
      styleFactories.makeGeometryStyle(normalColor, extra);
    {
    collection: {
      size: {
        height: '3/4',
      },
      insets: { top: 6, bottom: 6 },
      backgroundStyle: 'collectionBackgroundStyle',
      type: 'symbols',
      dataSource: 'symbols',
      cellStyle: 'collectionCellStyle',
      separatorLineColor: color[theme]['符号区分隔线颜色'],
    },
    landscapeCollection: {
      size: {
        height: '3/4',
      },
      insets: { top: 6, bottom: 6 },
      backgroundStyle: 'collectionBackgroundStyle',
      // 数字键盘横屏这一列同样兼任拼音选择，保持 t9Symbols
      type: 't9Symbols',
      dataSource: 'landscapeSymbols',
      cellStyle: 'collectionCellStyle',
      // 去掉格子间横线，与竖屏 123 符号栏一致
      displaySeparatorLine: false,
    },
    landscapeNumericSymbols: {
      size: {
        height: '1',
      },
      insets: { top: 3, bottom: 3, left: 3, right: 3 },
      backgroundStyle: 'collectionBackgroundStyle',
      type: 'categorySymbols',
      separatorLineColor: color[theme]['符号区分隔线颜色'],
    },
    collectionBackgroundStyle: keycap.panelBackground(
      theme, orientation, context.Settings, color,
      '符号键盘左侧collection背景颜色', '符号键盘左侧collection背景下边缘颜色'
    ),
    collectionCellStyle: {
      backgroundStyle: 'collectionCellBackgroundStyle',
      foregroundStyle: 'collectionCellForegroundStyle',
    },
    collectionCellBackgroundStyle: makePanelGeometryStyle('ffffff00', {
      insets: if orientation == 'portrait' then context.Settings.button_insets.portrait else context.Settings.button_insets.landscape,
      highlightColor: color[theme]['字母键背景颜色-普通'],
      cornerRadius: context.Settings.cornerRadius,
    }),
    collectionCellForegroundStyle: {
      buttonStyleType: 'text',
      normalColor: color[theme]['collection前景颜色'],
      // 不写 highlightColor 时按下瞬间文字会退回系统 label 色（浅色下变黑）
      highlightColor: color[theme]['collection前景颜色'],
      fontSize: fontSize['collection前景字体大小'],
      // 同 pinyin9/panels.libsonnet：0 不是 fontWeight 的合法枚举值，
      // 会导致整个节点的颜色声明失效、文字回落系统 label 色。
      fontWeight: 'regular',
    },
    symbols: numericSymbols,
    landscapeSymbols: [
      if std.type(item) == 'string' then {
        label: item,
        action: { character: item },
      } else item
      for item in numericSymbols
    ],
  },
}
