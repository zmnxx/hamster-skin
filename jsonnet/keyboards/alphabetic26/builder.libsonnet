// 组装英文 26 键键盘，汇合共享上下文、布局数据和系统键模块。
local center = import '../../shared/styles/center.libsonnet';
local color = import '../../shared/styles/color.libsonnet';
local fontSize = import '../../shared/styles/fontSize.libsonnet';
local keyboard26ButtonFactory = import '../common/keyboard26/buttonFactory.libsonnet';
local hintSymbolsData = import '../../shared/data/hintSymbolsData.libsonnet';
local hintSymbolsStyles = import '../../shared/styles/hintSymbolsStyles.libsonnet';
local keyHelpers = import '../../shared/buttonHelpers/key.libsonnet';
local letter26KeysSpecs = import '../common/keyboard26/letters.libsonnet';
local others = import '../../shared/styles/others.libsonnet';
local slideButtonStyles = import '../../shared/styles/slideButtonStyles.libsonnet';
local swipeData = import '../../shared/data/swipeDataEn.libsonnet';
local swipeKeyStyles = import '../../shared/styles/swipeKeyStyles.libsonnet';
local toolbar = import '../../shared/toolbar/iPhone.libsonnet';
local utils = import '../../shared/styles/keyStyles.libsonnet';
local functions = import '../../shared/functionButtons/iPhone.libsonnet';
local systemKeysAlphabetic26 = import 'systemKeys.libsonnet';
local functionButtonStyles = import '../../shared/functionButtons/styles.libsonnet';
local toolbarOverrides = {
  switchKeyboardType: 'pinyin',
  switchKeyboardAsset: 'englishState',
};

{
  createButtonFactory(context, swipeUp, swipeDown, letters)::
    keyboard26ButtonFactory.create(context, swipeUp, swipeDown, {
      // 英文键盘一律用 symbol（直接上屏，不进 RIME）。
      // 原先这里按 others 里一个从未存在的 '英文键盘方案' 键在 character /
      // symbol 之间二选一，条件恒假，等于写死 symbol。
      actionFactory(key): { symbol: key },
      uppercasedActionFactory(key): { symbol: std.asciiUpper(key) },
      // 短按气泡只为字母键生成（见下面的 keyHelpers.hintStyles）。
      hintStyleKeys: letters,
    }),

  build(context, keyboardLayout)::
    local theme = context.theme;
    local orientation = context.orientation;
    local swipeDataRoot = swipeData.genSwipeenData(context.deviceType);
    local swipeUp = if std.objectHas(swipeDataRoot, 'swipe_up') then swipeDataRoot.swipe_up else {};
    local swipeDown = if std.objectHas(swipeDataRoot, 'swipe_down') then swipeDataRoot.swipe_down else {};
    local hintStyles = hintSymbolsStyles.getStyle(theme, hintSymbolsData.alphabetic);
    local letterSpecs = letter26KeysSpecs.get26KeySpecs(orientation, keyboardLayout);
    local letterKeys = [spec.key for spec in letterSpecs];
    local createButton = self.createButtonFactory(context, swipeUp, swipeDown, letterKeys);
    keyboardLayout[if orientation == 'portrait' then '竖屏英文26键' else '横屏英文26键'] +
    swipeKeyStyles.getStyle('en', theme, swipeUp, swipeDown) +
    hintStyles +
    toolbar.getToolBar(theme, toolbarOverrides) +
    utils.genAlphabeticStyles(fontSize, color, theme, center) +
    functionButtonStyles.genFuncKeyStyles(fontSize, color, theme, center) +
    slideButtonStyles.slideButtonStyles(theme) +
    functions.makeFunctionButtons(orientation, keyboardLayout, 'alphabetic') +
    {
      preeditHeight: others[if orientation == 'portrait' then '竖屏' else '横屏']['preedit高度'],
      toolbarHeight: others[if orientation == 'portrait' then '竖屏' else '横屏']['toolbar高度'],
      // 英文 26 键专用：在共享高度上加一点余量，为以后重新加入下划角标显示留空间。
      // 只抬英文键盘，九键 / 数字 / 中文 26 键保持原高，避免切键盘时忽高忽低。
      keyboardHeight: others[if orientation == 'portrait' then '竖屏' else '横屏']['keyboard高度']
                      + (if orientation == 'portrait' then 22 else 14),
    } +
    keyHelpers.letterButtons(letterSpecs, createButton, hintStyles) +
    keyHelpers.hintStyles(letterKeys, 'alphabeticHintBackgroundStyle', true, false) +
    systemKeysAlphabetic26.build(theme, orientation, keyboardLayout, context.Settings, createButton, hintStyles),
}
