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
      // 必须是 t9Symbols。它不只是符号列，还兼任**打字时的拼音选择列**，
      // 数据源跟随元书「键盘设置 → 中文九键符号设定」。
      // 曾经为了修「强制浅色 App 里符号变黑字」把它换成 symbols，结果打字时
      // 拼音选择列消失、符号被写死 —— 那是功能回归，不能这么修。
      type: 't9Symbols',
      dataSource: 'symbols',
      cellStyle: 'collectionCellStyle',
      // t9Symbols 的 displaySeparatorLine 默认 true，要去掉格子间横线必须显式关。
      displaySeparatorLine: false,
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
      // fontWeight 是枚举（ultraLight…black），写数字会让本节点部分键失效、
      // 文字回落系统 label 色
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
      // 颜色必须是 6 / 8 位十六进制，写 0 解析失败后回落系统灰
      separatorColor: '00000000',
      backgroundStyle: 'alphabeticBackgroundStyle',
      candidateStyle: 'verticalCandidateCellStyle',
    },
    verticalCandidateCellStyle: {
      highlightBackgroundColor: '00000000',
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
      // 官方 verticalCandidates 示例里的键，保留原值
      bottomRowHeight: 50,
    },
  },
}
