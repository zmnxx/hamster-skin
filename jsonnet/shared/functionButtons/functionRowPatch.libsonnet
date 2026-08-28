// 在共享基础布局上叠加功能行补丁。
//
// 功能行是 8 个键（左移 / 行首 / 全选 / 剪切 / 复制 / 粘贴 / 行尾 / 右移）
// 平铺成一整条，横竖屏、九键 / 26 键、中英文一律相同 —— 横屏原本把它拆成
// 左 4 + 右 4 分列两侧，与竖屏观感割裂，已统一为整条。
local Settings = import '../../Custom.libsonnet';
local functionButtonSpecs = import '../functionButtons/specs.libsonnet';

{
  functionRowOrderedKeys:: functionButtonSpecs.resolveOrderedKeys(Settings),

  functionCellWidth(count):: {
    width: {
      percentage: 1 / count,
    },
  },

  functionCell(name, count):: {
    Cell: name + 'Button',
    size: $.functionCellWidth(count),
  },

  rowofFunctionStyle:: {
    size: {
      height: { percentage: 0.17 },
    },
    backgroundStyle: 'keyboardBackgroundStyle',
  },

  standardFunctionRow(orderedKeys):: {
    HStack: {
      style: 'rowofFunctionStyle',
      subviews: [$.functionCell(key, std.length(orderedKeys)) for key in orderedKeys],
    },
  },

  // 在某个键盘布局前面插入功能行。
  // 尺寸块与各列样式按需透传：不同键盘声明的样式名不一样，
  // 缺哪个就不写哪个（写了不存在的字段编译会报错）。
  standardLayoutPatch(layoutDef):: {
    [if std.objectHas(layoutDef, '竖屏按键尺寸') then '竖屏按键尺寸']: layoutDef['竖屏按键尺寸'],
    [if std.objectHas(layoutDef, '横屏按键尺寸') then '横屏按键尺寸']: layoutDef['横屏按键尺寸'],
    keyboardLayout: [$.standardFunctionRow($.functionRowOrderedKeys)] + layoutDef.keyboardLayout,
    rowofFunctionStyle: $.rowofFunctionStyle,
    keyboardStyle: layoutDef.keyboardStyle,
    keyboardBackgroundStyle: layoutDef.keyboardBackgroundStyle,
    [if std.objectHas(layoutDef, 'VStackStyle1') then 'VStackStyle1']: layoutDef.VStackStyle1,
    [if std.objectHas(layoutDef, 'CenterStackStyle') then 'CenterStackStyle']: layoutDef.CenterStackStyle,
    [if std.objectHas(layoutDef, 'HStackStyle1') then 'HStackStyle1']: layoutDef.HStackStyle1,
    [if std.objectHas(layoutDef, 'HStackStyle2') then 'HStackStyle2']: layoutDef.HStackStyle2,
  },

  getPatch(theme, baseLayout):: {
    '竖屏中文9键': $.standardLayoutPatch(baseLayout['竖屏中文9键']),
    '横屏中文9键': $.standardLayoutPatch(baseLayout['横屏中文9键']),
    '竖屏中文26键': $.standardLayoutPatch(baseLayout['竖屏中文26键']),
    '横屏中文26键': $.standardLayoutPatch(baseLayout['横屏中文26键']),
    'ipad中文26键': $.standardLayoutPatch(baseLayout['ipad中文26键']),
    '竖屏英文26键': $.standardLayoutPatch(baseLayout['竖屏英文26键']),
    '横屏英文26键': $.standardLayoutPatch(baseLayout['横屏英文26键']),
    'ipad英文26键': $.standardLayoutPatch(baseLayout['ipad英文26键']),
  },
}
