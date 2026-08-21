// 定义拼音 9 键使用的面板型组件。
local color = import '../../shared/styles/color.libsonnet';
local fontSize = import '../../shared/styles/fontSize.libsonnet';
local styleFactories = import '../../shared/styles/styleFactories.libsonnet';
local hintSymbolsStyles = import '../../shared/styles/hintSymbolsStyles.libsonnet';
local keycap = import '../../shared/styles/keycap.libsonnet';

{
  build(context, theme, orientation)::
    local makePanelGeometryStyle(normalColor, extra={}) =
      // 生成 collection 与单元格共用的 geometry 样式。
      styleFactories.makeGeometryStyle(normalColor, extra);
    {
    collection: {
      size: { height: '3/4' },
      insets: { top: 6, bottom: 6 },
      backgroundStyle: 'collectionBackgroundStyle',
      type: 't9Symbols',
      dataSource: 'symbols',
      cellStyle: 'collectionCellStyle',
      // t9Symbols 默认显示分隔线，但不写颜色就用系统灰，
      // 在被强制浅色的 App 里几乎看不见，这里显式指定。
      separatorLineColor: color[theme]['符号区分隔线颜色'],
    },
    collectionBackgroundStyle: makePanelGeometryStyle(color[theme]['符号键盘左侧collection背景颜色'], {
      insets: if orientation == 'portrait' then context.Settings.button_insets.portrait else context.Settings.button_insets.landscape,
      cornerRadius: context.Settings.cornerRadius,
      normalLowerEdgeColor: color[theme]['符号键盘左侧collection背景下边缘颜色'],
    }),
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
      fontWeight: 0,
    },
    alphabeticHintSymbolsBackgroundStyle: keycap.longPressPanelBackground(theme, context.Settings, hintSymbolsStyles['长按背景样式']),
    alphabeticHintSymbolsSelectedStyle: keycap.longPressPanelSelected(theme, context.Settings, color, hintSymbolsStyles['长按选中背景样式']),

    // 横屏 9 键左侧候选区必须使用固定名称 verticalCandidates，避免宿主不识别自定义前缀名称。
    verticalCandidates: {
      type: 'verticalCandidates',
      size: { height: '1' },
      insets: { top: 3, left: 6, right: 6, bottom: 3 },
      maxRows: 4,
      separatorColor: 0,
      backgroundStyle: 'alphabeticBackgroundStyle',
      candidateStyle: 'verticalCandidateCellStyle',
    },
    verticalCandidateCellStyle: {
      highlightBackgroundColor: 0,
      preferredBackgroundColor: color[theme]['选中候选背景颜色'],
      preferredIndexColor: color[theme]['候选字体选中字体颜色'],
      preferredTextColor: color[theme]['候选字体选中字体颜色'],
      preferredCommentColor: color[theme]['候选字体选中字体颜色'],
      indexColor: color[theme]['长按非选中字体颜色'],
      textColor: color[theme]['长按非选中字体颜色'],
      commentColor: color[theme]['长按非选中字体颜色'],
      indexFontSize: 16,
      textFontSize: 16,
      commentFontSize: 16,
      bottomRowHeight: 50,
    },
  },
}
