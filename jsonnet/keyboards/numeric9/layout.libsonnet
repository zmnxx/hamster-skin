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

local showFunctions = Settings.function_button_config.with_functions_row.iPhone;

// 主体：左列 + 中列 + 右列。左下角与底行第一个键由 slots 决定。
local content(slots) = {
  HStack: {
    style: 'keyboardStyle',
    subviews: [
      {
        VStack: {
          style: 'VStackStyle1',
          subviews: [
            { Cell: 'collection' },
            { Cell: slots.left },
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
                  { Cell: slots.right },
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

  // swapped 显式传入时覆盖 Custom 的对调开关：
  //   true  返回键在底行（右手边），符号键在左下角
  //   false 返回键在左下角，符号键在底行
  //   null  沿用 Custom.swap_numeric_return_symbol，且只在 26 键布局下对调
  layout(swapped=null):: (
    local swappedEffective =
      if swapped != null then swapped
      else Settings.swap_numeric_return_symbol && Settings.keyboard_layout != 9;
    local numericBottomSlots =
      if swappedEffective then {
        left: 'symbolButton',
        right: 'returnButton',
      } else {
        left: 'returnButton',
        right: 'symbolButton',
      };
    (if showFunctions then [
       functionRowPatch.standardFunctionRow(functionRowPatch.functionRowOrderedKeys),
     ] else []) + [content(numericBottomSlots)]
  ),

  // 默认布局，保持旧字段名，供直接引用。
  Layout:: self.layout(null),
}
