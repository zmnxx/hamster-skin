// 生成功能按键专用前景样式，并内聚功能按键自己的文字映射。
local styleFactories = import '../styles/styleFactories.libsonnet';

// genTextStates 用它当键列表（键名 → 样式名前缀），值与键相同。
local funcKeys = {
  left: 'left',
  head: 'head',
  select: 'select',
  cut: 'cut',
  copy: 'copy',
  paste: 'paste',
  tail: 'tail',
  right: 'right',
};

// 非打字状态的键面文字。大写状态沿用同一份（功能键无大小写之分）。
local normalTextMap = {
  left: '左移',
  head: '行首',
  select: '全选',
  cut: '剪切',
  copy: '复制',
  paste: '粘贴',
  tail: '行尾',
  right: '右移',
};

// 打字状态（preeditChanged 通知命中）的键面文字。
local preeditTextMap = {
  left: '⇠',
  head: '⇅',
  // 九键打字态：次选 / 三选上屏，词首 / 词尾为以词定字。
  select: '次选',
  cut: '三选',
  copy: '词首',
  paste: '词尾',
  // 打字时 tail 是候选栏展开 / 收起开关；非打字状态仍是「行尾」。
  tail: '候选',
  right: '⇢',
};

{
  genFuncKeyStyles(fontSize, color, theme, center)::
    // 字重与工具栏统一为 medium，否则上下两排看起来像两套字。
    // 字号 / 偏移已在 fontSize / center 层与工具栏对齐。
    local make(textMap, suffix) = styleFactories.genTextStates(
      funcKeys,
      textMap,
      suffix,
      fontSize['功能按键sf符号大小'],
      color[theme]['按键前景颜色'],
      color[theme]['按键前景颜色'],
      center['功能键前景文字偏移'],
      'medium'
    );
    make(normalTextMap, 'ButtonForegroundStyle') +
    make(preeditTextMap, 'ButtonPreeditForegroundStyle') +
    make(normalTextMap, 'ButtonUppercasedStateForegroundStyle'),
}
