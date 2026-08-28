// 定义键盘主题共用的颜色令牌。
//
// 四套令牌表：base_light / base_dark 是基础配色，ios26_light / ios26_dark 在
// 其上覆盖（由 Custom 的 ios26_style 选择）。force_single_theme 决定 light 与
// dark 最终各自指向哪一套。
//
// 注意：keycap_style = 'gradient' 时，按键本身的配色走 keycap.libsonnet 里的
// gradientPalette，这里的「字母键 / 功能键 / enter键 / 气泡 / 底边缘」只在
// keycap_style = 'default' 时生效。
local Settings = import '../../Custom.libsonnet';

// 统一强调色（暗色）：棕金色，回车 / 长按选中 / 划动字符 / 符号选中共用。
local accent = 'C9A86A';
// 统一强调色（浅色）：稍深一档的青铜色，白底上更清晰。
local accent_light = '9A7B45';

local base_light = {
  '字母键背景颜色-普通': 'FFFFFFCC',
  '字母键背景颜色-高亮': 'ABB0BACC',

  '功能键背景颜色-普通': '979faf66',
  '功能键背景颜色-高亮': 'FFFFFFCC',

  'enter键背景(强调色)': '1E8C80',

  '气泡背景颜色': 'FFFFFF',
  '气泡高亮颜色': '1E8C80',

  '底边缘颜色-普通': '88898D',
  '底边缘颜色-高亮': '89898B',

  '长按选中字体颜色': 'FFFFFF',
  '长按非选中字体颜色': '000000',
  '长按背景阴影颜色': '797B7E',

  // 候选栏靠明度而非色相区分首选与其他候选。
  '候选字体选中字体颜色': accent_light,
  '候选字体未选中字体颜色': '7A6E58',
  '选中候选背景颜色': '#EDE3D0',

  'toolbar按键颜色': '000000',
  // 按钮常态透明、按下给一层与键帽高亮同源的淡色底。
  'toolbar按键背景颜色-普通': '00000000',
  'toolbar按键背景颜色-高亮': 'ABB0BA66',
  '划动字符颜色': accent_light,
  // 英文 26 键上划角标与候选区同色。中性灰对比度不够、看不清。
  '英文划动字符颜色': accent_light,
  '按下气泡文字颜色': '2E2E2E',

  // 数字键盘颜色
  'collection前景颜色': '000000',

  // 符号键盘颜色
  '列表选中字体颜色': accent_light,
  '列表未选中字体颜色': '000000',
  '符号键盘左侧collection背景颜色': 'F5F5F5',
  '符号键盘左侧collection背景下边缘颜色': 'D0D0D0',
  '符号键盘右侧collection背景颜色': 'FAFAFA',
  // 不写这个值时元书用系统灰，在被强制浅色的 App 里几乎看不见。
  '符号区分隔线颜色': 'C7C7CC80',

  '按键前景颜色': '000000',

  '键盘背景颜色': 'D0D3DA03',

  // 浮动面板（悬浮键盘）背景色，必须不透明，见暗色处的说明
  '浮动面板背景颜色': 'F2F2F7',
};

local base_dark = {
  '字母键背景颜色-普通': '2B2B2B',
  '字母键背景颜色-高亮': '3D3D3D',

  '功能键背景颜色-普通': '1E1E1E',
  '功能键背景颜色-高亮': '383838',

  'enter键背景(强调色)': accent,

  '气泡背景颜色': '2B2B2B',
  '气泡高亮颜色': accent,

  '底边缘颜色-普通': '0A0A0A',
  '底边缘颜色-高亮': '1A1A1A',

  '长按选中字体颜色': 'FFFFFF',
  '长按非选中字体颜色': 'F2F2F2',
  '长按背景阴影颜色': '00000050',

  '候选字体选中字体颜色': accent,
  '候选字体未选中字体颜色': 'C2B49A',
  '选中候选背景颜色': '#3A3228',

  'toolbar按键颜色': 'F2F2F2',
  // 按钮常态透明——整条工具栏由一条通长胶囊托底（见 keycap.toolbarCapsuleBackground）。
  // 按钮各自带底会读成八个小方框，很碎。
  'toolbar按键背景颜色-普通': '00000000',
  'toolbar按键背景颜色-高亮': '5A5A5E80',
  '划动字符颜色': accent,
  // 英文 26 键上划角标与候选区同色。中性灰在深色键帽上对比度不够。
  '英文划动字符颜色': accent,
  '按下气泡文字颜色': 'E6E6E6',

  // 数字键盘颜色
  'collection前景颜色': 'F2F2F2',

  // 符号键盘颜色
  '列表选中字体颜色': accent,
  '列表未选中字体颜色': 'F2F2F2',
  // 左侧 collection（九宫格/数字键盘的符号栏、符号键盘的分类栏）。
  // 取值对齐渐变功能键的上下端色，让它读起来与键帽同料而非一块单独的黑板。
  '符号键盘左侧collection背景颜色': '29292B',
  '符号键盘左侧collection背景下边缘颜色': '151516',
  '符号键盘右侧collection背景颜色': '414144',
  '符号区分隔线颜色': '55555580',

  '按键前景颜色': 'F2F2F2',

  '键盘背景颜色': '0A0A0A',

  // 浮动面板（悬浮键盘）单独一个令牌：主键盘背景在 iOS26 下改成透明交给
  // 系统背板，而浮动面板下面没有背板托底，必须保持不透明。
  '浮动面板背景颜色': '1C1C1E',
};

// iOS26 风格覆盖
local ios26_light = base_light + {
  '字母键背景颜色-普通': 'FFFFFF',
  '字母键背景颜色-高亮': 'ABB0BA99',
  '功能键背景颜色-普通': 'FFFFFF',
  '功能键背景颜色-高亮': 'ABB0BA99',
  // 底边缘取消：iOS26 的键帽是平面材质，画底边缘会显得有一圈脏边
  '底边缘颜色-普通': '00000000',
  '底边缘颜色-高亮': '00000000',
  '键盘背景颜色': '00000000',
};

// 暗色模式 iOS26：保持深黑色风格
local ios26_dark = base_dark + {
  // 键盘背景：**完全透明**，整片交给 iOS 26 系统背板。
  //
  // 三个版本的演进，前两个都错在「用实色去追一个半透明材质」：
  //   1) 自刷 0A0A0A —— 比背板深，背板圆角露出的边缘和这层对不上色；
  //   2) 1C1C1E01 几乎全透明 —— 深色 App 完美，但当时键帽还是半透明的，
  //      浅色 App 里键帽被漂白（键帽后来已压平成不透明，这条不再成立）；
  //   3) 不透明 1C1C1E —— 仍有一条横带：开启内嵌输入后 preedit 区不渲染，
  //      但那 15pt 高度依然预留，露出的系统背板压在 App 背景上算出来是
  //      #19181D，与皮肤实刷的 #1C1C1E 差 3~4 阶，形成一条横贯全屏的硬边，
  //      两个圆角内侧同理。
  //
  // 根因是系统背板不是实色而是半透明材质，其观感随 App 背景变化，
  // 任何固定值都只能在某一个 App 里对得上。所以彻底不刷底色：
  // preedit 带、四个圆角、按键缝隙全部透出同一层背板，接缝消失，
  // 且换到任何 App 都自动吻合。
  // 键帽已是不透明色，不受这层影响，浅色 App 里也不会被漂白。
  '键盘背景颜色': 'ffffff00',

  // 下面四个令牌只在 keycap_style = 'default' 时生效（渐变键帽自带一套配色）。
  // 跟着背景抬一档，避免与新的背景色贴太近而糊在一起。
  '字母键背景颜色-普通': '414144',
  '字母键背景颜色-高亮': '8E8E92',
  '功能键背景颜色-普通': '29292B',
  '功能键背景颜色-高亮': '68686C',
};

// 强制单一配色：把两个主题都指向同一套令牌。
// 部分 App 会强制输入法进入浅色模式，这时元书加载的是 light/ 下的 yaml，
// 所以只要让 light 用 dark 的颜色，就能在那些 App 里保持暗色不变。
local forced =
  if std.objectHas(Settings, 'force_single_theme') then Settings.force_single_theme else false;

local resolvedLight = if Settings.ios26_style then ios26_light else base_light;
local resolvedDark = if Settings.ios26_style then ios26_dark else base_dark;

{
  light: if forced == 'dark' then resolvedDark else resolvedLight,
  dark: if forced == 'light' then resolvedLight else resolvedDark,
}
