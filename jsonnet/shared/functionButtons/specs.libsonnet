// 功能行按钮的动作与通知规格。
//
// 每个键有两套动作：非打字状态读 actionMap / repeatMap，打字状态（preeditChanged
// 通知命中）读 notification* 那几张表。键面文字见 styles.libsonnet。
{
  defaultOrderedKeys: ['left', 'head', 'select', 'cut', 'copy', 'paste', 'tail', 'right'],

  // 只保留 Custom 里合法且已知的键；配置为空或全非法时用默认顺序。
  resolveOrderedKeys(Settings)::
    local config =
      if std.objectHas(Settings, 'function_button_config') && std.type(Settings.function_button_config) == 'object' then
        Settings.function_button_config
      else
        {};
    local configured =
      if std.objectHas(config, 'order') && std.type(config.order) == 'array' then
        [
          key
          for key in config.order
          if std.type(key) == 'string' && std.member(self.defaultOrderedKeys, key)
        ]
      else
        [];
    if std.length(configured) > 0 then configured else self.defaultOrderedKeys,

  // ---- 非打字状态 ----
  actionMap: {
    left: { action: 'moveCursorBackward' },
    head: { action: { shortcut: '#行首' } },
    select: { action: { shortcut: '#selectText' } },
    cut: { action: { shortcut: '#cut' } },
    copy: { action: { shortcut: '#copy' } },
    paste: { action: { shortcut: '#paste' } },
    tail: { action: { shortcut: '#行尾' } },
    right: { action: 'moveCursorForward' },
  },

  // 只有左右移动键需要长按连发。
  repeatMap: {
    left: { action: 'moveCursorBackward' },
    right: { action: 'moveCursorForward' },
  },

  // ---- 打字状态（preeditChanged）----
  notificationActionMap: {
    left: { action: { sendKeys: 'Up' } },
    head: { action: { shortcut: '#rimeNextPage' } },
    select: { action: { character: '7' } },
    cut: { action: { character: '8' } },
    copy: { action: { character: '9' } },
    paste: { action: { character: '0' } },
    // 打字时 tail 是候选栏展开 / 收起；非打字状态的行尾在 actionMap 里。
    tail: { action: { shortcut: '#candidatesBarStateToggle' } },
    right: { action: { sendKeys: 'Down' } },
  },

  notificationSwipeUpMap: {
    left: { action: { character: '[' } },
    head: { action: { shortcut: '#rimePreviousPage' } },
    select: { action: { sendKeys: 'control+1' } },
    cut: { action: { sendKeys: 'control+2' } },
    copy: { action: { sendKeys: 'control+3' } },
    paste: { action: { sendKeys: 'control+4' } },
    right: { action: { character: ']' } },
  },

  notificationSwipeDownMap: {
    left: { action: { sendKeys: 'Left' } },
    head: { action: { shortcut: '#rimeNextPage' } },
    select: { action: { sendKeys: 'control+1' } },
    cut: { action: { sendKeys: 'control+2' } },
    copy: { action: { sendKeys: 'control+3' } },
    paste: { action: { sendKeys: 'control+4' } },
    right: { action: { sendKeys: 'Right' } },
  },

  notificationRepeatMap: {
    left: { action: { sendKeys: 'Up' } },
    right: { action: { sendKeys: 'Down' } },
  },

  resolveNotificationActionMap(keyboardType)::
    if keyboardType == 't9' then
      self.notificationActionMap {
        // 九键打字态这四个键：
        // 次选 / 三选 —— 九键重码远多于全拼，直接点选第二、三候选比翻找快。
        // 词首 / 词尾 —— 以词定字。九键打单字重码太多，先打词再取其中一个字更准。
        //                方案侧需启用 lua_processor@*select_character，并把
        //                key_binder/select_first_character 设为 bracketleft、
        //                select_last_character 设为 bracketright。
        select: { action: { shortcut: '#次选上屏' } },
        cut: { action: { shortcut: '#三选上屏' } },
        copy: { action: { character: '[' } },
        paste: { action: { character: ']' } },
      }
    else
      self.notificationActionMap,

  // 英文 / 数字键盘打字态没有候选，中间五个键的通知没有意义，直接不挂。
  notificationEnabled(Settings, keyboardType, key)::
    local config =
      if std.objectHas(Settings, 'function_button_config') && std.type(Settings.function_button_config) == 'object' then
        Settings.function_button_config
      else
        {};
    local disabled =
      if std.member(['alphabetic', 'numeric'], keyboardType) then
        ['select', 'cut', 'copy', 'paste', 'tail']
      else
        [];
    if std.member(disabled, key) then
      false
    else if std.objectHas(config, 'enable_notification') then config.enable_notification
    else true,
}
