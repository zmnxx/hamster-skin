// 皮肤入口。
//
// 输出两类文件：
//   config.yaml                        —— 键盘清单，告诉元书每种键盘用哪个 yaml
//   <light|dark>/<名称>_<朝向>.yaml    —— 各键盘的完整样式定义
//
// 皮肤共 6 种键盘，全部在下面的 config 里声明：
//   pinyin       中文主键盘（九宫格 / 26 键，由 Custom.libsonnet 的 keyboard_layout 决定）
//   temp_pinyin  临时中文 26 键（在英文键盘上划切回中文时用）
//   alphabetic   英文 26 键
//   numeric      数字九宫格
//   symbolic     符号键盘
//   panel        浮动功能面板
//
// 注意：pinyin 那一组的文件名固定叫 pinyin_26_*，与 keyboard_layout 取值无关——
// 元书只认 config.yaml 里的名字，文件里装的是九键还是 26 键由本文件决定。

local config = {
  author: 'BlackCCCat',
  name: '元书皮肤-简约5-棕金',

  // 中文主键盘
  pinyin: {
    iPhone: {
      portrait: 'pinyin_26_portrait',
      landscape: 'pinyin_26_landscape',
    },
    iPad: {
      portrait: 'ipad_pinyin_26_portrait',
      landscape: 'ipad_pinyin_26_landscape',
      floating: 'pinyin_26_portrait',
    },
  },

  // 临时中文 26 键（英文键盘上划切回）
  temp_pinyin: {
    iPhone: {
      portrait: 'temp_pinyin_portrait',
      landscape: 'temp_pinyin_landscape',
    },
  },

  // 英文 26 键
  alphabetic: {
    iPhone: {
      portrait: 'alphabetic_26_portrait',
      landscape: 'alphabetic_26_landscape',
    },
    iPad: {
      portrait: 'ipad_alphabetic_26_portrait',
      landscape: 'ipad_alphabetic_26_landscape',
      floating: 'alphabetic_26_portrait',
    },
  },

  // 数字九宫格
  numeric: {
    iPhone: {
      portrait: 'numeric_9_portrait',
      landscape: 'numeric_9_landscape',
    },
    iPad: {
      portrait: 'ipad_numeric_9_portrait',
      landscape: 'ipad_numeric_9_landscape',
      floating: 'numeric_9_portrait',
    },
  },

  // 符号键盘
  symbolic: {
    iPhone: {
      portrait: 'symbolic_portrait',
      landscape: 'symbolic_landscape',
    },
  },

  // 浮动功能面板
  panel: {
    iPhone: {
      portrait: 'panel_portrait',
      landscape: 'panel_landscape',
    },
  },
};

local Settings = import 'Custom.libsonnet';

// iPhone 键盘实现
local pinyin =
  if Settings.keyboard_layout == 9 then import 'keyboards/pinyin9/iPhone.libsonnet'
  else import 'keyboards/pinyin26/iPhone.libsonnet';
local temp_pinyin = import 'keyboards/tempPinyin/iPhone.libsonnet';
local alphabetic = import 'keyboards/alphabetic26/iPhone.libsonnet';
local numeric = import 'keyboards/numeric9/iPhone.libsonnet';
local symbolic = import 'keyboards/symbolic/iPhone.libsonnet';
local panel = import 'keyboards/float/panel.libsonnet';

// iPad 键盘实现（在 iPhone 实现上叠加平板尺寸覆写）
local ipad_pinyin = import 'keyboards/pinyin26/iPad.libsonnet';
local ipad_alphabetic = import 'keyboards/alphabetic26/iPad.libsonnet';
local ipad_numeric = import 'keyboards/numeric9/iPad.libsonnet';

// 每个键盘都要出 light/dark × 竖屏/横屏 四份
local themes = ['light', 'dark'];
local orientations = ['portrait', 'landscape'];

local render(module, prefix) = {
  [theme + '/' + prefix + '_' + orientation + '.yaml']: std.toString(module.new(theme, orientation))
  for theme in themes
  for orientation in orientations
};

{
  'config.yaml': std.manifestYamlDoc(config, indent_array_in_object=true, quote_keys=false),
} +
render(pinyin, 'pinyin_26') +
render(temp_pinyin, 'temp_pinyin') +
render(alphabetic, 'alphabetic_26') +
render(numeric, 'numeric_9') +
render(symbolic, 'symbolic') +
render(panel, 'panel') +
render(ipad_pinyin, 'ipad_pinyin_26') +
render(ipad_alphabetic, 'ipad_alphabetic_26') +
render(ipad_numeric, 'ipad_numeric_9')
