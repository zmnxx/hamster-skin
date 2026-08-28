// 组装手机端功能行按钮（左移 / 行首 / 全选 / 剪切 / 复制 / 粘贴 / 行尾 / 右移）。
//
// 每个键出两个对象：<key>Button 是非打字状态，<key>ButtonPreeditNotification 是
// 打字状态。两套动作都来自 specs.libsonnet。
local Settings = import '../../Custom.libsonnet';
local specs = import 'specs.libsonnet';

local resolvedOrderedKeys = specs.resolveOrderedKeys(Settings);

// 功能行统一用 functionRowButtonBackgroundStyle：8 键平铺全宽，单元格约 48pt，
// 与 26 键（38pt）、九键（76pt）都不同，需要独立一套间距，否则切键盘时
// 功能行键帽会忽大忽小。
local functionRowBackground = 'functionRowButtonBackgroundStyle';

// 功能键没有上 / 下划（26 键的 swipeData 里也不含这些键名），
// 所以不接 swipe* 前景与动作。
local createFunctionButton(key, size, isNotification) = {
  size: size,
  backgroundStyle: functionRowBackground,
  foregroundStyle: [key + 'ButtonForegroundStyle'],
  uppercasedStateForegroundStyle: [key + 'ButtonUppercasedStateForegroundStyle'],
  capsLockedStateForegroundStyle: self.uppercasedStateForegroundStyle,
  [if std.objectHas(specs.actionMap, key) then 'action']: specs.actionMap[key].action,
  [if std.objectHas(specs.repeatMap, key) then 'repeatAction']: specs.repeatMap[key].action,
  animation: ['ButtonScaleAnimation'],
  [if isNotification then 'notification']: [key + 'ButtonPreeditNotification'],
};

local createNotification(key, actionMap) = {
  notificationType: 'preeditChanged',
  backgroundStyle: functionRowBackground,
  foregroundStyle: key + 'ButtonPreeditForegroundStyle',
  [if std.objectHas(actionMap, key) then 'action']: actionMap[key].action,
  [if std.objectHas(specs.notificationSwipeUpMap, key) then 'swipeUpAction']:
    specs.notificationSwipeUpMap[key].action,
  [if std.objectHas(specs.notificationSwipeDownMap, key) then 'swipeDownAction']:
    specs.notificationSwipeDownMap[key].action,
  [if std.objectHas(specs.notificationRepeatMap, key) then 'repeatAction']:
    specs.notificationRepeatMap[key].action,
};

{
  // 宽度由 layout 层按当前按钮数量动态分配，这里只传高度。
  makeFunctionButtons(orientation, keyboardLayout, keyboard_type)::
    local sizeBlockName = if orientation == 'portrait' then '竖屏按键尺寸' else '横屏按键尺寸';
    local customSize =
      if std.objectHas(keyboardLayout, sizeBlockName) &&
         std.objectHas(keyboardLayout[sizeBlockName], '自定义键size') then
        keyboardLayout[sizeBlockName]['自定义键size']
      else
        {};
    local size = if std.objectHas(customSize, 'height') then { height: customSize.height } else {};
    local notificationActionMap = specs.resolveNotificationActionMap(keyboard_type);
    std.foldl(
      function(acc, key) acc {
        [key + 'Button']: createFunctionButton(
          key,
          size,
          specs.notificationEnabled(Settings, keyboard_type, key)
        ),
        [key + 'ButtonPreeditNotification']: createNotification(key, notificationActionMap),
      },
      resolvedOrderedKeys,
      {}
    ),
}
