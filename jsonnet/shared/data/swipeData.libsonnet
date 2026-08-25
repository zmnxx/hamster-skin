// 存放拼音与数字键盘的滑动动作数据。
local Settings = import '../../Custom.libsonnet';


local genSwipeData(deviceType) =
{
  /*
  说明:
    swipe_up和swipe_down为中文26键盘的划动数据
    下面对应的pinyin9(如果当前皮肤不是九键皮肤，就不用管)和number为中文九键和数字九键的划动数据
  格式说明:
    action: 必需， 格式同仓文档
    label:  非必需， 不设置这个不会生成对应前景，也就是不会显示在按键上，具体格式也见文档
  */

  swipe_up: {
    q: { action: { character: '1' }, label: { text: '1' } },  // action同仓皮肤定义，label可选text/systemImageName, 具体见仓皮肤文档，若不想显示，可设置为text: ""
    w: { action: { character: '2' }, label: { text: '2' } },
    e: { action: { character: '3' }, label: { text: '3' } },
    r: { action: { character: '4' }, label: { text: '4' } },
    t: { action: { character: '5' }, label: { text: '5' } },
    y: { action: { character: '6' }, label: { text: '6' } },
    u: { action: { character: '7' }, label: { text: '7' } },
    i: { action: { character: '8' }, label: { text: '8' } },
    o: { action: { character: '9' }, label: { text: '9' } },
    p: { action: { character: '0' }, label: { text: '0' } },
    a: { action: { character: '、' }, label: { text: '、' } },
    s: { action: { character: '-' }, label: { text: '-' } },
    d: { action: { character: '=' }, label: { text: '=' } },
    f: { action: { symbol: '【' }, label: { text: '[' } },
    g: { action: { symbol: '】' }, label: { text: ']' } },
    h: { action: if Settings.function_button_config.with_functions_row[deviceType] && Settings.function_button_config.enable_notification then { symbol: '\\' } else { character: '\\' }, label: { text: '\\' } },
    j: { action: { character: '/' }, label: { text: '/' } },
    k: { action: { character: ':' }, label: { text: ':' } },
    l: { action: { character: '"' }, label: { text: '"' } },
    z: { action: 'tab', label: { text: '⇥' } },
    x: { action: { character: '[' }, label: { text: '〔' } },
    c: { action: { character: ']' }, label: { text: '〕' } },
    v: { action: { character: '<' }, label: { text: '<' } },
    b: { action: { character: '>' }, label: { text: '>' } },
    n: { action: { character: '!' }, label: { text: '!' } },
    m: { action: { character: '?' }, label: { text: '?' } },
    spaceLeft: { action: { character: '.' } },
    backspace: { action: { shortcut: '#deleteText' } },
    enter: { action: { shortcut: '#换行' } },
  },
  swipe_down: {
    q: { action: { character: '~' }, label: { text: '~' } },
    w: { action: { character: '@' }, label: { text: '@' } },
    e: { action: { character: '#' }, label: { text: '#' } },
    r: { action: { character: '$' }, label: { text: '$' } },
    t: { action: { character: '%' }, label: { text: '%' } },
    y: { action: { character: '^' }, label: { text: '^' } },
    u: { action: { character: '&' }, label: { text: '&' } },
    i: { action: { character: '*' }, label: { text: '*' } },
    o: { action: { character: '(' }, label: { text: '(' } },
    p: { action: { character: ')' }, label: { text: ')' } },
    a: { action: { character: '`' }, label: { text: '`' } },
    s: { action: { character: '_' }, label: { text: '_' } },
    d: { action: { character: '+' }, label: { text: '+' } },
    f: { action: { character: '{' }, label: { text: '{' } },
    g: { action: { character: '}' }, label: { text: '}' } },
    h: { action: { character: '|' }, label: { text: '|' } },
    j: { action: { symbol: '.' }, label: { text: '.' } },
    k: { action: { character: ';' }, label: { text: ';' } },
    l: { action: { character: "'" }, label: { text: "'" } },
    z: {
      action: { character: 'V' },
      label: { systemImageName: 'av.remote.fill' },
      // center: { x: 0.5, y: 0.8 },  // 可单独指定偏移，例如 zxcvbnm 的下划位于按键正下方。
    },
    x: if Settings.function_button_config.with_functions_row[deviceType] then {
      action: { sendKeys: 'onl' },
      label: { systemImageName: 'clock.arrow.circlepath' },
    } else {
      action: { shortcut: '#cut' },
      label: { systemImageName: 'scissors' },
    },
    c: if Settings.function_button_config.with_functions_row[deviceType] then {
      action: { sendKeys: 'orc' },
      label: { systemImageName: 'calendar' },
    } else {
      action: { shortcut: '#copy' },
      label: { systemImageName: 'arrow.up.doc.on.clipboard' },
    },
    v: if Settings.function_button_config.with_functions_row[deviceType] then {
      action: { sendKeys: 'osj' },
      label: { systemImageName: 'clock.circle' },
    } else {
      action: { shortcut: '#paste' },
      label: { systemImageName: 'doc.on.clipboard.fill' },
    },
    b: if Settings.function_button_config.with_functions_row[deviceType] then {
      action: { sendKeys: 'R' },
      label: { systemImageName: if Settings.fix_sf_symbol then 'dollarsign.square.fill' else 'chineseyuanrenminbisign.square.fill' },
    } else {
      action: { shortcut: '#selectText' },
      label: { systemImageName: 'selection.pin.in.out' },
    },
    n: if Settings.function_button_config.with_functions_row[deviceType] then {
      action: { sendKeys: 'N' },
      label: { systemImageName: 'calendar.badge.exclamationmark' },
    } else {
      action: { shortcut: '#rimePreviousPage' },
      label: { systemImageName: 'chevron.up' },
    },
    m: if Settings.function_button_config.with_functions_row[deviceType] then {
      action: { character: '`' },
      label: { systemImageName: 'rectangle.3.group.fill' },
    } else {
      action: { shortcut: '#rimeNextPage' },
      label: { systemImageName: 'chevron.down' },
    },
    // '123': { action: { shortcut: '#方案切换' } },
    // space: { action: { shortcut: '#三选上屏' } },
    // spaceSecond: { action: { shortcut: '#三选上屏' } },
    backspace: { action: { shortcut: '#undo' } },
  },

  swipe_up_9: {
    // 九宫格数字键上划功能已删除
  },
  swipe_down_9: {
    // 九宫格数字键下划功能已删除
  },

  number_swipe_up: {
    // 数字键上划默认关闭；需要时按上面 swipe_up 的格式添加 '1'~'9' 条目。
    space:{ action: { shortcut: '#次选上屏' } },
  },
  number_swipe_down: {
    // 数字键下划默认关闭；需要时按上面 swipe_down 的格式添加条目。
    space: { action: { shortcut: '#三选上屏' } },
  },
};


{
  genSwipeData(deviceType): genSwipeData(deviceType)
}
