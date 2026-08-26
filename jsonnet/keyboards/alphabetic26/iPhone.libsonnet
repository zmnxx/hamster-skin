// 暴露英文 26 键入口，衔接共享上下文与构建模块。
local Settings = import '../../Custom.libsonnet';
local keyboardRuntime = import '../../keyboards/common/layoutAssembly/keyboardLayoutAssembly.libsonnet';
local keyboard26AlphabeticBuilder = import 'builder.libsonnet';
local swipeData = import '../../shared/data/swipeDataEn.libsonnet';

local defaultContext = keyboardRuntime.new(Settings, 'light', 'portrait', 'iPhone');
local defaultSwipeDataRoot = swipeData.genSwipeenData(defaultContext.deviceType);
local defaultSwipeUp = if std.objectHas(defaultSwipeDataRoot, 'swipe_up') then defaultSwipeDataRoot.swipe_up else {};
local defaultSwipeDown = if std.objectHas(defaultSwipeDataRoot, 'swipe_down') then defaultSwipeDataRoot.swipe_down else {};
// iPad 覆写层生成的键都是功能键（不在字母表里），传空列表即不写 hintStyle。
local defaultLetterKeys = [];

local build(theme, orientation, keyboardLayout=null) =
  local context = keyboardRuntime.new(Settings, theme, orientation, 'iPhone');
  local resolvedKeyboardLayout = if keyboardLayout == null then keyboardRuntime.getKeyboardLayout(context) else keyboardLayout;
  keyboard26AlphabeticBuilder.build(context, resolvedKeyboardLayout);

{
  // createButton 供 iPad 覆写层复用（iPadBuilder 只拿它生成几个平板专属按键，
  // 传的 context 是 light / portrait 的占位值，样式名与主题无关）。
  createButton: keyboard26AlphabeticBuilder.createButtonFactory(
    defaultContext,
    defaultSwipeUp,
    defaultSwipeDown,
    defaultLetterKeys
  ),
  keyboard(theme, orientation, keyboardLayout):
    build(theme, orientation, keyboardLayout),
  new(theme, orientation):
    build(theme, orientation),
}
