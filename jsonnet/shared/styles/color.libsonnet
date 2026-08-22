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
  '气泡高亮颜色': '4A6B7A',

  '底边缘颜色-普通': '88898D',
  '底边缘颜色-高亮': '89898B',

  '长按选中字体颜色': 'FFFFFF',
  '长按非选中字体颜色': '000000',
  '长按背景阴影颜色': '797B7E',

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

  // 数字键盘颜色
  'collection前景颜色': '000000',

  // 符号键盘颜色
  '列表选中字体颜色': teal_light,
  '列表未选中字体颜色': '000000',
  '符号键盘左侧collection背景颜色': 'F5F5F5',
  '符号键盘左侧collection背景下边缘颜色': 'D0D0D0',
  '符号键盘右侧collection背景颜色': 'FAFAFA',
  // 符号区/分类区的分隔线。不写这个值时元书会用系统灰，
  // 在被强制浅色的 App 里几乎看不见，因此显式指定。
  '符号区分隔线颜色': 'C7C7CC80',

  '按键前景颜色': '000000',

  // 全部键盘的背景色, 默认透明,自行设置
  '键盘背景颜色': 'D0D3DA03',

  // 浮动面板（悬浮键盘）背景色，必须不透明，见暗色处的说明
  '浮动面板背景颜色': 'F2F2F7',
};

local base_dark = {
  // 暗色模式：按键改为深黑色背景
  '字母键背景颜色-普通': '2B2B2B',
  '字母键背景颜色-高亮': '3D3D3D',

  '功能键背景颜色-普通': '1E1E1E',
  '功能键背景颜色-高亮': '383838',

  'enter键背景(蓝色)': '4A6B7A',

  '气泡背景颜色': '2B2B2B',
  '气泡高亮颜色': '4A6B7A',

  '底边缘颜色-普通': '0A0A0A',
  '底边缘颜色-高亮': '1A1A1A',

  '长按选中字体颜色': 'FFFFFF',
  '长按非选中字体颜色': 'F2F2F2',
  '长按背景阴影颜色': '00000050',

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

  // 数字键盘颜色
  'collection前景颜色': 'F2F2F2',

  // 符号键盘颜色
  '列表选中字体颜色': teal,
  '列表未选中字体颜色': 'F2F2F2',
  // 左侧 collection（九宫格/数字键盘的符号栏、符号键盘的分类栏）。
  //
  // 原本是 1E1E1E，比压平后的功能键（#29292B → #151516）更暗，看着像
  // 一块单独贴上去的黑板，与旁边的键帽不在同一材质语言里。
  // 现在对齐功能键的渐变上端色，让它读起来是「一块和功能键同料的面」。
  '符号键盘左侧collection背景颜色': '29292B',
  '符号键盘左侧collection背景下边缘颜色': '151516',
  '符号键盘右侧collection背景颜色': '414144',
  '符号区分隔线颜色': '55555580',

  '按键前景颜色': 'F2F2F2',

  // 全部键盘的背景色
  '键盘背景颜色': '0A0A0A',

  // 浮动面板（悬浮键盘）的背景色。
  // 单独一个令牌是因为：主键盘背景在 iOS26 下会改成透明交给系统背板，
  // 而浮动面板下面没有背板托底，必须保持不透明。
  '浮动面板背景颜色': '1C1C1E',
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
  '气泡背景颜色': base_dark['气泡背景颜色'],

  // 键盘背景：**不透明**，取 iOS 26 深色系统背板的本色 1C1C1E。
  //
  // 试过两个极端，都不对：
  //   · 自刷 0A0A0A —— 比背板深一档，背板圆角露出的边缘和这层对不上色，
  //     四角像「贴了块黑纸」；
  //   · 改成 1C1C1E01 几乎全透明交给系统 —— 深色 App 里完美，但被强制
  //     浅色的 App 里浅色背板直接透上来，深色键帽浮在浅底上，那些 App
  //     里整个键盘格外突出、格格不入。
  // 取背板本色且不透明，两头都成立：深色 App 里与背板同色，圆角边缘看不
  // 出接缝；浅色 App 里自己铺一层深色面，键盘观感与深色下完全一致。
  '键盘背景颜色': '1C1C1E',

  // 键帽已在 keycap.libsonnet 里压平成不透明色，底色变了也不影响观感。
  // 这里的字母键/功能键令牌只在 keycap_style = 'default' 时生效，
  // 同样跟着抬一档，避免与新的背景色贴太近而糊在一起。
  '字母键背景颜色-普通': '414144',
  '字母键背景颜色-高亮': '8E8E92',
  '功能键背景颜色-普通': '29292B',
  '功能键背景颜色-高亮': '68686C',

  // 符号栏与功能键同料（base_dark 里已改，这里保持一致不再覆盖回旧值）
  '符号键盘左侧collection背景颜色': base_dark['符号键盘左侧collection背景颜色'],
  '符号键盘左侧collection背景下边缘颜色': base_dark['符号键盘左侧collection背景下边缘颜色'],
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
