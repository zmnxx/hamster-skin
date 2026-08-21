// 定义滑动切换按钮的共享前景样式。
local Settings = import '../../Custom.libsonnet';
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
    numericStyle: {
      // backgroundStyle: 'systemButtonBackgroundStyle',
      foregroundStyle: '123ButtonForegroundStyle',
    },
  } + {
    // 数字键盘入口
    '123ButtonForegroundStyle': makeSlideTextForegroundStyle(theme, '123'),
  } + {
    symbolicStyle: {
      // backgroundStyle: 'systemButtonBackgroundStyle',
      foregroundStyle: 'symbolicButtonForegroundStyle',
    },
  } + {
    // 符号键盘入口
    symbolicButtonForegroundStyle: makeSlideTextForegroundStyle(theme, '符号'),
  } + {
    emojiStyle: {
      // backgroundStyle: 'systemButtonBackgroundStyle',
      foregroundStyle: 'emojiButtonForegroundStyle',
    },
  } + {
    // Emoji 键盘入口
    emojiButtonForegroundStyle: makeSlideTextForegroundStyle(theme, '表情'),
  } + {
    emojisStyle: {
      // backgroundStyle: 'systemButtonBackgroundStyle',
      foregroundStyle: 'emojisButtonForegroundStyle',
    },
  } + {
    // 次级 Emoji 入口
    emojisButtonForegroundStyle: makeSlideTextForegroundStyle(theme, '表情'),
};

{
  slideButtonStyles(theme): slideButtonStyles(theme),
}
