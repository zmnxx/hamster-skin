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
    // 左侧符号列。横竖屏共用这一个节点。
    // symbols 类型的 displaySeparatorLine 默认就是 false，不必再写分隔线颜色。
    collection: {
      size: {
        height: '3/4',
      },
      insets: { top: 6, bottom: 6 },
      backgroundStyle: 'collectionBackgroundStyle',
      type: 'symbols',
      dataSource: 'symbols',
      cellStyle: 'collectionCellStyle',
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
      // fontWeight 是枚举，写数字会让本节点部分键失效、文字回落系统 label 色
      fontWeight: 'regular',
    },
    symbols: numericSymbols,
  },
}
