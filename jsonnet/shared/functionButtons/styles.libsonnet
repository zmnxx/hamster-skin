// 生成功能按键专用前景样式，并内聚功能按键自己的文字映射。
local Settings = import '../../Custom.libsonnet';
local styleFactories = import '../styles/styleFactories.libsonnet';

{
  funcKeyMap: {
    left: 'left',
    head: 'head',
    select: 'select',
    cut: 'cut',
    copy: 'copy',
    paste: 'paste',
    tail: 'tail',
    right: 'right',
  },

  // 普通状态文字映射
  funcKeyTextMap(Settings): {
    left: '左移',
    head: '行首',
    select: '全选',
    cut: '剪切',
    copy: '复制',
    paste: '粘贴',
    tail: '行尾',
    right: '右移',
  },

  // 预编辑状态文字映射（数字提示）
  funcKeyPreeditTextMap(Settings): {
    left: '⇠',
    head: '⇅',
    select: '1',
    cut: '2',
    copy: '3',
    paste: '4',
    // 打字时 tail 变为候选栏展开/收起开关，故显示「候选」。
    // 非打字状态仍是「行尾」，见 funcKeyTextMap。
    tail: '候选',
    right: '⇢',
  },

  // 大写状态文字映射（同普通状态）
  funcKeyUppercasedTextMap(Settings): {
    left: '左移',
    head: '行首',
    select: '全选',
    cut: '剪切',
    copy: '复制',
    paste: '粘贴',
    tail: '行尾',
    right: '右移',
  },

  genFuncKeyStyles(fontSize, color, theme, center)::
    local funcKeyMap = self.funcKeyMap;
    local funcKeyTextMap = self.funcKeyTextMap(Settings);
    local funcKeyPreeditTextMap = self.funcKeyPreeditTextMap(Settings);
    local funcKeyUppercasedTextMap = self.funcKeyUppercasedTextMap(Settings);
    styleFactories.genTextStates(
      funcKeyMap,
      funcKeyTextMap,
      'ButtonForegroundStyle',
      fontSize['功能按键sf符号大小'],
      color[theme]['按键前景颜色'],
      color[theme]['按键前景颜色'],
      center['功能键前景文字偏移']
    ) + styleFactories.genTextStates(
      funcKeyMap,
      funcKeyPreeditTextMap,
      'ButtonPreeditForegroundStyle',
      fontSize['功能按键sf符号大小'],
      color[theme]['按键前景颜色'],
      color[theme]['按键前景颜色'],
      center['功能键前景文字偏移']
    ) + styleFactories.genTextStates(
      funcKeyMap,
      funcKeyUppercasedTextMap,
      'ButtonUppercasedStateForegroundStyle',
      fontSize['功能按键sf符号大小'],
      color[theme]['按键前景颜色'],
      color[theme]['按键前景颜色'],
      center['功能键前景文字偏移']
    ),
}
