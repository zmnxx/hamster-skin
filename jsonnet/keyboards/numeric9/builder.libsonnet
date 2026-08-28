// 组装数字 9 键键盘，汇合共享上下文、布局数据和样式注册。
local hintSymbolsData = import '../../shared/data/hintSymbolsData.libsonnet';
local swipeData = import '../../shared/data/swipeData.libsonnet';
local functions = import '../../shared/functionButtons/iPhone.libsonnet';
local functionButtonStyles = import '../../shared/functionButtons/styles.libsonnet';
local animation = import '../../shared/styles/animation.libsonnet';
local center = import '../../shared/styles/center.libsonnet';
local color = import '../../shared/styles/color.libsonnet';
local fontSize = import '../../shared/styles/fontSize.libsonnet';
local hintSymbolsStyles = import '../../shared/styles/hintSymbolsStyles.libsonnet';
local others = import '../../shared/styles/others.libsonnet';
local slideButtonStyles = import '../../shared/styles/slideButtonStyles.libsonnet';
local panels = import 'panels.libsonnet';
local swipeKeyStyles = import '../../shared/styles/swipeKeyStyles.libsonnet';
local buttonInteraction = import '../../shared/buttonHelpers/buttonInteraction.libsonnet';
local styleFactories = import '../../shared/styles/styleFactories.libsonnet';
local returnKeyHelpers = import '../../shared/buttonHelpers/returnKey.libsonnet';
local toolbar = import '../../shared/toolbar/iPhone.libsonnet';
local utils = import '../../shared/styles/keyStyles.libsonnet';
local keycap = import '../../shared/styles/keycap.libsonnet';

{
  createButtonFactory(context, swipeUp, swipeDown)::
    function(key, size, bounds, root)
      {
        [if size != {} then 'size']: size,
        backgroundStyle: if std.length(key) == 1 then 'numberButtonBackgroundStyle' else key + 'ButtonBackgroundStyle',
        foregroundStyle: std.filter(
          function(x) x != null,
          [
            if std.length(key) == 1 then 'number' + key + 'ButtonForegroundStyle' else key + 'ButtonForegroundStyle',
            if swipeKeyStyles.hasForeground(swipeUp, key) then 'number' + key + 'ButtonUpForegroundStyle' else null,
            if swipeKeyStyles.hasForeground(swipeDown, key) then 'number' + key + 'ButtonDownForegroundStyle' else null,
          ]
        ),
        action: if context.Settings.keyboard_layout == 9 then { symbol: key } else { character: key },
        [if std.objectHas(swipeUp, key) then 'swipeUpAction']: swipeUp[key].action,
        [if std.objectHas(swipeDown, key) then 'swipeDownAction']: swipeDown[key].action,
        [if std.length(key) == 1 && std.objectHas(hintSymbolsData.number, 'number' + key) then 'hintSymbolsStyle']: 'number' + key + 'ButtonHintSymbolsStyle',
        // 单色键帽模式下数字键盘按键没有按下动效；启用渐变键帽时补上，
        // 保持与拼音 / 英文键盘一致的手感。
        [if keycap.enabled(context.Settings) then 'animation']: keycap.animationNames(context.Settings),
        [if context.Settings.keyboard_layout == 9 && std.length(key) == 1 then 'notification']: [
          'number' + key + 'ButtonNotification',
        ],
      },

  createNotification(key, bounds={}):: {
    notificationType: 'preeditChanged',
    [if bounds != {} then 'bounds']: bounds,
    backgroundStyle: 'numberButtonBackgroundStyle',
    foregroundStyle: 'number' + key + 'ButtonForegroundStyle',
    action: { character: key },
  },

  build(context, layoutSpec)::
    local theme = context.theme;
    local orientation = context.orientation;
    local makeButtonBackground(normalKey, highlightKey) =
      // 生成数字键盘中的通用按键背景。
      keycap.buttonBackground(theme, orientation, context.Settings, color, normalKey, highlightKey);
    local makeFunctionTextForegroundStyle(textValue, fontSizeValue, centerValue={}, extra={}) =
      // 生成数字键盘功能键共用的文字前景。
      styleFactories.makeTextStyle(
        textValue,
        fontSizeValue,
        color[theme]['按键前景颜色'],
        color[theme]['按键前景颜色'],
        centerValue
      ) + extra;
    local makeFunctionSystemImageForegroundStyle(systemImageName, fontSizeValue, centerValue={}, extra={}) =
      // 生成数字键盘功能键共用的系统图标前景。
      styleFactories.makeSystemImageStyle(
        systemImageName,
        fontSizeValue,
        color[theme]['按键前景颜色'],
        color[theme]['按键前景颜色'],
        centerValue
      ) + extra;
    local makeEnterForegroundStyle(textValue, useBlueText=false, withCenter=true, withInsets=true) =
      returnKeyHelpers.makeForeground(
        styleFactories,
        theme,
        color,
        fontSize,
        center,
        textValue,
        (if useBlueText then {
          normalColor: color[theme]['长按选中字体颜色'],
          highlightColor: color[theme]['长按非选中字体颜色'],
        } else {}) +
        (if withCenter then { center: center['功能键前景文字偏移'] } else {}) +
        (if withInsets then { insets: { top: 4, left: 3, bottom: 4, right: 3 } } else {})
      );
    local swipeDataRoot = swipeData.genSwipeData(context.deviceType);
    local swipeUp = if std.objectHas(swipeDataRoot, 'number_swipe_up') then swipeDataRoot.number_swipe_up else {};
    local swipeDown = if std.objectHas(swipeDataRoot, 'number_swipe_down') then swipeDataRoot.number_swipe_down else {};
    local symbolButtonHelper = buttonInteraction.symbolButton;
    local slideEnabled = symbolButtonHelper.enableSlide(context.Settings);
    local useHintSymbols = !slideEnabled && symbolButtonHelper.secondaryActionMode(context.Settings) == 'hint_symbols';
    local useSwipeActions = !slideEnabled && symbolButtonHelper.secondaryActionMode(context.Settings) == 'swipe';
    local swipeTargets = symbolButtonHelper.swipeMapping(context.Settings);
    local createButton = self.createButtonFactory(context, swipeUp, swipeDown);
    local createNotification = self.createNotification;
    slideButtonStyles.slideButtonStyles(theme) +
    (if useHintSymbols then hintSymbolsStyles.getStyle(theme, symbolButtonHelper.hintData) else {}) +
    {
      preeditHeight: others[if orientation == 'portrait' then '竖屏' else '横屏']['preedit高度'],
      toolbarHeight: others[if orientation == 'portrait' then '竖屏' else '横屏']['toolbar高度'],
      keyboardHeight: others[if orientation == 'portrait' then '竖屏' else '横屏']['keyboard高度'],

      keyboardLayout: layoutSpec,
      rowofFunctionStyle: {
        size: {
          // 横竖屏同一比例，与九键 / 26 键的功能行一致
          height: { percentage: 0.17 },
        },
        backgroundStyle: 'keyboardBackgroundStyle',
      },
      keyboardStyle: {
        size: {
          // 按键区占 73%，余下让给系统在键盘底部占用的那条区域
          // （地球 / 麦克风所在的一行）。
          height: { percentage: 0.73 },
        },
        insets: {
          top: 3,
          bottom: 3,
          left: 4,
          right: 4,
        },
        // keyboardBackgroundStyle 曾指向一张皮肤里不存在的 bg.png，元书遇到
        // 缺图会退回系统默认底色，数字键盘背景于是比其他键盘浅一档。
        backgroundStyle: 'keyboardBackgroundStyle',
      },
      keyboardBackgroundStyle: styleFactories.makeGeometryStyle(color[theme]['键盘背景颜色']),
      // 左右两列同宽，中列吃掉剩下的：29/183 × 2 + 375/549 = 1
      VStackStyle1: {
        size: {
          width: '29/183',
        },
      },
      CenterStackStyle: {
        size: {
          width: '375/549',
        },
      },
      returnButton: createButton('return', {}, {}, $) + {
        backgroundStyle: 'systemButtonBackgroundStyle',
        // 固定回到中文主键盘，而不是「上一个主键盘」。
        //
        // 原来用的 returnPrimaryKeyboard，官方定义的「主键盘」包含 pinyin 与
        // alphabetic 两种，所以从英文 26 键进 123 再返回会落回英文键盘 ——
        // 同一个返回键在不同来路下去向不同。
        //
        // 直接指定 keyboardType: 'pinyin' 后，无论从九键、26 键中文还是英文
        // 键盘进来，返回都落到中文主键盘；而 config.yaml 里 pinyin 那一组指向的
        // 文件由 Custom 的 keyboard_layout 决定装九键还是 26 键，
        // 所以「返回到我正在用的那种中文键盘」是自动成立的，不必在这里判断。
        action: { keyboardType: 'pinyin' },
      },
      returnButtonForegroundStyle:
        // 生成返回键前景。
        makeFunctionTextForegroundStyle('返回', fontSize['按键前景文字大小'] - 3),
    } +
    {
      ['number' + std.toString(num) + 'Button']: createButton(std.toString(num), {}, {}, $)
      for num in std.range(0, 9)
    } +
    {
      ['number' + std.toString(num) + 'ButtonNotification']: createNotification(std.toString(num))
      for num in std.range(0, 9)
    } +
    {
      symbolButton: {
        size: {
          height: '1/4',
        },
        backgroundStyle: 'systemButtonBackgroundStyle',
        [if slideEnabled then 'type']: 'horizontalSymbols',
        [if slideEnabled then 'maxColumns']: 1,
        [if slideEnabled then 'insets']: { left: 3, right: 3 },
        [if slideEnabled then 'contentRightToLeft']: false,
        [if slideEnabled then 'dataSource']: 'symbolButtonSymbolsDataSource',
        [if !slideEnabled then 'foregroundStyle']: 'symbolicButtonForegroundStyle',
        [if !slideEnabled then 'action']: { keyboardType: 'symbolic' },
        [if useHintSymbols then 'hintSymbolsStyle']: 'symbolButtonHintSymbolsStyle',
        [if useSwipeActions then 'swipeUpAction']: { keyboardType: swipeTargets.up },
      },
      symbolButtonSymbolsDataSource: [
        { label: '1', action: { keyboardType: 'symbolic' }, styleName: 'symbolicStyle' },
        { label: '3', action: { keyboardType: 'emojis' }, styleName: 'emojisStyle' },
      ],
      spaceButton: createButton('space', {}, {}, $) + {
        backgroundStyle: 'systemButtonBackgroundStyle',
        action: 'space',
        // 123 数字键盘的空格键上划：跳转到 26 键英文键盘。
        swipeUpAction: { keyboardType: 'alphabetic' },
      },
      spaceButtonForegroundStyle:
        // 生成空格键前景。
        makeFunctionSystemImageForegroundStyle('space', fontSize['按键前景文字大小'] - 3),
      backspaceButton: createButton('backspace', {}, {}, $) + {
        backgroundStyle: 'systemButtonBackgroundStyle',
        action: 'backspace',
        repeatAction: 'backspace',
        swipeUpAction: { shortcut: '#deleteText' },
        swipeDownAction: { shortcut: '#undo' },
      },
      backspaceButtonForegroundStyle:
        // 生成退格键前景。
        makeFunctionSystemImageForegroundStyle('delete.left', fontSize['数字键盘数字前景字体大小'] - 3),
      spaceRightButton: createButton('spaceRight', {}, {}, $) + {
        backgroundStyle: 'systemButtonBackgroundStyle',
        action: {
          symbol: '.',
        },
        notification: [
          'spaceRightButtonPreeditNotification',
        ],
      },
      spaceRightButtonPreeditNotification: {
        notificationType: 'preeditChanged',
        backgroundStyle: 'systemButtonBackgroundStyle',
        foregroundStyle: 'spaceRightButtonForegroundStyle',
        action: { character: '.' },
      },
      spaceRightButtonForegroundStyle:
        // 生成右侧句号前景。
        makeFunctionTextForegroundStyle('.', fontSize['数字键盘数字前景字体大小']),
      atButton: createButton('at', {}, {}, $) + {
        backgroundStyle: 'systemButtonBackgroundStyle',
        action: {
          character: '=',
        },
        swipeUpAction: { character: 'V' },
      },
      atButtonForegroundStyle:
        // 生成等号键前景。
        makeFunctionTextForegroundStyle('=', fontSize['collection前景字体大小'], {}, { fontWeight: 'regular' }),
      enterButton: createButton('enter', {}, {}, $) + {
        backgroundStyle: [
          {
            styleName: 'systemButtonBackgroundStyle',
            conditionKey: '$returnKeyType',
            conditionValue: [0, 2, 3, 5, 8, 10, 11],
          },
          {
            styleName: 'enterButtonBlueBackgroundStyle',
            conditionKey: '$returnKeyType',
            conditionValue: [1, 4, 6, 7, 9],
          },
        ],
        foregroundStyle: [
          {
            styleName: 'enterButtonForegroundStyle0',
            conditionKey: '$returnKeyType',
            conditionValue: [0, 2, 3, 5, 8, 10, 11],
          },
          {
            styleName: 'enterButtonForegroundStyle14',
            conditionKey: '$returnKeyType',
            conditionValue: [1, 4],
          },
          {
            styleName: 'enterButtonForegroundStyle6',
            conditionKey: '$returnKeyType',
            conditionValue: [6],
          },
          {
            styleName: 'enterButtonForegroundStyle7',
            conditionKey: '$returnKeyType',
            conditionValue: [7],
          },
          {
            styleName: 'enterButtonForegroundStyle9',
            conditionKey: '$returnKeyType',
            conditionValue: [9],
          },
        ],
        action: 'enter',
      },
      // 回车键前景
      enterButtonForegroundStyle: makeEnterForegroundStyle('换行', false, false),
      enterButtonForegroundStyle0: makeEnterForegroundStyle('回车'),
      enterButtonForegroundStyle6: makeEnterForegroundStyle('搜索', true),
      enterButtonForegroundStyle7: makeEnterForegroundStyle('发送', true),
      enterButtonForegroundStyle14: makeEnterForegroundStyle('前往', true),
      enterButtonForegroundStyle9: makeEnterForegroundStyle('完成', true),
      enterButtonBlueBackgroundStyle: makeButtonBackground('enter键背景(强调色)', '功能键背景颜色-高亮'),
      numberButtonBackgroundStyle: makeButtonBackground('字母键背景颜色-普通', '字母键背景颜色-高亮'),
      functionBackgroundStyle: makeButtonBackground('字母键背景颜色-普通', '字母键背景颜色-高亮'),
      systemButtonBackgroundStyle: makeButtonBackground('功能键背景颜色-普通', '功能键背景颜色-高亮'),
      // 功能行专用背景：与其他键盘保持同一套间距
      functionRowButtonBackgroundStyle:
        keycap.buttonBackground(theme, orientation, context.Settings, color, '字母键背景颜色-普通', '字母键背景颜色-高亮', {}, 'func'),
      alphabeticHintSymbolsBackgroundStyle: keycap.longPressPanelBackground(theme, context.Settings, hintSymbolsStyles['长按背景样式']),
      alphabeticHintSymbolsSelectedStyle: keycap.longPressPanelSelected(theme, context.Settings, color, hintSymbolsStyles['长按选中背景样式']),
    } +
    keycap.animationRegistry(context.Settings, animation) +
    panels.build(context, theme, orientation) +
    swipeKeyStyles.getStyle('number', theme, swipeUp, swipeDown) +
    hintSymbolsStyles.getStyle(theme, hintSymbolsData.number) +
    toolbar.getToolBar(theme) +
    utils.genNumberStyles(fontSize, color, theme, center) +
    functionButtonStyles.genFuncKeyStyles(fontSize, color, theme, center) +
    functions.makeFunctionButtons('', {}, 'numeric'),
}
