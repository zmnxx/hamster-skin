// 英文键盘复用拼音 26 键映射；英文字母需把 character 转为直接上屏 symbol。
local pinyinSwipeData = import 'swipeData.libsonnet';

local genSwipeenData(deviceType) = (
  local pinyin = pinyinSwipeData.genSwipeData(deviceType);
  local lowerKeys = ['q', 'w', 'e', 'r', 't', 'y', 'u', 'i', 'o', 'p', 'a', 's', 'd', 'f', 'g', 'h', 'j', 'k', 'l'];
  local englishUp = {
    z: { action: { symbol: '@' }, label: { text: '@' } },
    x: { action: { symbol: '*' }, label: { text: '*' } },
    c: { action: { symbol: '`' }, label: { text: '`' } },
    v: { action: { symbol: '=' }, label: { text: '=' } },
    b: { action: { symbol: '[' }, label: { text: '[' } },
    n: { action: { symbol: '&' }, label: { text: '&' } },
    m: { action: { symbol: '?' }, label: { text: '?' } },
  };
  local toSymbol(item) = item {
    action: if std.type(item.action) == 'object' && std.objectHas(item.action, 'character') then
      { symbol: item.action.character }
    else item.action,
  };
  {
    swipe_up: {
      [key]: toSymbol(pinyin.swipe_up[key])
      for key in lowerKeys if std.objectHas(pinyin.swipe_up, key)
    } + englishUp + {
      spaceLeft: { action: { symbol: '.' } },
      spaceRight: { action: { symbol: '.' } },
      backspace: { action: { shortcut: '#deleteText' } },
      enter: { action: { shortcut: '#换行' } },
    },
    swipe_down: {
      [key]: toSymbol(pinyin.swipe_down[key])
      for key in lowerKeys if std.objectHas(pinyin.swipe_down, key)
    } + { z: { action: 'tab', label: { text: '⇥' } } },
  }
);

{ genSwipeenData(deviceType): genSwipeenData(deviceType) }
