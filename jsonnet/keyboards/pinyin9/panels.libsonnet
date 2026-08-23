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
      // 用 'symbols' 而不是 't9Symbols'：后者的文字颜色不受皮肤控制，
      // 在被强制浅色的 App 里会变成系统黑字（详见 t9.libsonnet 的注释）。
      // 数字键盘的符号栏一直用 symbols，在任何 App 里都是白字。
      type: 'symbols',
      dataSource: 'symbols',
      cellStyle: 'collectionCellStyle',
      // symbols 默认不显示分隔线，这里显式打开，保持与原先 t9Symbols 一致的观感
      displaySeparatorLine: true,
      separatorLineColor: color[theme]['符号区分隔线颜色'],
      // 数据源固定 4 项，可视行数跟着收，避免留空行
      maximumRow: 4,
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
      // fontWeight 是枚举（ultraLight…black），原本写的 0 不是合法取值。
      // 非法值会让元书跳过这个 style 节点里的部分键，符号列文字于是回落到
      // 系统 label 色 —— 深色 App 里纯白 255、被强制浅色的 App 里近黑，
      // 而皮肤声明的 F2F2F2(242) 从未生效（旁边键帽的 242 是正常渲染的）。
      fontWeight: 'regular',
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
