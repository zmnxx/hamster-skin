// 26 键与九键共用的基础按键样式注册。
//
// 这里只做「注册」：把键帽模块生成的样式挂到键盘根节点上，
// 具体长什么样由 shared/styles/keycap.libsonnet 决定。
local keycap = import 'keycap.libsonnet';

{
  // keyClass='k26'：26 键键位窄，用 keycap_config.insets26 的紧凑间隙
  baseStyles(theme, orientation, Settings, color, animation, hintSymbolsStyles)::
    {
      alphabeticBackgroundStyle: keycap.buttonBackground(theme, orientation, Settings, color, '字母键背景颜色-普通', '字母键背景颜色-高亮', {}, 'k26'),
      systemButtonBackgroundStyle: keycap.buttonBackground(theme, orientation, Settings, color, '功能键背景颜色-普通', '功能键背景颜色-高亮', {}, 'k26'),
      enterButtonBlueBackgroundStyle: keycap.buttonBackground(theme, orientation, Settings, color, 'enter键背景(蓝色)', '功能键背景颜色-高亮', {}, 'k26'),
      alphabeticHintBackgroundStyle: keycap.hintBackground(theme, Settings, color),
      alphabeticHintSymbolsBackgroundStyle: keycap.longPressPanelBackground(theme, Settings, hintSymbolsStyles['长按背景样式']),
      alphabeticHintSymbolsSelectedStyle: keycap.longPressPanelSelected(theme, Settings, color, hintSymbolsStyles['长按选中背景样式']),
      // 功能行专用背景：所有键盘共用同一套间距，切键盘时键帽大小不变
      functionRowButtonBackgroundStyle: keycap.buttonBackground(theme, orientation, Settings, color, '字母键背景颜色-普通', '字母键背景颜色-高亮', {}, 'func'),
    } + keycap.animationRegistry(Settings, animation),
}
