// 定义拼音大写切换键及其预编辑通知。
local styleFactories = import '../../../shared/styles/styleFactories.libsonnet';

{
  build(theme, orientation, keyboardLayout, Settings, color, fontSize, createButton, baseHintStyles)::
    local makeShiftForegroundStyle(systemImageName) =
      // 生成 Shift 各状态的系统图标前景。
      styleFactories.makeSystemImageStyle(
        systemImageName,
        fontSize['按键前景文字大小'],
        color[theme]['按键前景颜色'],
        color[theme]['按键前景颜色'],
        {}
      );
    {
    shiftButton: createButton(
      'shift',
      if orientation == 'portrait' then
        keyboardLayout['竖屏按键尺寸']['shift键size']
      else
        keyboardLayout['横屏按键尺寸']['shift键size'],
      {},
      baseHintStyles,
      false
    ) + {
      backgroundStyle: 'systemButtonBackgroundStyle',
      action: 'shift',
      uppercasedStateAction: 'shift',
      capsLockedStateForegroundStyle: 'shiftButtonCapsLockedForegroundStyle',
      uppercasedStateForegroundStyle: 'shiftButtonUppercasedForegroundStyle',
      [if Settings.shift_config.enable_preedit then 'notification' else null]: [
        'shiftButtonPreeditNotification',
      ],
    },
    shiftButtonPreeditNotification: {
      notificationType: 'preeditChanged',
      backgroundStyle: 'systemButtonBackgroundStyle',
      foregroundStyle: 'shiftButtonPreeditForegroundStyle',
      action: { shortcut: '#重输' },
      swipeUpAction: if Settings.keyboard_layout == 26 && Settings.shift_config.preedit_swipeup_action == '辅助筛选' then { character: '`' } else { character: "'" },
    },
    shiftButtonPreeditForegroundStyle:
      styleFactories.makeTextStyle(
        '重输',
        fontSize['按键前景文字大小'] - 3,
        color[theme]['按键前景颜色'],
        color[theme]['按键前景颜色'],
        {}
      ),
    // Shift 状态前景
    shiftButtonForegroundStyle: makeShiftForegroundStyle('shift'),
    shiftButtonUppercasedForegroundStyle: makeShiftForegroundStyle('shift.fill'),
    shiftButtonCapsLockedForegroundStyle: makeShiftForegroundStyle('capslock.fill'),
  },
}
