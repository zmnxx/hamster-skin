// 26 键的批量生成辅助：短按气泡样式、字母按键对象、反斜杠通知。
{
  // 单个键的短按气泡样式。前景 <key>ButtonHintForegroundStyle 与
  // 上 / 下划气泡前景由 swipeKeyStyles 生成，所以这里的 enableSwipeUp /
  // enableSwipeDown 必须与该键盘实际有的划动方向一致，否则引用不存在的样式名。
  hintStyle(key, backgroundStyle='alphabeticHintBackgroundStyle', enableSwipeUp=true, enableSwipeDown=true, styleName='ButtonHintStyle'):: {
    [key + styleName]: {
      backgroundStyle: backgroundStyle,
      foregroundStyle: key + 'ButtonHintForegroundStyle',
      [if enableSwipeUp then 'swipeUpForegroundStyle']: key + 'ButtonSwipeUpHintForegroundStyle',
      [if enableSwipeDown then 'swipeDownForegroundStyle']: key + 'ButtonSwipeDownHintForegroundStyle',
    },
  },

  hintStyles(keys, backgroundStyle='alphabeticHintBackgroundStyle', enableSwipeUp=true, enableSwipeDown=true, styleName='ButtonHintStyle')::
    std.foldl(
      function(acc, key) acc + self.hintStyle(key, backgroundStyle, enableSwipeUp, enableSwipeDown, styleName),
      keys,
      {}
    ),

  letterButtons(specs, createButton, root):: {
    [spec.key + 'Button']: createButton(
      spec.key,
      spec.size,
      spec.bounds,
      root,
      if std.objectHas(spec, 'isUpper') then spec.isUpper else true
    )
    for spec in specs
  },

  backslashNotifications(specs, createBackslashNotification):: {
    [spec.key + 'ButtonBackslashNotification']: createBackslashNotification(
      spec.key,
      if std.objectHas(spec, 'bounds') then spec.bounds else {}
    )
    for spec in specs
  },
}
