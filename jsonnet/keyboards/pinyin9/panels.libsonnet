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
      // 必须是 t9Symbols。它不只是符号列，还兼任**打字时的拼音选择列**
      // （这一列同时是「T9 符号列表」与「拼音候选列」），并且数据源跟随
      // 元书「键盘设置 → 中文九键符号设定」。
      // 曾经为了修「强制浅色 App 里符号变黑字」把它换成 symbols，结果打字时
      // 拼音选择列消失、符号被写死 —— 那是功能回归，不能这么修。
      type: 't9Symbols',
      dataSource: 'symbols',
      cellStyle: 'collectionCellStyle',
      // 去掉格子之间的横线（用户要求，与 123 数字键盘符号栏观感一致）。
      // t9Symbols 的 displaySeparatorLine 默认是 true，必须显式关掉。
      displaySeparatorLine: false,
      // 下面三项是针对「文字颜色不受皮肤控制」的多路尝试：
      // cellStyle 那条链（collectionCellForegroundStyle）在 t9Symbols 上似乎
      // 不被采纳，实测渲染成系统 label 色。这里额外挂 candidateStyle 与
      // 直接写在节点上的 foregroundStyle —— 元书对不认识的 Key 是静默忽略，
      // 多写无害；哪条生效算哪条。
      candidateStyle: 'collectionCandidateStyle',
      foregroundStyle: 'collectionCellForegroundStyle',
    },
    // 供上面的 candidateStyle 引用。字段名照候选字单元格样式那一套写
    // （textColor / indexColor / commentColor），而不是 normalColor。
    collectionCandidateStyle: {
      textColor: color[theme]['collection前景颜色'],
      indexColor: color[theme]['collection前景颜色'],
      commentColor: color[theme]['collection前景颜色'],
      preferredTextColor: color[theme]['collection前景颜色'],
      preferredIndexColor: color[theme]['collection前景颜色'],
      preferredCommentColor: color[theme]['collection前景颜色'],
      highlightBackgroundColor: '00000000',
      preferredBackgroundColor: '00000000',
      textFontSize: fontSize['collection前景字体大小'],
      indexFontSize: fontSize['collection前景字体大小'],
      commentFontSize: fontSize['collection前景字体大小'],
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
      bottomRowHeight: 50,
    },
  },
}
