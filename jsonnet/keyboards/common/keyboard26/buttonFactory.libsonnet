// 定义 26 键共享按钮工厂，统一前景样式与滑动动作接线。
local keycap = import '../../../shared/styles/keycap.libsonnet';
local swipeKeyStyles = import '../../../shared/styles/swipeKeyStyles.libsonnet';

{
  // options.hintStyleKeys：哪些键有短按气泡样式（由 keyHelpers.hintStyles 生成，
  // 只覆盖字母键）。不在列表里的键不写 hintStyle —— 写了也是悬空引用，
  // 元书查不到样式名时静默跳过，问题不会报错。
  create(context, swipeUp, swipeDown, options):: (
    local swipeUpForeground =
      if std.objectHas(options, 'foregroundSwipeUp') then options.foregroundSwipeUp else swipeUp;
    local swipeDownForeground =
      if std.objectHas(options, 'foregroundSwipeDown') then options.foregroundSwipeDown else swipeDown;
    local hintStyleKeys =
      if std.objectHas(options, 'hintStyleKeys') then options.hintStyleKeys else null;
    local hasHintStyle(key) =
      hintStyleKeys == null || std.member(hintStyleKeys, key);
    local buildForegroundNames(key, isUpper) =
      std.filter(
        function(x) x != null,
        [
          key + if isUpper then 'ButtonUppercasedStateForegroundStyle' else 'ButtonForegroundStyle',
          if context.Settings.show_swipe && swipeKeyStyles.hasForeground(swipeUpForeground, key) then key + 'ButtonUpForegroundStyle' else null,
          if context.Settings.show_swipe && swipeKeyStyles.hasForeground(swipeDownForeground, key) then key + 'ButtonDownForegroundStyle' else null,
        ]
      );
    function(key, size, bounds, root, isUpper=true)
      local notification =
        if std.objectHas(options, 'notificationFactory') then options.notificationFactory(key) else null;
      {
        size: size,
        [if bounds != {} then 'bounds']: bounds,
        backgroundStyle: 'alphabeticBackgroundStyle',
        foregroundStyle: buildForegroundNames(key, false),
        [if isUpper then 'uppercasedStateForegroundStyle']: buildForegroundNames(key, true),
        [if isUpper then 'capsLockedStateForegroundStyle']: self.uppercasedStateForegroundStyle,
        [if hasHintStyle(key) then 'hintStyle']: key + 'ButtonHintStyle',
        action: options.actionFactory(key),
        [if std.length(key) == 1 then 'uppercasedStateAction']: options.uppercasedActionFactory(key),
        [if std.objectHas(swipeUp, key) then 'swipeUpAction']: swipeUp[key].action,
        [if std.objectHas(swipeDown, key) then 'swipeDownAction']: swipeDown[key].action,
        [if std.objectHas(root, key + 'ButtonHintSymbolsStyle') then 'hintSymbolsStyle']: key + 'ButtonHintSymbolsStyle',
        animation: keycap.animationNames(context.Settings),
        [if notification != null then 'notification']: notification,
      }
  ),
}
