// 定义拼音空格键族。
local styleFactories = import '../../../shared/styles/styleFactories.libsonnet';

{
  build(theme, orientation, keyboardLayout, Settings, color, fontSize, center, createButton, baseHintStyles)::
    local makeSystemImageForegroundStyle(systemImageName, fontSizeDelta=0, extraCenter={}) =
      // 生成空格键族共用的系统图标前景。
      styleFactories.makeSystemImageStyle(
        systemImageName,
        fontSize['按键前景文字大小'] + fontSizeDelta,
        color[theme]['按键前景颜色'],
        color[theme]['按键前景颜色'],
        if extraCenter == {} then center['功能键前景文字偏移'] else extraCenter
      );
    local makeTextForegroundStyle(textValue, normalColor, fontSizeDelta=0, extraCenter={}) =
      // 生成空格键族共用的文字前景。
      styleFactories.makeTextStyle(
        textValue,
        fontSize['按键前景文字大小'] + fontSizeDelta,
        normalColor,
        normalColor,
        extraCenter
      );
    local makeSpaceForegroundStyle() =
      // 生成主空格图标前景。
      makeSystemImageForegroundStyle('space', -3);
    // 空格键在打字状态下换成这个通知：键面不变，只是上 / 下划改成次选 / 三选上屏。
    // 不打字时空格没有划动动作，避免误触。
    local makeSpacePreeditNotification(foregroundStyle) = {
      notificationType: 'preeditChanged',
      backgroundStyle: 'alphabeticBackgroundStyle',
      foregroundStyle: foregroundStyle,
      swipeUpAction: { shortcut: '#次选上屏' },
      swipeDownAction: { shortcut: '#三选上屏' },
    };
    {
    spaceButton: createButton(
      'space',
      if orientation == 'portrait' then
        keyboardLayout['竖屏按键尺寸']['space键size']
      else
        keyboardLayout['横屏按键尺寸']['space键size'],
      {},
      baseHintStyles,
      false
    ) + {
      foregroundStyle: 'spaceButtonForegroundStyle',
      action: 'space',
      [if Settings.keyboard_layout == 26 then 'swipeUpAction']: { sendKeys: 'Shift+space' },
      notification: [
        'spaceButtonPreeditNotification',
      ],
    },
    // 主空格键
    spaceButtonPreeditNotification: makeSpacePreeditNotification('spaceButtonForegroundStyle'),
    spaceButtonForegroundStyle: makeSpaceForegroundStyle(),

    spaceFirstButton: createButton(
      'spaceFirst',
      if orientation == 'portrait' then
        keyboardLayout['竖屏按键尺寸']['space键size']
      else
        keyboardLayout['横屏按键尺寸']['spaceFirst键size'],
      {},
      baseHintStyles,
      false
    ) + {
      foregroundStyle: 'spaceFirstButtonForegroundStyle',
      action: 'space',
      [if Settings.keyboard_layout == 26 then 'swipeUpAction']: { sendKeys: 'Shift+space' },
      notification: [
        'spaceFirstButtonPreeditNotification',
      ],
    },
    // 左侧空格键
    spaceFirstButtonPreeditNotification: makeSpacePreeditNotification('spaceFirstButtonForegroundStyle'),
    spaceFirstButtonForegroundStyle: makeSpaceForegroundStyle(),

    spaceSecondButton: createButton(
      'spaceSecond',
      if orientation == 'portrait' then
        keyboardLayout['竖屏按键尺寸']['space键size']
      else
        keyboardLayout['横屏按键尺寸']['spaceSecond键size'],
      {},
      baseHintStyles,
      false
    ) + {
      foregroundStyle: 'spaceSecondButtonForegroundStyle',
      action: 'space',
      [if Settings.keyboard_layout == 26 then 'swipeUpAction']: { sendKeys: 'Shift+space' },
      notification: [
        'spaceSecondButtonPreeditNotification',
      ],
    },
    // 右侧空格键
    spaceSecondButtonPreeditNotification: makeSpacePreeditNotification('spaceSecondButtonForegroundStyle'),
    spaceSecondButtonForegroundStyle: makeSpaceForegroundStyle(),

    spaceRightButton: createButton(
      'spaceRight',
      if orientation == 'portrait' then
        keyboardLayout['竖屏按键尺寸']['spaceRight键size']
      else
        keyboardLayout['横屏按键尺寸']['spaceRight键size'],
      {},
      baseHintStyles,
      false
    ) + {
      action: { character: '.' },
      repeatAction: { character: '.' },
      notification: [
        'spaceRightButtonPreeditNotification',
      ],
    },
    spaceRightButtonPreeditNotification: {
      notificationType: 'preeditChanged',
      backgroundStyle: 'alphabeticBackgroundStyle',
      foregroundStyle: 'spaceRightButtonPreeditForegroundStyle',
      action: Settings.tips_button_action,
      swipeUpAction: { character: '.' },
      hintSymbolsStyle: 'cn2enButtonHintSymbolsStyle',
    },
    spaceRightButtonPreeditForegroundStyle:
      // 生成提示灯泡前景。
      makeSystemImageForegroundStyle(if Settings.fix_sf_symbol then 'lightbulb' else 'lightbulb.max', 0, {}),
    spaceRightButtonForegroundStyle:
      // 生成右侧句号前景。
      makeTextForegroundStyle('。', color[theme]['按键前景颜色']),

    spaceLeftButton: createButton(
      'spaceLeft',
      if orientation == 'portrait' then
        keyboardLayout['竖屏按键尺寸']['spaceRight键size']
      else
        keyboardLayout['横屏按键尺寸']['spaceRight键size'],
      {},
      baseHintStyles,
      false
    ) + {
      foregroundStyle: [
        'spaceLeftButtonForegroundStyle',
        'spaceLeftButtonForegroundStyle2',
      ],
      action: { character: '.' },
      // 只加下划动作，键面显示保持原样（逗号居中 + 句号在上）
      swipeDownAction: { character: ',' },
    },
    spaceLeftButtonForegroundStyle:
      // 生成左侧逗号前景。
      makeTextForegroundStyle(',', color[theme]['按键前景颜色'], 0, { x: 0.5, y: 0.5 }),
    spaceLeftButtonForegroundStyle2:
      // 生成左侧句号前景。
      makeTextForegroundStyle('.', color[theme]['按键前景颜色'], -2, { x: 0.5, y: 0.3 }),
  },
}
