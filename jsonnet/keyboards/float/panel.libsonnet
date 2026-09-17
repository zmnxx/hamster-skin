// 浮动功能面板（工具栏「菜单」键唤出的键盘菜单）。
//
// 布局固定 3 行 × 4 列，共 12 个等宽等高按键，每键「图标在上、文字在下」。
// 面板底与按键材质由 keycap.libsonnet 统一提供（panelKeyboardBackground /
// panelButtonBackground），与键盘上的键帽同一套语言。
local Settings = import '../../Custom.libsonnet';
local center = import '../../shared/styles/center.libsonnet';
local color = import '../../shared/styles/color.libsonnet';
local fontSize = import '../../shared/styles/fontSize.libsonnet';
local keycap = import '../../shared/styles/keycap.libsonnet';

// 面板按键清单。顺序即显示顺序，按行取 4 个。
// name 只用于生成样式名，不出现在界面上。
local panelRows = [
  [
    { name: 'KeyboardSettings', icon: 'gearshape.fill', text: '设置',
      action: { openURL: 'hamster3://com.ihsiao.apps.hamster3/keyboardSettings' } },
    { name: 'Skin', icon: 'paintpalette.fill', text: '皮肤',
      action: { openURL: 'hamster3://com.ihsiao.apps.hamster3/finder?action=openSkinsFile&fileURL=jsonnet/Custom.libsonnet' } },
    { name: 'InputSchema', icon: 'switch.2', text: '方案',
      action: { openURL: 'hamster3://com.ihsiao.apps.hamster3/inputSchema' } },
    { name: 'Switcher', icon: 'filemenu.and.selection', text: '状态',
      action: { shortcut: '#RimeSwitcher' } },
  ],
  [
    { name: 'Finder', icon: 'folder.fill', text: '文件',
      action: { openURL: 'hamster3://com.ihsiao.apps.hamster3/finder' } },
    { name: 'Script', icon: 'apple.terminal.fill', text: '脚本',
      action: { openURL: 'hamster3://com.ihsiao.apps.hamster3/script' } },
    { name: 'toogleEmbedded', icon: 'square.and.pencil', text: '内嵌',
      action: { shortcut: '#toggleEmbeddedInputMode' } },
    { name: 'Performance', icon: 'gauge.with.dots.needle.bottom.50percent', text: '内存',
      action: { shortcut: '#keyboardPerformance' } },
  ],
  // App 快捷入口。走 openURL + 各家的 URL scheme，
  // 未安装对应 App 时点了没有反应（系统不会报错）。
  [
    { name: 'QQ', icon: 'bubble.left.and.bubble.right.fill', text: 'QQ',
      action: { openURL: 'mqq://' } },
    { name: 'WeChat', icon: 'message.fill', text: '微信',
      action: { openURL: 'weixin://' } },
    { name: 'Douyin', icon: 'play.rectangle.fill', text: '抖音',
      action: { openURL: 'snssdk1128://' } },
    { name: 'Pdd', icon: 'cart.fill', text: '拼多多',
      action: { openURL: 'pinduoduo://' } },
  ],
];

// 单个按键：背景 + 图标前景 + 文字前景。
local panelButton(item, theme) = {
  [item.name + 'Button']: {
    backgroundStyle: 'panelButtonBackgroundStyle',
    foregroundStyle: [
      item.name + 'ButtonIconStyle',
      item.name + 'ButtonTextStyle',
    ],
    action: item.action,
  },
  [item.name + 'ButtonIconStyle']: {
    buttonStyleType: 'systemImage',
    systemImageName: item.icon,
    fontSize: fontSize['panel按键前景sf符号大小'],
    fontWeight: 'medium',
    normalColor: color[theme]['按键前景颜色'],
    highlightColor: color[theme]['按键前景颜色'],
    center: center['panel键盘按键sf符号前景偏移'],
  },
  [item.name + 'ButtonTextStyle']: {
    buttonStyleType: 'text',
    text: item.text,
    fontSize: fontSize['panel按键前景文字大小'],
    fontWeight: 'medium',
    normalColor: color[theme]['按键前景颜色'],
    highlightColor: color[theme]['按键前景颜色'],
    center: center['panel键盘按键文字前景偏移'],
  },
};

local keyboard(theme, orientation) =
  local buttons = std.foldl(
    function(acc, item) acc + panelButton(item, theme),
    std.flattenArrays(panelRows),
    {}
  );
  buttons + {
    // 每行一个 HStack（HStack 是行）。行与行等分面板高度，
    // 行内 4 键不写 size，自动均分宽度。
    keyboardLayout: [
      {
        HStack: {
          subviews: [{ Cell: item.name + 'Button' } for item in row],
        },
      }
      for row in panelRows
    ],
    // 面板相对键盘的缩放。竖屏铺满键盘宽度的九成、高度七成；
    // 横屏键盘很宽，面板收窄到一半多，否则按键会被拉成长条。
    floatTargetScale:
      if orientation == 'portrait' then { x: 0.92, y: 0.72 }
      else { x: 0.58, y: 0.82 },
    keyboardStyle: {
      insets: { top: 10, left: 12, bottom: 10, right: 12 },
      backgroundStyle: 'keyboardBackgroundStyle',
    },
    keyboardBackgroundStyle: keycap.panelKeyboardBackground(theme, Settings, color),
    panelButtonBackgroundStyle: keycap.panelButtonBackground(theme, orientation, Settings, color),
  };

{
  new(theme, orientation):
    keyboard(theme, orientation),
}
