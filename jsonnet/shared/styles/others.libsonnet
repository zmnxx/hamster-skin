// 键盘三个区域的高度（单位：pt）。
//
// 元书把键盘分成三段，各自独立设高：
//   preedit高度   —— 拼音串显示区（开启内嵌输入时不渲染）
//   toolbar高度   —— 工具栏 / 候选栏
//   keyboard高度  —— 按键区
//
// 想整体调高/调矮键盘，改 'keyboard高度' 即可。
local Settings = import '../../Custom.libsonnet';

{
  '竖屏': {
    'preedit高度': 15,
    'toolbar高度': Settings.toolbar_config.toolbar_height,
    'keyboard高度': 240,
  },
  '横屏': {
    'preedit高度': 15,
    'toolbar高度': Settings.toolbar_config.toolbar_height,
    'keyboard高度': 205,
  },
}
