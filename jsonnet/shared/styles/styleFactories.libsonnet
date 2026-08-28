// 提供文本、系统图标与数字键前景样式的复用工厂。
{
  // 生成通用 geometry 样式，供按键背景、面板背景和气泡背景复用。
  makeGeometryStyle(normalColor, extra={}):: {
    buttonStyleType: 'geometry',
    normalColor: normalColor,
  } + extra,

  makeTextStyle(text, fontSize, normalColor, highlightColor, center, fontWeight=null):: {
    buttonStyleType: 'text',
    text: text,
    fontSize: fontSize,
    normalColor: normalColor,
    highlightColor: highlightColor,
    [if fontWeight != null then 'fontWeight']: fontWeight,
    [if center != {} then 'center']: center,
  },

  makeSystemImageStyle(systemImageName, fontSize, normalColor, highlightColor, center):: {
    buttonStyleType: 'systemImage',
    systemImageName: systemImageName,
    fontSize: fontSize,
    normalColor: normalColor,
    highlightColor: highlightColor,
    [if center != {} then 'center']: center,
  },

  genTextStates(keyMap, textMap, suffix, fontSizeValue, normalColor, highlightColor, centerValue, fontWeight=null):: {
    [keyName + suffix]: $.makeTextStyle(
      textMap[keyName],
      fontSizeValue,
      normalColor,
      highlightColor,
      centerValue,
      fontWeight
    )
    for keyName in std.objectFields(keyMap)
  },

  genNumberStates(prefix, suffix, values, fontSizeValue, normalColor, highlightColor, centerValue):: {
    [prefix + std.toString(num) + suffix]: {
      buttonStyleType: 'text',
      text: values[std.toString(num)],
      normalColor: normalColor,
      highlightColor: highlightColor,
      fontSize: fontSizeValue,
      center: centerValue,
    }
    for num in std.range(0, 9)
  },
}
