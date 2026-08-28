// 定义拼音 9 键的横竖屏布局。
//
// 横竖屏结构完全相同：功能行（8 键整条）+ 主体三列。
//   左列  符号栏 collection + 左下角切换键
//   中列  九宫格 3×3 + 底行（切换键 / 空格 / 中英）
//   右列  退格 / 换行 / 回车
// 横屏原本是「左半候选区 + 中间空档 + 右半九宫格」的分栏布局，与竖屏两套观感，
// 现已统一 —— 横屏打字时候选字走工具栏那一条，和竖屏一致。
local Settings = import '../../Custom.libsonnet';
local functionButtonSpecs = import '../../shared/functionButtons/specs.libsonnet';
local functionRowPatch = import '../../shared/functionButtons/functionRowPatch.libsonnet';
local color = import '../../shared/styles/color.libsonnet';
local styleFactories = import '../../shared/styles/styleFactories.libsonnet';

// 左下角与底行第一个键可互换（Custom 的 swap_9_123_symbol）。
local pinyin9bottomRowSlots =
  if Settings.swap_9_123_symbol then {
    left: {
      cell: 'symbolButton',
      sizeKey: { width: { percentage: 1 / 4 } },
    },
    right: {
      cell: '123Button',
      sizeKey: { width: { percentage: 1.5 / 7 } },
    },
  } else {
    left: {
      cell: '123Button',
      sizeKey: { width: { percentage: 1 / 4 } },
    },
    right: {
      cell: 'symbolButton',
      sizeKey: { width: { percentage: 1.5 / 7 } },
    },
  };

local pinyin9FunctionOrderedKeys = functionButtonSpecs.resolveOrderedKeys(Settings);
local pinyin9ShowFunctions = Settings.function_button_config.with_functions_row.iPhone;

// 横竖屏共用一套按键尺寸，键位关系两边完全一致。
local pinyin9KeySizes = {
  [pinyin9bottomRowSlots.left.cell]: pinyin9bottomRowSlots.left.sizeKey,
  [pinyin9bottomRowSlots.right.cell]: pinyin9bottomRowSlots.right.sizeKey,
  spaceButton: { width: { percentage: 4 / 7 } },
  cn2enButton: { width: { percentage: 1.5 / 7 } },
  emojiButton: { width: { percentage: 1 / 4 } },
  // 右侧动作列 3 个键覆盖中间 4 行的高度：三个都写 1/4 只占 3/4，
  // 余量由元书塞给最后一个键 —— 这是刻意留的，回车因此比退格 / 换行高一截。
  backspaceButton: { height: { percentage: 1 / 4 } },
  cleanButton: { height: { percentage: 1 / 4 } },
  enterButton: { height: { percentage: 1 / 4 } },
};

// 主体：左列 + 中列 + 右列
local pinyin9Content = {
  HStack: {
    style: 'keyboardStyle',
    subviews: [
      {
        VStack: {
          style: 'VStackStyle1',
          subviews: [
            { Cell: 'collection' },
            { Cell: pinyin9bottomRowSlots.left.cell },
          ],
        },
      },
      {
        VStack: {
          style: 'CenterStackStyle',
          subviews: [
            {
              HStack: {
                subviews: [
                  { Cell: 'number1Button' },
                  { Cell: 'number2Button' },
                  { Cell: 'number3Button' },
                ],
              },
            },
            {
              HStack: {
                subviews: [
                  { Cell: 'number4Button' },
                  { Cell: 'number5Button' },
                  { Cell: 'number6Button' },
                ],
              },
            },
            {
              HStack: {
                subviews: [
                  { Cell: 'number7Button' },
                  { Cell: 'number8Button' },
                  { Cell: 'number9Button' },
                ],
              },
            },
            {
              HStack: {
                subviews: [
                  { Cell: pinyin9bottomRowSlots.right.cell },
                  { Cell: 'spaceButton' },
                  { Cell: 'cn2enButton' },
                ],
              },
            },
          ],
        },
      },
      {
        VStack: {
          style: 'VStackStyle1',
          subviews: [
            { Cell: 'backspaceButton' },
            { Cell: 'cleanButton' },
            { Cell: 'enterButton' },
          ],
        },
      },
    ],
  },
};

{
  getKeyboardLayout(theme)::
    local makeKeyboardBackgroundStyle() =
      // 生成键盘区域背景。
      styleFactories.makeGeometryStyle(color[theme]['键盘背景颜色']);
    // 横竖屏同一套定义，只有尺寸块的键名不同（元书按朝向取对应的块）。
    local section(sizeBlockName) = {
      [sizeBlockName]: pinyin9KeySizes,
      keyboardLayout:
        (if pinyin9ShowFunctions then [
           functionRowPatch.standardFunctionRow(pinyin9FunctionOrderedKeys),
         ] else []) + [pinyin9Content],
      keyboardStyle: {
        size: {
          // 按键区占 73%，余下让给系统在键盘底部占用的那条区域
          // （地球 / 麦克风所在的一行）。
          height: { percentage: 0.73 },
        },
        insets: {
          top: 3,
          bottom: 3,
          left: 4,
          right: 4,
        },
        backgroundStyle: 'keyboardBackgroundStyle',
      },
      keyboardBackgroundStyle: makeKeyboardBackgroundStyle(),
      [if pinyin9ShowFunctions then 'rowofFunctionStyle']: functionRowPatch.rowofFunctionStyle,
      // 左右两列同宽，中列吃掉剩下的：29/183 × 2 + 375/549 = 1
      VStackStyle1: {
        size: {
          width: '29/183',
        },
      },
      CenterStackStyle: {
        size: {
          width: '375/549',
        },
      },
    };
    {
      '竖屏中文9键': section('竖屏按键尺寸'),
      '横屏中文9键': section('横屏按键尺寸'),
    },
}
