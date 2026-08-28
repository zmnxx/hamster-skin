// 手机工具栏总入口，负责读取配置、解析按钮布局，并定义固定按钮与样式对象。
local Settings = import '../../Custom.libsonnet';
local center = import '../styles/center.libsonnet';
local color = import '../styles/color.libsonnet';
local fontSize = import '../styles/fontSize.libsonnet';
local keycap = import '../styles/keycap.libsonnet';
local styleFactories = import '../styles/styleFactories.libsonnet';
local toolbarShared = import 'config.libsonnet';
local iPhoneRenderer = import 'iPhoneRenderer.libsonnet';
local toolbarRegistryLib = import 'registry.libsonnet';

local toolbarConfig = toolbarShared.getToolbarConfig(Settings);
local toolbarMenu = toolbarShared.getToolbarMenu(toolbarConfig);
local toolbarMode =
  if std.objectHas(toolbarConfig, 'mode') && std.member(['segmented', 'carousel', 'fixed'], toolbarConfig.mode) then
    toolbarConfig.mode
  else
    'segmented';

local segmentedConfig =
  if std.objectHas(toolbarConfig, 'segmented') then toolbarConfig.segmented else {};
local carouselConfig =
  if std.objectHas(toolbarConfig, 'carousel') then toolbarConfig.carousel else {};
local fixedConfig =
  if std.objectHas(toolbarConfig, 'fixed') then toolbarConfig.fixed else {};

local getToolBar(theme, overrides={}) =
  local switchKeyboardType = toolbarShared.getSwitchKeyboardType(overrides);
  local switchKeyboardAsset = toolbarShared.getSwitchKeyboardAsset(overrides);
  local toolbarButtonRegistry = toolbarRegistryLib.getPhoneRegistry(toolbarMenu, switchKeyboardType);
  // 将 Custom 中的分段式布局解析为最终可用的按钮 ID。
  local segmentedResolved = {
    left_fixed: toolbarShared.getToolbarId(
      toolbarButtonRegistry,
      if std.objectHas(segmentedConfig, 'left_fixed') then segmentedConfig.left_fixed else null,
      'script'
    ),
    left_slide: toolbarShared.getToolbarIds(
      toolbarButtonRegistry,
      if std.objectHas(segmentedConfig, 'left_slide') then segmentedConfig.left_slide else [],
      ['google', 'safari', 'apple']
    ),
    center_fixed: toolbarShared.getToolbarId(
      toolbarButtonRegistry,
      if std.objectHas(segmentedConfig, 'center_fixed') then segmentedConfig.center_fixed else null,
      'menu_or_panel'
    ),
    right_slide: toolbarShared.getToolbarIds(
      toolbarButtonRegistry,
      if std.objectHas(segmentedConfig, 'right_slide') then segmentedConfig.right_slide else [],
      ['note', 'clipboard']
    ),
    right_fixed: toolbarShared.getToolbarId(
      toolbarButtonRegistry,
      if std.objectHas(segmentedConfig, 'right_fixed') then segmentedConfig.right_fixed else null,
      'hide'
    ),
  };
  // 将 Custom 中的整体滑动布局解析为最终可用的按钮 ID。
  local carouselResolved = {
    left_fixed: toolbarShared.getToolbarId(
      toolbarButtonRegistry,
      if std.objectHas(carouselConfig, 'left_fixed') then carouselConfig.left_fixed else null,
      'menu_or_panel'
    ),
    center_slide: toolbarShared.getToolbarIds(
      toolbarButtonRegistry,
      if std.objectHas(carouselConfig, 'center_slide') then carouselConfig.center_slide else [],
      ['script', 'google', 'note', 'clipboard', 'keyboard_settings']
    ),
    right_fixed: toolbarShared.getToolbarId(
      toolbarButtonRegistry,
      if std.objectHas(carouselConfig, 'right_fixed') then carouselConfig.right_fixed else null,
      'hide'
    ),
  };
  // 将 Custom 中的全固定布局解析为最终可用的按钮 ID。
  // 无滑动区，按钮等宽平铺；数组顺序即显示顺序。
  local fixedResolved = {
    buttons: toolbarShared.getToolbarIds(
      toolbarButtonRegistry,
      if std.objectHas(fixedConfig, 'buttons') then fixedConfig.buttons else [],
      ['menu_or_panel', 'google', 'safari', 'apple', 'note', 'clipboard', 'script', 'hide'],
      true
    ),
  };
  // 渲染器只生成布局和滑动数据源，固定按钮样式与 action 在此补齐。
  local iPhoneRendererConfig = iPhoneRenderer.build(toolbarMode, segmentedResolved, carouselResolved, fixedResolved, toolbarButtonRegistry);
  local makeToolbarSystemImageForegroundStyle(systemImageName, extra={}) = {
    buttonStyleType: 'systemImage',
    systemImageName: systemImageName,
    normalColor: color[theme]['toolbar按键颜色'],
    highlightColor: color[theme]['toolbar按键颜色'],
    fontSize: fontSize['toolbar按键前景sf符号大小'],
    fontWeight: 'medium',
  } + extra;
  local makeToolbarAssetImageForegroundStyle(assetImageName, extra={}) = {
    buttonStyleType: 'assetImage',
    assetImageName: assetImageName,
    normalColor: color[theme]['toolbar按键颜色'],
    highlightColor: color[theme]['toolbar按键颜色'],
    fontSize: fontSize['toolbar按键前景sf符号大小'],
    fontWeight: 'medium',
  } + extra;
  local makeToolbarTextForegroundStyle(textValue, fontSizeValue, extra={}) = {
    buttonStyleType: 'text',
    text: textValue,
    normalColor: color[theme]['toolbar按键颜色'],
    highlightColor: color[theme]['toolbar按键颜色'],
    fontSize: fontSizeValue,
    // 工具栏与功能行统一字重为 medium：两排都是 17pt / medium / 居中，
    // 消除「上排偏粗、下排偏细」的不一致。PingFang SC 支持 medium。
    fontWeight: 'medium',
    center: center['toolbar按键文字偏移'],
  } + extra;
  local makeToolbarButtonStyle(foregroundStyle, action, extra={}) = {
    backgroundStyle: 'toolbarButtonBackgroundStyle',
    foregroundStyle: foregroundStyle,
    action: action,
  } + extra;
  local makeSystemButtonStyle(foregroundStyle, action, extra={}) = {
    backgroundStyle: 'systemButtonBackgroundStyle',
    foregroundStyle: foregroundStyle,
    action: action,
  } + extra;
  local makeVerticalCandidateSystemImageForegroundStyle(systemImageName, extra={}) = {
    buttonStyleType: 'systemImage',
    systemImageName: systemImageName,
    normalColor: color[theme]['按键前景颜色'],
    highlightColor: color[theme]['按键前景颜色'],
    fontSize: fontSize['数字键盘数字前景字体大小'] - 3,
    center: { y: 0.53 },
  } + extra;

  {
    // 预编辑区（候选栏上面那条拼音串显示区）
    //
    // 原本这里既没挂 backgroundStyle、前景也没写颜色，于是：
    //   · 背景露出下层，被强制浅色的 App 里会透出浅色底
    //   · 文字用系统 label 色，浅色模式下变成黑字
    // 两者叠加就会出现「黑底黑字」或「浅底看不清」。
    // 现在显式指定背景与文字色，跟随皮肤配色而非系统。
    preeditStyle: {
      insets: { left: 15, top: 2 },
      backgroundStyle: 'preeditBackgroundStyle',
      foregroundStyle: 'preeditForegroundStyle',
    },
    // 开启背景贴图时这一段也铺图（与按键区取自同一张源图的相邻条带，
    // 接缝处颜色连续）；否则沿用原来的透明底。
    // 注意：开启「内嵌输入模式」后本区域不渲染，这张图也就不显示。
    preeditBackgroundStyle:
      if std.objectHas(Settings, 'background_image') && Settings.background_image.enabled
      then styleFactories.makeFileImageStyle(Settings.background_image.preedit)
      else styleFactories.makeGeometryStyle(color[theme]['键盘背景颜色']),
    preeditForegroundStyle: {
      buttonStyleType: 'text',
      insets: { left: 30 },
      fontSize: fontSize['preedit区字体大小'],
      // 预编辑区只读 fontSize / fontWeight / textColor 三个键（官方文档 4.6），
      // 写 normalColor / highlightColor 会被忽略、文字回落系统白色。
      textColor: color[theme]['候选字体选中字体颜色'],
    },
    // 工具栏样式
    //
    // 整条工具栏套一个通长胶囊，而不是让 8 个按钮各自带底 —— 后者在屏幕上
    // 读成八个小方框，很碎。胶囊上下各内缩 3pt，圆角取剩余高度的一半
    // （toolbar_height 42 - 6 = 36 → 18），于是两端是半圆。
    //
    // 这与「键盘背景保持透明」不冲突：透明是为了让四角与 preedit 带透出同一层
    // 系统背板、消除接缝；胶囊是宽度内缩 10pt 的一条独立控件，本来就该有自己
    // 的边界，不会产生横贯全屏的硬边。
    toolbarStyle: {
      // 左右内缩与功能行、字母区统一为 4pt：三块（工具栏 / 功能行 / 字母键）
      // 共用同一条左右边界，8 个工具栏按钮与下面 8 个功能键逐列对齐。
      // 原为 10pt，比功能行(0)和字母区(4)都窄，导致「菜单/收起」明显内移。
      insets: { left: 4, right: 4 },
      backgroundStyle: 'toolbarCapsuleBackgroundStyle',
    },
    toolbarCapsuleBackgroundStyle: keycap.toolbarCapsuleBackground(
      theme,
      Settings,
      (Settings.toolbar_config.toolbar_height - 6) / 2,
      { top: 3, bottom: 3 }
    ),
    toolbarLayout: iPhoneRendererConfig.toolbarLayout,


    toolbarSlideButtonsLeft: iPhoneRendererConfig.toolbarSlideButtonsLeft,
    toolbarSlideButtonsRight: iPhoneRendererConfig.toolbarSlideButtonsRight,
    toolbarSlideButtonsCenter: iPhoneRendererConfig.toolbarSlideButtonsCenter,
    // 滑动区单元格的兜底样式。每个滑动项都会用 styleName 指向自己的样式，
    // 这里只在 styleName 缺失时生效。
    // 注意 cellStyle 的 foregroundStyle 只能是 text 类型（官方文档 5.1），
    // 写 geometry 元书不会渲染。
    toolbarcollectionCellStyle: {
      backgroundStyle: 'toolbarcollectionCellBackgroundStyle',
      foregroundStyle: 'toolbarcollectionCellForegroundStyle',
    },
    // 颜色必须是 6 / 8 位十六进制，写 0 长度不对、解析失败后回落系统色。
    toolbarcollectionCellBackgroundStyle: styleFactories.makeGeometryStyle('00000000'),
    toolbarcollectionCellForegroundStyle: {
      buttonStyleType: 'text',
      normalColor: color[theme]['toolbar按键颜色'],
      highlightColor: color[theme]['toolbar按键颜色'],
      fontSize: fontSize['toolbar按键前景文字大小'],
      fontWeight: 'medium',
    },
    horizontalSymbolsDataSourceLeft: iPhoneRendererConfig.horizontalSymbolsDataSourceLeft,
    horizontalSymbolsDataSourceRight: iPhoneRendererConfig.horizontalSymbolsDataSourceRight,
    horizontalSymbolsDataSourceCenter: iPhoneRendererConfig.horizontalSymbolsDataSourceCenter,


    // 横向候选文字栏调式
    horizontalCandidatesStyle: {
      insets: { left: 5, right: 10, },
      backgroundStyle: 'toolbarBackgroundStyle',
    },
    horizontalCandidatesLayout: [
      {
        HStack: {
          subviews: [
            { Cell: 'horizontalCandidates' },
            // { Cell: 'clearPreeditButton' },
            if Settings.horizon_candidate_button == 1 then { Cell: 'expandButton' } else if Settings.horizon_candidate_button == 2 then { Cell: 'toolbarButtonHideStyle'} else {},
          ],
        },
      },
    ],
    horizontalCandidates: {
      // 定义一个横向候选文字展示区域
      type: 'horizontalCandidates',
      size: { width: '6/7' },
      // （非必须，默认值为 7）用于定义显示区域内最大候选文字数量
      maxColumns: 6,
      insets: { left: 3, right: 3 },
      backgroundStyle: 'toolbarClearBackgroundStyle',
      // 用于定义候选文字显示样式
      candidateStyle: 'horizontalCandidateStyle',
    },
    // 横向候选展开按键定义
    expandButton: makeToolbarButtonStyle('expandButtonForegroundStyle', { shortcut: '#candidatesBarStateToggle' }),
    expandButtonForegroundStyle:
      // 生成横向候选展开按钮前景。
      makeToolbarSystemImageForegroundStyle('chevron.down', { normalColor: color[theme]['按键前景颜色'], highlightColor: color[theme]['按键前景颜色'] }),

    // 纵向候选文字栏调式
    verticalCandidatesStyle: {
      insets: { left: 3, bottom: 1, top: 3 },
      backgroundStyle: 'toolbarFlatBackgroundStyle',
    },
    verticalCandidatesLayout: [
      {
        HStack: {
          subviews: [
            { Cell: 'verticalCandidates' },
          ],
        },
      },
      {
        HStack: {
          style: 'HStackStyle',
          subviews: [
            { Cell: 'verticalCandidatePageUpButton' },
            { Cell: 'verticalCandidatePageDownButton' },
            { Cell: 'verticalCandidateReturnButton' },
            { Cell: 'verticalCandidateBackspaceButton' },
          ],
        },
      },
    ],
    HStackStyle: {
      size: {
        height: '1/6',
      },
    },
    verticalCandidates: {
      // 定义一个纵向候选文字显示区域
      type: 'verticalCandidates',
      insets: { top: 3, left: 3, right: 3, bottom: 3 },
      // （非必须，默认值为 4）显示区域内候选文字最大行数
      maxRows: 5,
      // （非必须，默认值为 5）显示区域内候选文字最大列数
      maxColumns: 5,
      // （非必须）显示区域内分割线颜色
      // separatorColor: '#33338888',
      backgroundStyle: 'toolbarFlatBackgroundStyle',
      // 候选文字样式
      candidateStyle: 'verticalCandidateStyle',
    },
    // 纵向候选控制按钮
    verticalCandidatePageUpButton: makeSystemButtonStyle('verticalCandidatePageUpButtonForegroundStyle', { shortcut: '#verticalCandidatesPageUp' }),
    verticalCandidatePageDownButton: makeSystemButtonStyle('verticalCandidatePageDownButtonForegroundStyle', { shortcut: '#verticalCandidatesPageDown' }),
    verticalCandidateReturnButton: makeSystemButtonStyle('verticalCandidateReturnButtonForegroundStyle', { shortcut: '#candidatesBarStateToggle' }),
    // 注意：这里必须用 verticalCandidateBackspaceButtonForegroundStyle。
    // 原本引用的 backspaceButtonForegroundStyle 在符号键盘里并不存在
    //（符号键盘的删除键是文字版 symbolBackspaceButtonForegroundStyle），
    // 于是符号键盘纵向候选栏的删除键会没有图标。
    verticalCandidateBackspaceButton: makeSystemButtonStyle('verticalCandidateBackspaceButtonForegroundStyle', 'backspace'),

    // 工具栏 / 预编辑区 / 候选栏背景。
    //
    // 三件事一起解决：
    // 1) 原本工具栏是 2B2B2B 灰、按键区 0A0A0A 近黑，拼在一起工具栏明显发灰；
    // 2) 后来改成和键盘同色 + 胶囊圆角，结果四角切口露出系统背板（1C1C1E，
    //    偏灰），把整块黑啃出灰豁口，比发灰更难看；
    // 3) iOS 26 系统键盘自带整块圆角背板，皮肤再自刷一层就和它的圆角对不上色。
    //
    // 现在统一引用「键盘背景颜色」，而该令牌在 iOS26 深色下已改成几乎全透明
    // （1C1C1E01），于是工具栏、预编辑区、候选栏、按键区全部透出同一块系统
    // 背板，圆角由系统负责，四角天然吻合。
    // 不再写 cornerRadius —— 自己画圆角就会重新产生对不上色的切口。
    toolbarBackgroundStyle: styleFactories.makeGeometryStyle(color[theme]['键盘背景颜色']),
    // 预编辑区与纵向候选栏与工具栏不同高，但既然都是透明底，共用一个即可。
    // 保留独立样式名是为了以后想给某一区单独上色时有挂点。
    toolbarFlatBackgroundStyle: styleFactories.makeGeometryStyle(color[theme]['键盘背景颜色']),
    // 横向候选栏与工具栏同高，容器沿用胶囊；里层的 collection 必须透明，
    // 否则会在胶囊上再压一个直角矩形，把两端的圆角切掉。
    toolbarClearBackgroundStyle: styleFactories.makeGeometryStyle('00000000'),
    // 工具栏按钮背景。原本 normalColor/highlightColor 都是 0（全透明），
    // 按下时没有任何视觉反馈；现在常态仍透明、按下给一层淡色底。
    // 圆角 15 与工具栏胶囊语言一致（按钮内缩上下各 4pt，可用高 34pt，
    // 15 已接近半圆，视觉上是个小胶囊而不是圆角方块）。
    toolbarButtonBackgroundStyle: {
      buttonStyleType: 'geometry',
      normalColor: color[theme]['toolbar按键背景颜色-普通'],
      highlightColor: color[theme]['toolbar按键背景颜色-高亮'],
      cornerRadius: 15,
      insets: { top: 4, left: 3, right: 3, bottom: 4 },
    },
    // 切换键盘
    toolbarButtonswitchKeyboardStyle: makeToolbarButtonStyle('toolbarButtonswitchKeyboardForegroundStyle', {
      keyboardType: switchKeyboardType,
    }),

    toolbarButtonswitchKeyboardForegroundStyle: makeToolbarAssetImageForegroundStyle(switchKeyboardAsset),
    // 简繁切换与收起键盘
    toolbarButtonchangeSimplifiedandTraditionalStyle: makeToolbarButtonStyle('toolbarButtonchangeSimplifiedandTraditionalForegroundStyle', { shortcut: '#简繁切换' }),
    toolbarButtonchangeSimplifiedandTraditionalForegroundStyle: makeToolbarTextForegroundStyle('简繁', fontSize['toolbar按键前景文字大小']),
    toolbarButtonHideStyle: makeToolbarButtonStyle('toolbarButton1ForegroundStyle', 'dismissKeyboard'),
    toolbarButton1ForegroundStyle: makeToolbarTextForegroundStyle('收起', fontSize['toolbar按键前景文字大小']),
    // 单手模式
    toolbarButtonRighthandKeyboardStyle: makeToolbarButtonStyle('toolbarButtonRighthandForegroundStyle', { shortcut: '#右手模式' }),
    toolbarButtonRighthandForegroundStyle: makeToolbarTextForegroundStyle('右手', fontSize['toolbar按键前景文字大小']),
    toolbarButtonLefthandKeyboardStyle: makeToolbarButtonStyle('toolbarButtonLefthandForegroundStyle', { shortcut: '#左手模式' }),
    toolbarButtonLefthandForegroundStyle: makeToolbarTextForegroundStyle('左手', fontSize['toolbar按键前景文字大小']),
    // 菜单与面板
    // 固定按钮走 Cell 渲染路径，因此 action 要定义在样式对象上。
    toolbarButtonOpenAppMenuStyle: makeToolbarButtonStyle('toolbarButtonOpenAppMenuForegroundStyle', {
      shortcut: '#keyboardMenu',
    }),

    toolbarButtonOpenAppMenuForegroundStyle: makeToolbarTextForegroundStyle('菜单', fontSize['toolbar按键前景文字大小']),
    // menu_or_panel 在固定按钮场景下会直接引用这个样式对象。
    toolbarButtonPanelStyle: makeToolbarButtonStyle('toolbarButtonPanelForegroundStyle', {
      floatKeyboardType: 'panel',
    }),
    toolbarButtonPanelForegroundStyle: makeToolbarTextForegroundStyle('菜单', fontSize['toolbar按键前景文字大小']),
    // iPad 首位固定按钮在 toolbar_menu=false 时使用这个样式，动作是直接打开 App。
    toolbarButtonOpenAppStyle: makeToolbarButtonStyle('toolbarButtonOpenAppForegroundStyle', {
      openURL: 'hamster3://',
    }),
    toolbarButtonOpenAppForegroundStyle: makeToolbarTextForegroundStyle('菜单', fontSize['toolbar按键前景文字大小']),

    // 常用动作与键盘切换
    toolbarButtonNoteStyle: makeToolbarButtonStyle('toolbarButton3ForegroundStyle', {
      shortcutCommand: '#showPhraseView',
    }),
    toolbarButton3ForegroundStyle: makeToolbarTextForegroundStyle('常用', fontSize['toolbar按键前景文字大小']),
    toolbarButtonScriptStyle: makeToolbarButtonStyle('toolbarButtonScriptForegroundStyle', {
      shortcutCommand: '#toggleScriptView',
    }),
    toolbarButtonScriptForegroundStyle: makeToolbarTextForegroundStyle('脚本', fontSize['toolbar按键前景文字大小']),
    toolbarButtonEmojiStyle: makeToolbarButtonStyle('toolbarButtonEmojiForegroundStyle', { keyboardType: 'emojis' }),
    toolbarButtonEmojiForegroundStyle: makeToolbarTextForegroundStyle('表情', fontSize['toolbar按键前景文字大小']),
    toolbarButtonSymbolStyle: makeToolbarButtonStyle('toolbarButtonSymbolForegroundStyle', { keyboardType: 'symbolic' }),
    toolbarButtonSymbolForegroundStyle: makeToolbarTextForegroundStyle('符号', fontSize['toolbar按键前景文字大小']),
    toolbarButtonClipboardStyle: makeToolbarButtonStyle('toolbarButton4ForegroundStyle', {
      shortcutCommand: '#showPasteboardView',
    }),
    toolbarButton4ForegroundStyle: makeToolbarTextForegroundStyle('剪贴', fontSize['toolbar按键前景文字大小']),

    // 搜索与外部打开
    toolbarButtonSafariStyle: makeToolbarButtonStyle('toolbarButton5ForegroundStyle', { openURL: '#pasteboardContent' }),
    toolbarButton5ForegroundStyle: makeToolbarTextForegroundStyle('网址', fontSize['toolbar按键前景文字大小']),

    toolbarButtonAppleStyle: makeToolbarButtonStyle('toolbarButton6ForegroundStyle', { openURL: 'itms-apps://search.itunes.apple.com/WebObjects/MZSearch.woa/wa/search?media=software&term=#pasteboardContent' }),
    toolbarButton6ForegroundStyle: makeToolbarTextForegroundStyle('商店', fontSize['toolbar按键前景文字大小']),
    toolbarButtonGoogleStyle: makeToolbarButtonStyle('toolbarButton7ForegroundStyle', { openURL: 'https://www.google.com/search?q=#pasteboardContent' }),
    toolbarButtonBaiduStyle: makeToolbarButtonStyle('toolbarButtonBaiduForegroundStyle', { openURL: 'https://www.baidu.com/s?wd=#pasteboardContent' }),
    toolbarButtonBingStyle: makeToolbarButtonStyle('toolbarButtonBingForegroundStyle', { openURL: 'https://www.bing.com/search?q=#pasteboardContent' }),
    toolbarButton7ForegroundStyle: makeToolbarTextForegroundStyle('搜索', fontSize['toolbar按键前景文字大小']),
    toolbarButtonBaiduForegroundStyle: makeToolbarTextForegroundStyle('百度', fontSize['toolbar按键前景文字大小']),
    toolbarButtonBingForegroundStyle: makeToolbarTextForegroundStyle('Bing', fontSize['toolbar按键前景文字大小']),
    // 编辑控制
    toolbarButtonUndoStyle: makeToolbarButtonStyle('toolbarButtonUndoForegroundStyle', { shortcut: '#undo' }),
    toolbarButtonUndoForegroundStyle: makeToolbarTextForegroundStyle('撤销', fontSize['toolbar按键前景文字大小']),
    toolbarButtonRedoStyle: makeToolbarButtonStyle('toolbarButtonRedoForegroundStyle', { shortcut: '#redo' }),
    toolbarButtonRedoForegroundStyle: makeToolbarTextForegroundStyle('重做', fontSize['toolbar按键前景文字大小']),
    toolbarButtonCutStyle: makeToolbarButtonStyle('toolbarButtonCutForegroundStyle', { shortcut: '#cut' }),
    toolbarButtonCutForegroundStyle: makeToolbarTextForegroundStyle('剪切', fontSize['toolbar按键前景文字大小']),
    toolbarButtonCopyStyle: makeToolbarButtonStyle('toolbarButtonCopyForegroundStyle', { shortcut: '#copy' }),
    toolbarButtonCopyForegroundStyle: makeToolbarTextForegroundStyle('复制', fontSize['toolbar按键前景文字大小']),
    toolbarButtonPasteStyle: makeToolbarButtonStyle('toolbarButtonPasteForegroundStyle', { shortcut: '#paste' }),
    toolbarButtonPasteForegroundStyle: makeToolbarTextForegroundStyle('粘贴', fontSize['toolbar按键前景文字大小']),
    // 输入法与皮肤工具
    toolbarButtonRimeSwitcherStyle: makeToolbarButtonStyle('toolbarButtonRimeSwitcherForegroundStyle', { shortcut: '#RimeSwitcher' }),
    toolbarButtonRimeSwitcherForegroundStyle: makeToolbarTextForegroundStyle('方案', fontSize['toolbar按键前景文字大小']),
    toolbarButtonEmbeddingToggleStyle: makeToolbarButtonStyle('toolbarButtonEmbeddingToggleForegroundStyle', { shortcut: '#toggleEmbeddedInputMode' }),
    toolbarButtonEmbeddingToggleForegroundStyle: makeToolbarTextForegroundStyle('内嵌', fontSize['toolbar按键前景文字大小']),
    toolbarButtonKeyboardSettingsStyle: makeToolbarButtonStyle('toolbarButtonKeyboardSettingsForegroundStyle', { openURL: 'hamster3://com.ihsiao.apps.hamster3/keyboardSettings' }),
    toolbarButtonKeyboardSettingsForegroundStyle: makeToolbarTextForegroundStyle('设置', fontSize['toolbar按键前景文字大小']),
    toolbarButtonKeyboardSkinsStyle: makeToolbarButtonStyle('toolbarButtonKeyboardSkinsForegroundStyle', { openURL: 'hamster3://com.ihsiao.apps.hamster3/keyboardSkins' }),
    toolbarButtonKeyboardSkinsForegroundStyle: makeToolbarTextForegroundStyle('皮肤', fontSize['toolbar按键前景文字大小']),
    toolbarButtonSkinAdjustStyle: makeToolbarButtonStyle('toolbarButtonSkinAdjustForegroundStyle', { openURL: 'hamster3://com.ihsiao.apps.hamster3/finder?action=openSkinsFile&fileURL=jsonnet/Custom.libsonnet' }),
    toolbarButtonSkinAdjustForegroundStyle: makeToolbarTextForegroundStyle('调整', fontSize['toolbar按键前景文字大小']),
    toolbarButtonKeyboardPerformanceStyle: makeToolbarButtonStyle('toolbarButtonKeyboardPerformanceForegroundStyle', { shortcut: '#keyboardPerformance' }),
    toolbarButtonKeyboardPerformanceForegroundStyle: makeToolbarTextForegroundStyle('性能', fontSize['toolbar按键前景文字大小']),
    horizontalCandidateStyle: {
      insets: {
        top: 3,
        bottom: 3,
        left: 5,
        right: 5,
      },
      candidateStateButtonStyle: 'candidateStateButtonStyle',
      // 颜色必须是 6 / 8 位十六进制；原来写 0，长度不对、解析失败后回落系统色。
      highlightBackgroundColor: '00000000',
      preferredBackgroundColor: color[theme]['选中候选背景颜色'],
      preferredIndexColor: color[theme]['候选字体选中字体颜色'],
      preferredTextColor: color[theme]['候选字体选中字体颜色'],
      preferredCommentColor: color[theme]['候选字体选中字体颜色'],
      indexColor: color[theme]['候选字体未选中字体颜色'],
      textColor: color[theme]['候选字体未选中字体颜色'],
      commentColor: color[theme]['候选字体未选中字体颜色'],
      indexFontSize: fontSize['未展开comment字体大小'],
      textFontSize: fontSize['未展开候选字体选中字体大小'],
      commentFontSize: fontSize['未展开comment字体大小'],
    },
    candidateStateButtonStyle: { backgroundStyle: 'toolbarButtonBackgroundStyle', foregroundStyle: 'candidateStateButtonForegroundStyle' },
    candidateStateButtonForegroundStyle:
      // 生成横向候选状态按钮前景。
      makeToolbarSystemImageForegroundStyle('chevron.down'),

    // candidateStyle 只读官方文档 5.2 列出的那些 Key：insets /
    // backgroundCornerRadius / 各种 *Color 与 *FontSize。原来这里还写了
    // backgroundInsets / cornerRadius / backgroundColor / separatorColor
    // 四个不被读取的键（cornerRadius 的正确名字是 backgroundCornerRadius，
    // separatorColor 属于 verticalCandidates 节点而不是候选样式）。
    verticalCandidateStyle: {
      insets: {
        top: 8,
        bottom: 8,
        left: 8,
        right: 8,
      },
      backgroundCornerRadius: 7,
      highlightBackgroundColor: '00000000',
      preferredBackgroundColor: color[theme]['选中候选背景颜色'],
      preferredIndexColor: color[theme]['候选字体选中字体颜色'],
      preferredTextColor: color[theme]['候选字体选中字体颜色'],
      preferredCommentColor: color[theme]['候选字体选中字体颜色'],
      indexColor: color[theme]['长按非选中字体颜色'],
      textColor: color[theme]['长按非选中字体颜色'],
      commentColor: color[theme]['长按非选中字体颜色'],
      indexFontSize: fontSize['未展开comment字体大小'],
      textFontSize: fontSize['展开候选字体选中字体大小'],
      commentFontSize: fontSize['未展开comment字体大小'],
    },

    verticalCandidatePageUpButtonForegroundStyle: makeVerticalCandidateSystemImageForegroundStyle('chevron.up'),
    verticalCandidatePageDownButtonForegroundStyle: makeVerticalCandidateSystemImageForegroundStyle('chevron.down'),
    verticalCandidateReturnButtonForegroundStyle:
      // 生成纵向候选返回按钮前景。
      makeToolbarTextForegroundStyle('返回', fontSize['按键前景文字大小'] - 3),
    verticalCandidateBackspaceButtonForegroundStyle: makeVerticalCandidateSystemImageForegroundStyle('delete.left'),
    candidateContextMenu: [
      {
        name: '左移',
        action: { sendKeys: 'Control+j' },
      },
      {
        name: '右移',
        action: { sendKeys: 'Control+k' },
      },
      {
        name: '重置',
        action: { sendKeys: 'Control+l' },
      },
      {
        name: '置顶',
        action: { sendKeys: 'Control+p' },
      },
      {
        name: '移除',
        action: { sendKeys: 'Control+Delete' },
      },
    ],
  };

{
  getToolBar: getToolBar,
}
