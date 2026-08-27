// 定义数字键盘（123）的布局。
//
// 横竖屏结构完全相同：功能行（8 键整条）+ 主体三列。
//   左列  符号栏 collection + 左下角切换键
//   中列  数字 3×3 + 底行（切换键 / 0 / 空格）
//   右列  退格 / 句号 / 等号 / 回车
// 横屏原本是「左半符号区 + 中间空档 + 右半数字盘」的分栏布局，与竖屏两套观感，
// 现已统一。
local Settings = import '../../Custom.libsonnet';
local functionRowPatch = import '../../shared/functionButtons/functionRowPatch.libsonnet';

// 左下角与底行第一个键可互换（Custom 的 swap_numeric_return_symbol）。
local numericBottomSlots =
  if Settings.swap_numeric_return_symbol then {
    left: 'symbolButton',
    right: 'returnButton',
  } else {
    left: 'returnButton',
    right: 'symbolButton',
  };

local showFunctions = Settings.function_button_config.with_functions_row.iPhone;

// 主体：左列 + 中列 + 右列
local content = {
  HStack: {
    style: 'keyboardStyle',
    subviews: [
      {
        VStack: {
          style: 'VStackStyle1',
          subviews: [
            { Cell: 'collection' },
            { Cell: numericBottomSlots.left },
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
                  { Cell: numericBottomSlots.right },
                  { Cell: 'number0Button' },
                  { Cell: 'spaceButton' },
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
            { Cell: 'spaceRightButton' },
            { Cell: 'atButton' },
            { Cell: 'enterButton' },
          ],
        },
      },
    ],
  },
};

{
  functionRowOrderedKeys:: functionRowPatch.functionRowOrderedKeys,

  // 横竖屏共用同一份布局（元书按朝向分别加载 numeric_9_portrait /
  // numeric_9_landscape，两份内容一致）。
  Layout:: (if showFunctions then [
              functionRowPatch.standardFunctionRow(functionRowPatch.functionRowOrderedKeys),
            ] else []) + [content],
}
