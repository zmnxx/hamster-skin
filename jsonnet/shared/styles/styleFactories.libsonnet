// 提供文本、系统图标与数字键前景样式的复用工厂。
{
  // 生成通用 geometry 样式，供按键背景、面板背景和气泡背景复用。
  makeGeometryStyle(normalColor, extra={}):: {
    buttonStyleType: 'geometry',
    normalColor: normalColor,
  } + extra,

  // 生成整片贴图背景（区域背景用）。
  //
  // fileImage 的 normalImage 与 highlightImage 是分开读的，只写 normalImage
  // 时按下态会画空白 —— 区域背景没有按下态，但仍要两个都写，否则某些交互
  // 状态下整片背景会闪掉。
  //
  // contentMode 不写：fileImage 默认 scaleToFill，正好把图拉满整个区域，
  // 这里的图是模糊渐变，拉伸无损观感。（另两种 buttonStyleType 默认 center，
  // 只有 fileImage 是 scaleToFill，别记反。）
  makeFileImageStyle(file, image='IMG1', extra={}):: {
    buttonStyleType: 'fileImage',
    normalImage: { file: file, image: image },
    highlightImage: { file: file, image: image },
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
