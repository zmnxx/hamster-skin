// 定义滑动切换按钮的共享前景样式。
local color = import 'color.libsonnet';
local fontSize = import 'fontSize.libsonnet';

local makeSlideTextForegroundStyle(theme, textValue) = {
  buttonStyleType: 'text',
  text: textValue,
  normalColor: color[theme]['按键前景颜色'],
  highlightColor: color[theme]['按键前景颜色'],
  fontSize: fontSize['按键前景文字大小'] - 3,
  fontWeight: 'medium',
};

local slideButtonStyles(theme) =
  {
    // 数字键盘入口
    numericStyle: { foregroundStyle: '123ButtonForegroundStyle' },
    '123ButtonForegroundStyle': makeSlideTextForegroundStyle(theme, '123'),

    // 符号键盘入口
    symbolicStyle: { foregroundStyle: 'symbolicButtonForegroundStyle' },
    symbolicButtonForegroundStyle: makeSlideTextForegroundStyle(theme, '符号'),

    // Emoji 键盘入口
    emojisStyle: { foregroundStyle: 'emojisButtonForegroundStyle' },
    emojisButtonForegroundStyle: makeSlideTextForegroundStyle(theme, '表情'),
  };

{
  slideButtonStyles(theme): slideButtonStyles(theme),
}
