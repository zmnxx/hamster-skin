// 123Button 与符号按钮的交互配置辅助。
//
// 两个键的次级功能（进符号键盘 / emoji 键盘）有三种呈现方式，由 Custom 的
// button_123_config / button_symbol_config 决定：
//   enable_slide = true            键面本身是 horizontalSymbols 滑动列
//   secondary_action_mode = swipe  上 / 下划切换
//   secondary_action_mode = hint_symbols  长按弹面板
local symbolicLabel = { systemImageName: 'command.circle.fill' };
local emojisLabel = { systemImageName: 'face.dashed' };

// 键盘类型只允许 symbolic / emojis，其余值回落 fallback。
local normalizeKeyboardType(value, fallback) =
  if value == 'symbolic' || value == 'emojis' then value else fallback;

local readConf(settings, name) =
  if std.objectHas(settings, name) then settings[name] else {};

local readOpt(conf, name, fallback) =
  if std.objectHas(conf, name) then conf[name] else fallback;

// 123 键上下划各切一个键盘。两边配成同一个时把下划改成另一个，
// 否则上下划行为完全一样，等于少一个入口。
local button123SwipeMapping(settings) =
  local conf = readConf(settings, 'button_123_config');
  local up = normalizeKeyboardType(readOpt(conf, 'swipe_up_keyboard', 'symbolic'), 'symbolic');
  local downDefault = if up == 'symbolic' then 'emojis' else 'symbolic';
  local down = normalizeKeyboardType(readOpt(conf, 'swipe_down_keyboard', downDefault), downDefault);
  {
    up: up,
    down: if down == up then downDefault else down,
  };

// 符号键点击本身已进 symbolic，所以上划固定给 emojis。
local symbolButtonSwipeMapping(settings) =
  local conf = readConf(settings, 'button_symbol_config');
  local up = normalizeKeyboardType(readOpt(conf, 'swipe_up_keyboard', 'emojis'), 'emojis');
  { up: if up == 'symbolic' then 'emojis' else up };

{
  button123: {
    enableSlide(settings): readOpt(readConf(settings, 'button_123_config'), 'enable_slide', true),
    secondaryActionMode(settings):
      readOpt(readConf(settings, 'button_123_config'), 'secondary_action_mode', 'hint_symbols'),
    showSwipeIndicators(settings):
      readOpt(readConf(settings, 'button_123_config'), 'show_swipe_indicators', false),
    swipeMapping(settings): button123SwipeMapping(settings),

    // hint_symbols 模式的长按面板内容
    hintData: {
      '123': {
        selectedIndex: 0,
        list: [
          { action: { keyboardType: 'symbolic' }, label: symbolicLabel, fontSize: 16 },
          { action: { keyboardType: 'emojis' }, label: emojisLabel, fontSize: 16 },
        ],
      },
    },

    // swipe 模式下上 / 下划角标的内容
    keyboardSwipeStyleData(keyboardType): {
      action: { keyboardType: keyboardType },
      label: if keyboardType == 'symbolic' then symbolicLabel else emojisLabel,
    },
  },

  symbolButton: {
    enableSlide(settings): readOpt(readConf(settings, 'button_symbol_config'), 'enable_slide', true),
    secondaryActionMode(settings):
      readOpt(readConf(settings, 'button_symbol_config'), 'secondary_action_mode', 'hint_symbols'),
    swipeMapping(settings): symbolButtonSwipeMapping(settings),

    hintData: {
      symbol: {
        selectedIndex: 0,
        list: [
          { action: { keyboardType: 'emojis' }, label: emojisLabel, fontSize: 16 },
        ],
      },
    },
  },
}
