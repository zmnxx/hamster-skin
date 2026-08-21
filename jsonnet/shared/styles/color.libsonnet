// 定义键盘主题共用的颜色令牌。
local Settings = import '../../Custom.libsonnet';

// 青绿色
local teal = '1FB382';
// 浅色模式下的青绿色（稍深一些，白色背景上更清晰）
local teal_light = '1AA371';

local base_light = {
  '字母键背景颜色-普通': 'FFFFFFCC',
  '字母键背景颜色-高亮': 'ABB0BACC',

  '功能键背景颜色-普通': '979faf66',
  '功能键背景颜色-高亮': 'FFFFFFCC',

  'enter键背景(蓝色)': '4A6B7A',

  '气泡背景颜色': 'FFFFFF',
  '气泡边缘颜色': '606060',
  '气泡高亮颜色': '4A6B7A',

  '底边缘颜色-普通': '88898D',
  '底边缘颜色-高亮': '89898B',

  '长按选中字体颜色': 'FFFFFF',
  '长按非选中字体颜色': '000000',
  '长按选中背景颜色': '4A6B7A',
  '长按背景阴影颜色': '797B7E',
  '长按背景颜色': 'FFFFFFCC',

  // 候选栏统一走灰白系：键帽是中性灰，候选栏原本的金棕 + 青绿色相跨度太大，
  // 首选改为「加重的深灰 + 浅灰底」，其他候选用中灰，靠明度而非色相区分。
  '候选字体选中字体颜色': '1A1A1A',
  '候选字体未选中字体颜色': '5A5A5F',
  '选中候选背景颜色': 'FFFFFFE6',

  'toolbar按键颜色': '000000',
  // 工具栏按钮按下反馈。原本全透明（按下无任何变化），
  // 这里给一层与键帽高亮同源的淡色底。
  'toolbar按键背景颜色-普通': '00000000',
  'toolbar按键背景颜色-高亮': 'ABB0BA66',
  // 26键上下划动文字用青绿色
  '划动字符颜色': teal_light,
  '按下气泡文字颜色': '2E2E2E',
  '暗紫色': '4A6B7A',
  // 工具栏和候选栏背景统一为灰色
  'toolbar背景颜色': 'E8E8E8',

  // 数字键盘颜色
  'collection前景颜色': '000000',

  // 符号键盘颜色
  '列表选中字体颜色': teal_light,
  '列表未选中字体颜色': '000000',
  '符号键盘左侧collection背景颜色': 'F5F5F5',
  '符号键盘左侧collection背景下边缘颜色': 'D0D0D0',
  '符号键盘右侧collection背景颜色': 'FAFAFA',
  '符号键盘右侧collection背景下边缘颜色': 'D0D0D040',
  // 符号区/分类区的分隔线。不写这个值时元书会用系统灰，
  // 在被强制浅色的 App 里几乎看不见，因此显式指定。
  '符号区分隔线颜色': 'C7C7CC80',
  '按键边缘颜色': 'C7C7CC',

  '按键前景颜色': '000000',

  // 全部键盘的背景色, 默认透明,自行设置
  '键盘背景颜色': 'D0D3DA03',
};

local base_dark = {
  // 暗色模式：按键改为深黑色背景
  '字母键背景颜色-普通': '2B2B2B',
  '字母键背景颜色-高亮': '3D3D3D',

  '功能键背景颜色-普通': '1E1E1E',
  '功能键背景颜色-高亮': '383838',

  'enter键背景(蓝色)': '4A6B7A',

  '气泡背景颜色': '2B2B2B',
  '气泡边缘颜色': '606060',
  '气泡高亮颜色': '4A6B7A',

  '底边缘颜色-普通': '0A0A0A',
  '底边缘颜色-高亮': '1A1A1A',

  '长按选中字体颜色': 'FFFFFF',
  '长按非选中字体颜色': 'F2F2F2',
  '长按选中背景颜色': '4A6B7A',
  '长按背景阴影颜色': '00000050',
  '长按背景颜色': '2B2B2B',

  // 候选栏统一走灰白系（见浅色注释）
  '候选字体选中字体颜色': 'FFFFFF',
  '候选字体未选中字体颜色': 'B4B4B8',
  '选中候选背景颜色': '3D3D3D',

  'toolbar按键颜色': 'E5E5E5',
  'toolbar按键背景颜色-普通': '00000000',
  'toolbar按键背景颜色-高亮': '3D3D3D99',
  // 26键上下划动文字用青绿色
  '划动字符颜色': teal,
  '按下气泡文字颜色': 'E6E6E6',
  '暗紫色': '4A6B7A',
  // 工具栏和候选栏背景统一为灰色
  'toolbar背景颜色': '2B2B2B',

  // 数字键盘颜色
  'collection前景颜色': 'F2F2F2',

  // 符号键盘颜色
  '列表选中字体颜色': teal,
  '列表未选中字体颜色': 'F2F2F2',
  '符号键盘左侧collection背景颜色': '1E1E1E',
  '符号键盘左侧collection背景下边缘颜色': '0A0A0A',
  '符号键盘右侧collection背景颜色': '2B2B2B',
  '符号键盘右侧collection背景下边缘颜色': '1A1A1A',
  '符号区分隔线颜色': '55555580',
  '按键边缘颜色': '3A3A3A',

  '按键前景颜色': 'F2F2F2',

  // 全部键盘的背景色
  '键盘背景颜色': '0A0A0A',
};

// iOS26 风格覆盖
local ios26_light = base_light + {
  '字母键背景颜色-普通': 'FFFFFF',
  '字母键背景颜色-高亮': 'ABB0BA99',
  '功能键背景颜色-普通': 'FFFFFF',
  '功能键背景颜色-高亮': 'ABB0BA99',
  '符号键盘左侧collection背景颜色': 'F5F5F5',
  '符号键盘左侧collection背景下边缘颜色': 'D0D0D0',
  '气泡背景颜色': base_light['气泡背景颜色'],
  '底边缘颜色-普通': '00000000',
  '底边缘颜色-高亮': '00000000',
  '键盘背景颜色': '00000000',
};

// 暗色模式 iOS26：保持深黑色风格
local ios26_dark = base_dark + {
  '字母键背景颜色-普通': '2B2B2B',
  '字母键背景颜色-高亮': '3D3D3D',
  '功能键背景颜色-普通': '1E1E1E',
  '功能键背景颜色-高亮': '383838',
  '符号键盘左侧collection背景颜色': '1E1E1E',
  '符号键盘左侧collection背景下边缘颜色': '0A0A0A',
  '气泡背景颜色': base_dark['气泡背景颜色'],
};

// 强制单一配色：把两个主题都指向同一套令牌。
// 部分 App 会强制输入法进入浅色模式，这时元书加载的是 light/ 下的 yaml，
// 所以只要让 light 用 dark 的颜色，就能在那些 App 里保持暗色不变。
local forced =
  if std.objectHas(Settings, 'force_single_theme') then Settings.force_single_theme else false;

local resolvedLight = if Settings.ios26_style then ios26_light else base_light;
local resolvedDark = if Settings.ios26_style then ios26_dark else base_dark;

{
  light: if forced == 'dark' then resolvedDark
  else if forced == 'light' then resolvedLight
  else resolvedLight,
  dark: if forced == 'light' then resolvedLight
  else if forced == 'dark' then resolvedDark
  else resolvedDark,

  // 供其他模块查询「当前 theme 实际应该用哪套配色」
  resolveTheme(theme):: if forced == false then theme else forced,
}
