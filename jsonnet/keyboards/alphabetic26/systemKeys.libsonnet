// 定义英文 26 键系统键及其共享背景样式。
local animation = import '../../shared/styles/animation.libsonnet';
local center = import '../../shared/styles/center.libsonnet';
local color = import '../../shared/styles/color.libsonnet';
local fontSize = import '../../shared/styles/fontSize.libsonnet';
local hintSymbolsStyles = import '../../shared/styles/hintSymbolsStyles.libsonnet';
local swipeKeyStyles = import '../../shared/styles/swipeKeyStyles.libsonnet';
local styleFactories = import '../../shared/styles/styleFactories.libsonnet';
local buttonInteraction = import '../../shared/buttonHelpers/buttonInteraction.libsonnet';
local returnKeyHelpers = import '../../shared/buttonHelpers/returnKey.libsonnet';
local keycap = import '../../shared/styles/keycap.libsonnet';

{
  build(theme, orientation, keyboardLayout, settings, createButton, hintStyles):: (
    local makeAlphabeticSystemImageForegroundStyle(systemImageName, fontSizeDelta=0, extraCenter={}) =
      // 生成英文 26 键系统图标前景。
      styleFactories.makeSystemImageStyle(
        systemImageName,
        fontSize['按键前景文字大小'] + fontSizeDelta,
        color[theme]['按键前景颜色'],
        color[theme]['按键前景颜色'],
        extraCenter
      );
    local makeAlphabeticAssetImageForegroundStyle(assetImageName, fontSizeDelta=0, extraCenter={}) =
      // 生成英文 26 键资源图前景。
      {
        buttonStyleType: 'assetImage',
        assetImageName: assetImageName,
        normalColor: color[theme]['按键前景颜色'],
        highlightColor: color[theme]['按键前景颜色'],
        fontSize: fontSize['按键前景文字大小'] + fontSizeDelta,
        center: extraCenter,
      };
    local makeAlphabeticTextForegroundStyle(textValue, normalColor, fontSizeDelta=0, extraCenter={}) =
      // 生成英文 26 键文字前景。
      styleFactories.makeTextStyle(
        textValue,
        fontSize['按键前景文字大小'] + fontSizeDelta,
        normalColor,
        normalColor,
        extraCenter
      );
    local makeSpaceForegroundStyle() =
      // 生成主空格图标前景。
      makeAlphabeticSystemImageForegroundStyle('space', -3, center['功能键前景文字偏移']);
    local makeSpaceTextForegroundStyle(textValue, sizeDelta=0, extraCenter={}) =
      // 生成空格侧键文字前景。
      makeAlphabeticTextForegroundStyle(textValue, color[theme]['按键前景颜色'], sizeDelta, extraCenter);
    local button123 = buttonInteraction.button123;
    local slideEnabled = button123.enableSlide(settings);
    local useHintSymbols = !slideEnabled && button123.secondaryActionMode(settings) == 'hint_symbols';
    local useSwipeActions = !slideEnabled && button123.secondaryActionMode(settings) == 'swipe';
    local showIndicators = settings.show_swipe && useSwipeActions && button123.showSwipeIndicators(settings);
    local swipeTargets = button123.swipeMapping(settings);
    local extraHintStyles = if useHintSymbols then hintSymbolsStyles.getStyle(theme, button123.hintData) else {};
    local extraSwipeStyles =
      if useSwipeActions then
        swipeKeyStyles.getStyle(
          'cn',
          theme,
          { '123': button123.keyboardSwipeStyleData(swipeTargets.up) },
          { '123': button123.keyboardSwipeStyleData(swipeTargets.down) }
        )
      else
        {};
    local makeButtonBackground(normalKey, highlightKey) =
      // 生成英文 26 键中的通用按键背景。26 键键位窄，用紧凑间隙。
      keycap.buttonBackground(theme, orientation, settings, color, normalKey, highlightKey, {}, 'k26');
    local makeHintBackground() =
      // 生成英文 26 键长按气泡背景。
      keycap.hintBackground(theme, settings, color);
    local makeEnterForegroundStyle(textValue, useBlueText=false) =
      returnKeyHelpers.makeForeground(
        styleFactories,
        theme,
        color,
        fontSize,
        center,
        textValue,
        if useBlueText then {
          normalColor: color[theme]['长按选中字体颜色'],
          highlightColor: color[theme]['长按非选中字体颜色'],
        } else {}
      );
    {
    shiftButton: createButton(
      'shift',
      if orientation == 'portrait' then keyboardLayout['竖屏按键尺寸']['shift键size'] else keyboardLayout['横屏按键尺寸']['shift键size'],
      {},
      $,
      false
    ) + {
      backgroundStyle: 'systemButtonBackgroundStyle',
      action: 'shift',
      uppercasedStateAction: 'shift',
      capsLockedStateForegroundStyle: 'shiftButtonCapsLockedForegroundStyle',
      uppercasedStateForegroundStyle: 'shiftButtonUppercasedForegroundStyle',
    },
    shiftButtonForegroundStyle: makeAlphabeticSystemImageForegroundStyle('shift'),
    shiftButtonUppercasedForegroundStyle: makeAlphabeticSystemImageForegroundStyle('shift.fill'),
    shiftButtonCapsLockedForegroundStyle: makeAlphabeticSystemImageForegroundStyle('capslock.fill'),

    backspaceButton: createButton(
      'backspace',
      if orientation == 'portrait' then keyboardLayout['竖屏按键尺寸']['backspace键size'] else keyboardLayout['横屏按键尺寸']['backspace键size'],
      {},
      $,
      false
    ) + {
      backgroundStyle: 'systemButtonBackgroundStyle',
      action: 'backspace',
      repeatAction: 'backspace',
    },
    backspaceButtonForegroundStyle: makeAlphabeticSystemImageForegroundStyle('delete.left') + { targetScale: 0.7 },

    en2cnButton: createButton(
      'en2cn',
      if orientation == 'portrait' then keyboardLayout['竖屏按键尺寸']['en2cn键size'] else keyboardLayout['横屏按键尺寸']['en2cn键size'],
      {},
      $,
      false
    ) + {
      // 点按切回中文键盘。
      // 上划原本切到 temp_pinyin（另一份 26 键中文，划动角标、空格 RIME 角标、
      // 回车文案都与主键盘不同），会出现「同一个中文键盘两种样子」，已整体移除。
      action: { keyboardType: 'pinyin' },
    },
    en2cnButtonForegroundStyle:
      // 生成中英切换按钮前景。
      makeAlphabeticAssetImageForegroundStyle('englishState', -3, center['功能键前景文字偏移'] { y: 0.5 }),

    '123Button': createButton(
      '123',
      if orientation == 'portrait' then keyboardLayout['竖屏按键尺寸']['123键size'] else keyboardLayout['横屏按键尺寸']['123键size'],
      {},
      $ + extraHintStyles + extraSwipeStyles,
      false
    ) + {
      backgroundStyle: 'systemButtonBackgroundStyle',
      [if slideEnabled then 'type']: 'horizontalSymbols',
      [if slideEnabled then 'maxColumns']: 1,
      [if slideEnabled then 'contentRightToLeft']: false,
      [if slideEnabled then 'insets']: { left: 3, right: 3 },
      [if slideEnabled then 'dataSource']: '123ButtonSymbolsDataSource',
      [if !slideEnabled then 'action']: { keyboardType: 'numeric' },
      [if !slideEnabled then 'foregroundStyle']:
        ['123ButtonForegroundStyle'] +
        (if showIndicators then ['123ButtonUpForegroundStyle', '123ButtonDownForegroundStyle'] else []),
      // 123 键没有短按气泡（没生成 123ButtonHintForegroundStyle），
      // 隐去工厂写入的 hintStyle，避免悬空引用。
      hintStyle:: null,
      [if useHintSymbols then 'hintSymbolsStyle']: '123ButtonHintSymbolsStyle',
      [if useSwipeActions then 'swipeUpAction']: { keyboardType: swipeTargets.up },
      [if useSwipeActions then 'swipeDownAction']: { keyboardType: swipeTargets.down },
      [if !slideEnabled && !useSwipeActions then 'swipeUpAction']:: null,
      [if !slideEnabled && !useSwipeActions then 'swipeDownAction']:: null,
    },
    '123ButtonSymbolsDataSource': [
      { label: '1', action: { keyboardType: 'numeric' }, styleName: 'numericStyle' },
      { label: '2', action: { keyboardType: 'symbolic' }, styleName: 'symbolicStyle' },
      { label: '4', action: { keyboardType: 'emojis' }, styleName: 'emojisStyle' },
    ],
    } + extraHintStyles + extraSwipeStyles + keycap.animationRegistry(settings, animation) + {

    spaceButton: createButton(
      'space',
      if orientation == 'portrait' then keyboardLayout['竖屏按键尺寸']['space键size'] else keyboardLayout['横屏按键尺寸']['space键size'],
      {},
      $,
      false
    ) + {
      backgroundStyle: 'alphabeticBackgroundStyle',
      foregroundStyle: 'spaceButtonForegroundStyle',
      action: 'space',
    },
    // 主空格键
    spaceButtonForegroundStyle: makeSpaceForegroundStyle(),

    spaceFirstButton: createButton(
      'spaceFirst',
      if orientation == 'portrait' then keyboardLayout['竖屏按键尺寸']['space键size'] else keyboardLayout['横屏按键尺寸']['spaceFirst键size'],
      {},
      $,
      false
    ) + {
      backgroundStyle: 'alphabeticBackgroundStyle',
      action: 'space',
    },
    // 左侧空格键
    spaceFirstButtonForegroundStyle: makeSpaceForegroundStyle(),

    spaceSecondButton: createButton(
      'spaceSecond',
      if orientation == 'portrait' then keyboardLayout['竖屏按键尺寸']['space键size'] else keyboardLayout['横屏按键尺寸']['spaceSecond键size'],
      {},
      $,
      false
    ) + {
      backgroundStyle: 'alphabeticBackgroundStyle',
      foregroundStyle: 'spaceSecondButtonForegroundStyle',
      action: 'space',
    },
    // 右侧空格键
    spaceSecondButtonForegroundStyle: makeSpaceForegroundStyle(),

    local srBtn = createButton(
      'spaceRight',
      if orientation == 'portrait' then keyboardLayout['竖屏按键尺寸']['spaceRight键size'] else keyboardLayout['横屏按键尺寸']['spaceRight键size'],
      {},
      $,
      false
    ),
    spaceRightButton: srBtn {
      foregroundStyle: [
        'spaceRightButtonForegroundStyle',
      ],
      action: {
        symbol: '.',
      },
    },
    // 右侧标点键
    spaceRightButtonForegroundStyle: makeSpaceTextForegroundStyle('.'),

    // 左侧标点键直接复用 srBtn（右侧标点键的按钮对象）：两者 size 取的是同一个
    // 'spaceRight键size'，action / foregroundStyle 都在下面覆盖，逐字段相同。
    spaceLeftButton: srBtn {
      foregroundStyle: [
        'spaceLeftButtonForegroundStyle',
        'spaceLeftButtonForegroundStyle2',
      ],
      action: {
        symbol: '.',
      },
      // 下划打逗号。键面下方那个小逗号是它的角标 —— 不接这个动作的话，
      // 键面写着逗号却永远打不出逗号。
      swipeDownAction: {
        symbol: ',',
      },
    },
    // 左侧标点键：句号为主体，逗号作下划角标（位置与字号沿用英文角标那一套）
    spaceLeftButtonForegroundStyle: makeSpaceTextForegroundStyle('.', 0, center['26键中文前景偏移']),
    spaceLeftButtonForegroundStyle2: makeAlphabeticTextForegroundStyle(
      ',',
      color[theme]['英文划动字符颜色'],
      fontSize['英文划动角标文字大小'] - fontSize['按键前景文字大小'],
      center['英文下划文字偏移']
    ),

    enterButton: createButton(
      'enter',
      if orientation == 'portrait' then keyboardLayout['竖屏按键尺寸']['enter键size'] else keyboardLayout['横屏按键尺寸']['enter键size'],
      {},
      $,
      false
    ) + {
      [if std.objectHas(hintStyles, 'enterButtonHintSymbolsStyle') then 'hintSymbolsStyle']: 'enterButtonHintSymbolsStyle',
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
      notification: [
        'garyReturnKeyTypeNotification',
        'blueReturnKeyTypeNotification14',
        'blueReturnKeyTypeNotification6',
        'blueReturnKeyTypeNotification7',
        'blueReturnKeyTypeNotification9',
      ],
    },
    // 回车键前景
    enterButtonForegroundStyle0: makeEnterForegroundStyle('回车'),
    enterButtonForegroundStyle6: makeEnterForegroundStyle('搜索', true),
    enterButtonForegroundStyle7: makeEnterForegroundStyle('发送', true),
    enterButtonForegroundStyle14: makeEnterForegroundStyle('前往', true),
    enterButtonForegroundStyle9: makeEnterForegroundStyle('完成', true),
    enterButtonBlueBackgroundStyle: makeButtonBackground('enter键背景(强调色)', '功能键背景颜色-高亮'),

    alphabeticBackgroundStyle: makeButtonBackground('字母键背景颜色-普通', '字母键背景颜色-高亮'),
    systemButtonBackgroundStyle: makeButtonBackground('功能键背景颜色-普通', '功能键背景颜色-高亮'),
    // 功能行专用背景：与九键/数字页保持同一套间距
    functionRowButtonBackgroundStyle:
      keycap.buttonBackground(theme, orientation, settings, color, '字母键背景颜色-普通', '字母键背景颜色-高亮', {}, 'func'),
    alphabeticHintBackgroundStyle: makeHintBackground(),
    alphabeticHintSymbolsBackgroundStyle: keycap.longPressPanelBackground(theme, settings, hintSymbolsStyles['长按背景样式']),
    alphabeticHintSymbolsSelectedStyle: keycap.longPressPanelSelected(theme, settings, color, hintSymbolsStyles['长按选中背景样式']),

    // returnKeyType 通知
    garyReturnKeyTypeNotification: returnKeyHelpers.makeNotification([0, 2, 3, 5, 8, 10, 11], 'systemButtonBackgroundStyle', 'enterButtonForegroundStyle0'),
    blueReturnKeyTypeNotification14: returnKeyHelpers.makeNotification([1, 4], 'enterButtonBlueBackgroundStyle', 'enterButtonForegroundStyle14'),
    blueReturnKeyTypeNotification6: returnKeyHelpers.makeNotification([6], 'enterButtonBlueBackgroundStyle', 'enterButtonForegroundStyle6'),
    blueReturnKeyTypeNotification7: returnKeyHelpers.makeNotification([7], 'enterButtonBlueBackgroundStyle', 'enterButtonForegroundStyle7'),
    blueReturnKeyTypeNotification9: returnKeyHelpers.makeNotification([9], 'enterButtonBlueBackgroundStyle', 'enterButtonForegroundStyle9'),
    }
  ),
}
