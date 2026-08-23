// 在共享基础布局上叠加功能行补丁。
local Settings = import '../../Custom.libsonnet';
local functionButtonSpecs = import '../functionButtons/specs.libsonnet';

{
  functionRowOrderedKeys:: functionButtonSpecs.resolveOrderedKeys(Settings),

  cell(name):: { Cell: name + 'Button' },

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

  splitFunctionRow(orderedKeys):: (
    local splitIndex = std.ceil(std.length(orderedKeys) / 2);
    local leftKeys = std.slice(orderedKeys, 0, splitIndex, 1);
    local rightKeys = std.slice(orderedKeys, splitIndex, std.length(orderedKeys), 1);
    {
      HStack: {
        style: 'rowofFunctionStyle',
        subviews: [
          {
            VStack: {
              style: 'columnStyle1',
              subviews: [
                {
                  HStack: {
                    subviews: [$.functionCell(key, std.length(leftKeys)) for key in leftKeys],
                  },
                },
              ],
            },
          },
          {
            VStack: {
              style: 'columnStyle2',
            },
          },
          {
            VStack: {
              style: 'columnStyle3',
              subviews: [
                {
                  HStack: {
                    subviews: [$.functionCell(key, std.length(rightKeys)) for key in rightKeys],
                  },
                },
              ],
            },
          },
        ],
      },
    }
  ),

  standardLayoutPatch(layoutDef):: {
    [if std.objectHas(layoutDef, '竖屏按键尺寸') then '竖屏按键尺寸']: layoutDef['竖屏按键尺寸'],
    keyboardLayout: [$.standardFunctionRow($.functionRowOrderedKeys)] + layoutDef.keyboardLayout,
    rowofFunctionStyle: $.rowofFunctionStyle,
    keyboardStyle: layoutDef.keyboardStyle,
    keyboardBackgroundStyle: layoutDef.keyboardBackgroundStyle,
    [if std.objectHas(layoutDef, 'VStackStyle1') then 'VStackStyle1']: layoutDef.VStackStyle1,
    [if std.objectHas(layoutDef, 'CenterStackStyle') then 'CenterStackStyle']: layoutDef.CenterStackStyle,
    [if std.objectHas(layoutDef, 'HStackStyle1') then 'HStackStyle1']: layoutDef.HStackStyle1,
    [if std.objectHas(layoutDef, 'HStackStyle2') then 'HStackStyle2']: layoutDef.HStackStyle2,
  },

  splitLayoutPatch(layoutDef):: {
    keyboardLayout: [$.splitFunctionRow($.functionRowOrderedKeys)] + layoutDef.keyboardLayout,
    rowofFunctionStyle: $.rowofFunctionStyle,
    keyboardStyle: layoutDef.keyboardStyle,
    keyboardBackgroundStyle: layoutDef.keyboardBackgroundStyle,
    columnStyle1: layoutDef.columnStyle1,
    columnStyle2: layoutDef.columnStyle2,
    columnStyle3: layoutDef.columnStyle3,
  },

  getPatch(theme, baseLayout):: {
    '竖屏中文9键': $.standardLayoutPatch(baseLayout['竖屏中文9键']),
    '竖屏中文26键': $.standardLayoutPatch(baseLayout['竖屏中文26键']),
    'ipad中文26键': $.standardLayoutPatch(baseLayout['ipad中文26键']),
    '竖屏英文26键': $.standardLayoutPatch(baseLayout['竖屏英文26键']),
    'ipad英文26键': $.standardLayoutPatch(baseLayout['ipad英文26键']),
    '横屏中文26键': $.splitLayoutPatch(baseLayout['横屏中文26键']),
    '横屏英文26键': $.splitLayoutPatch(baseLayout['横屏英文26键']),
  },
}
