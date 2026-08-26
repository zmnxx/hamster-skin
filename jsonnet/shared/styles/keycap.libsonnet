// 键帽风格模块。
//
// 键帽外观：上下渐变 + 半透明描边 + 底部亮边 + 光晕 / 涟漪逐帧动效。
// 由 Custom.libsonnet 的 keycap_style 开关控制，取值 'default' 时全部回退到
// 单色键帽实现（无渐变、无描边）。
//
// 只负责「按键本身」：工具栏（toolbar*）与功能行的按钮内容、顺序、动作
// 一律不经过本模块。
local styleFactories = import 'styleFactories.libsonnet';

// ---------------------------------------------------------------------------
// 渐变键帽配色
//
// 覆盖字母键 / 功能键 / 回车键 / 长按气泡 / 长按面板五组背景。
// 浅色键帽带 alpha（靠下层键盘背景透出层次）；深色键帽全部不透明，
// 因为 iOS26 下键盘背景已改成透明交给系统背板，半透明键帽会随 App 变色：
// 深色 App 里偏灰，被强制浅色的 App 里被漂白。现在的深色值 = 原半透明色
// 在 0A0A0A 上的合成结果，观感不变且不受下层影响。
// ---------------------------------------------------------------------------
// 强调色渐变，回车键与长按选中块共用。
local accentDark = ['#C9A86A', '#9A7B45'];
local accentLight = ['#9A7B45', '#7A5F33'];
local gradientPalette = {
  light: {
    // 字母键 / 数字键：接近纯白，上浓下淡
    '字母键背景颜色-普通': ['#FFFFFFA3', '#FFFFFF47'],
    '字母键背景颜色-高亮': ['#FFFFFFF9', '#FFFFFFE0'],

    // 功能键：比字母键略灰一档
    '功能键背景颜色-普通': ['#EEF1F780', '#DDE1EA40'],
    '功能键背景颜色-高亮': ['#FAFAFCF7', '#EEEEF2E8'],

    // 回车键（强调色）
    'enter键背景(强调色)': accentLight,

    // 键帽描边与底部亮边——玻璃质感与立体感的来源
    '键帽描边颜色-普通': '#FFFFFF4D',
    '键帽描边颜色-高亮': '#FFFFFF99',
    '键帽底边缘颜色-普通': '#FFFFFFE6',
    '键帽底边缘颜色-高亮': '#FFFFFFF5',

    // 长按气泡
    '气泡背景颜色': '#FFFFFF',
    '气泡描边颜色': '#D1D3D9',
    '气泡阴影颜色': '#A8ABB2',

    // 长按符号面板
    '长按面板背景颜色': '#FFFFFF',
    '长按面板描边颜色': '#D1D3D9',
    '长按面板阴影颜色': '#A8ABB2',
    '长按面板选中颜色': accentLight,
  },
  // 暗色键帽全部使用**不透明**色（原因见文件头的配色说明）。
  dark: {
    '字母键背景颜色-普通': ['#414144', '#212122'],
    '字母键背景颜色-高亮': ['#8E8E92', '#727275'],

    '功能键背景颜色-普通': ['#29292B', '#151516'],
    '功能键背景颜色-高亮': ['#68686C', '#525255'],

    'enter键背景(强调色)': accentDark,

    // 描边同样压平：分别压在各自渐变的上端色上
    '键帽描边颜色-普通': '#5D5D60',
    '键帽描边颜色-高亮': '#949499',
    '键帽底边缘颜色-普通': '#000000',
    '键帽底边缘颜色-高亮': '#000000',

    '气泡背景颜色': '#2C2C2E',
    '气泡描边颜色': '#38383A',
    '气泡阴影颜色': '#000000',

    '长按面板背景颜色': '#2C2C2E',
    '长按面板描边颜色': '#38383A',
    '长按面板阴影颜色': '#000000',
    '长按面板选中颜色': accentDark,
  },
};

// keycap_config 的默认值，用户漏填某项时回退到这里
local defaultConfig = {
  cornerRadius: 14,
  // 26 键键位窄（约 34pt），圆角 14 会接近药丸形，略降更方正
  cornerRadius26: 11,
  // insets = 键帽四周的收缩量，相邻两键的间隙 = 左键 right + 右键 left。
  // 三档分开配，否则同样的 pt 值在不同单元格宽度下松紧差别很大：
  //   九键 / 数字键盘 单元格约 76pt，8pt 间隙占 10%
  //   26 键          单元格约 38pt，8pt 会占 21%，明显偏松
  //   功能行         8 键平铺约 48pt，介于两者之间；不独立配的话切键盘时
  //                  功能行键帽会忽大忽小（九键页读 4pt、26 键页读 2pt）
  insets: {
    portrait: { top: 3, left: 4, right: 4, bottom: 3 },
    landscape: { top: 3, left: 3, right: 3, bottom: 3 },
  },
  insets26: {
    portrait: { top: 3, left: 2, right: 2, bottom: 3 },
    landscape: { top: 2.5, left: 1.5, right: 1.5, bottom: 2.5 },
  },
  insetsFunctionRow: {
    portrait: { top: 3, left: 2.5, right: 2.5, bottom: 3 },
    landscape: { top: 2.5, left: 2, right: 2, bottom: 2.5 },
  },
  cornerRadiusFunctionRow: 12,
  borderSize: 1,
  shadowOpacity: 0.08,
  shadowRadius: 4,
  hintCornerRadius: 10,
  hintBorderSize: 0.5,
  hintShadowRadius: 3,
  press_scale: 0.84,
  press_duration: 35,
  release_duration: 130,
  enable_glow: true,
  enable_ripple: true,
  animation_fps: 40,
  animation_target_scale: 0.3,
  apply_to_long_press_panel: true,
};

local isEnabled(Settings) =
  std.objectHas(Settings, 'keycap_style') && Settings.keycap_style == 'gradient';

// 强制单一配色时，键帽也要跟着走同一套颜色，否则被强制浅色的 App 里
// 键帽会变白、而其他区域仍是暗色。
local resolveTheme(Settings, theme) =
  local forced = if std.objectHas(Settings, 'force_single_theme') then Settings.force_single_theme else false;
  if forced == 'dark' then 'dark'
  else if forced == 'light' then 'light'
  else theme;

// 回车键是否使用强调色。关闭时回车与其他功能键同色。
local enterAccent(Settings) =
  if std.objectHas(Settings, 'enter_key_accent') then Settings.enter_key_accent else true;

local cfg(Settings) =
  defaultConfig + (if std.objectHas(Settings, 'keycap_config') then Settings.keycap_config else {});

// keyClass: 'k26' = 26 键（键窄，用更小的间隙与圆角）
//           'func' = 功能行（8 键平铺，独立一套，保证跨键盘一致）
//           其余用通用值
local keycapInsets(Settings, orientation, keyClass) =
  local k = cfg(Settings);
  local group =
    if keyClass == 'func' && std.objectHas(k, 'insetsFunctionRow') then k.insetsFunctionRow
    else if keyClass == 'k26' && std.objectHas(k, 'insets26') then k.insets26
    else k.insets;
  if orientation == 'portrait' then group.portrait else group.landscape;

local keycapRadius(Settings, keyClass) =
  local k = cfg(Settings);
  if keyClass == 'func' && std.objectHas(k, 'cornerRadiusFunctionRow') then k.cornerRadiusFunctionRow
  else if keyClass == 'k26' && std.objectHas(k, 'cornerRadius26') then k.cornerRadius26
  else k.cornerRadius;

local fallbackInsets(Settings, orientation) =
  if orientation == 'portrait' then Settings.button_insets.portrait else Settings.button_insets.landscape;

// 逐帧动画贴图名。ax1_* 是光晕、bx1_* 是涟漪，各取 1~10 帧。
local frameImages(prefix) = [prefix + '_' + std.toString(i) + '.png' for i in std.range(1, 10)];

{
  // 是否启用渐变键帽（关闭时回退到单色键帽）
  enabled(Settings):: isEnabled(Settings),

  // -------------------------------------------------------------------------
  // 面板类 collection（九宫格/数字键盘左侧符号栏、符号键盘分类栏）的圆角。
  // 与并排的键帽必须同一档，否则读成「另一套控件贴上来」。
  // 未启用渐变键帽时回退到 Settings 的全局值。
  //
  // 间距不需要单独的 getter：用 panelBackground() 的键盘由它内部统一取
  // keycapInsets()；符号键盘只用圆角，间距自己硬编码。
  // -------------------------------------------------------------------------
  panelRadius(Settings)::
    if !isEnabled(Settings) then Settings.cornerRadius
    else cfg(Settings).cornerRadius,

  // -------------------------------------------------------------------------
  // 面板类 collection 的背景材质：与字母键完全同料（渐变端点 / 描边 /
  // 底边缘 / 阴影都取自 gradientPalette），否则底板是块平板、旁边键帽是立体的，
  // 落差在交界处很明显；补上同样的底边缘 + 阴影后两者高度也自然对齐。
  // -------------------------------------------------------------------------
  panelBackground(theme0, orientation, Settings, color, fallbackNormalKey, fallbackLowerEdgeKey)::
    local theme = resolveTheme(Settings, theme0);
    if !isEnabled(Settings) then
      styleFactories.makeGeometryStyle(color[theme][fallbackNormalKey], {
        insets: fallbackInsets(Settings, orientation),
        cornerRadius: Settings.cornerRadius,
        normalLowerEdgeColor: color[theme][fallbackLowerEdgeKey],
      })
    else
      local c = gradientPalette[theme];
      local k = cfg(Settings);
      local normal = c['字母键背景颜色-普通'];
      {
        buttonStyleType: 'geometry',
        normalColor: normal,
        // 底板不接受点击，但 highlightColor 缺失时元书会在某些时机回落系统色，
        // 所以显式写成与常态相同
        highlightColor: normal,
        [if std.isArray(normal) then 'colorLocation']: [0, 1],
        cornerRadius: keycapRadius(Settings, ''),
        insets: keycapInsets(Settings, orientation, ''),
        borderSize: k.borderSize,
        normalBorderColor: c['键帽描边颜色-普通'],
        highlightBorderColor: c['键帽描边颜色-普通'],
        normalLowerEdgeColor: c['键帽底边缘颜色-普通'],
        highlightLowerEdgeColor: c['键帽底边缘颜色-普通'],
        shadowOpacity: k.shadowOpacity,
        shadowRadius: k.shadowRadius,
      },

  // -------------------------------------------------------------------------
  // 工具栏通长胶囊底。
  //
  // 与字母键完全同料（同一组渐变端点 / 描边 / 底边缘 / 阴影），只有圆角与
  // 内缩不同。用单独一层平色会比键帽渐变亮且没有立体层次，读起来对不上。
  // -------------------------------------------------------------------------
  toolbarCapsuleBackground(theme0, Settings, cornerRadius, insets)::
    local theme = resolveTheme(Settings, theme0);
    if !isEnabled(Settings) then
      styleFactories.makeGeometryStyle('00000000')
    else
      local c = gradientPalette[theme];
      local k = cfg(Settings);
      local normal = c['字母键背景颜色-普通'];
      {
        buttonStyleType: 'geometry',
        normalColor: normal,
        highlightColor: normal,
        [if std.isArray(normal) then 'colorLocation']: [0, 1],
        cornerRadius: cornerRadius,
        insets: insets,
        borderSize: k.borderSize,
        normalBorderColor: c['键帽描边颜色-普通'],
        highlightBorderColor: c['键帽描边颜色-普通'],
        normalLowerEdgeColor: c['键帽底边缘颜色-普通'],
        highlightLowerEdgeColor: c['键帽底边缘颜色-普通'],
        shadowOpacity: k.shadowOpacity,
        shadowRadius: k.shadowRadius,
      },

  // -------------------------------------------------------------------------
  // 按键背景
  //
  // 各键盘 builder 生成按键背景的统一入口。
  // insetsOverride 供硬编码间距的键盘（符号键盘）在 default 模式下沿用原值。
  // keyClass 取 'k26'（26 键紧凑间隙）/ 'func'（功能行独立间隙）/ ''（通用）。
  // -------------------------------------------------------------------------
  buttonBackground(theme0, orientation, Settings, color, normalKey0, highlightKey, insetsOverride={}, keyClass='')::
    local theme = resolveTheme(Settings, theme0);
    // 回车键不用强调色时，直接当作普通功能键处理
    local normalKey =
      if normalKey0 == 'enter键背景(强调色)' && !enterAccent(Settings)
      then '功能键背景颜色-普通' else normalKey0;
    local defaultIns =
      if insetsOverride != {} then insetsOverride else fallbackInsets(Settings, orientation);
    if !isEnabled(Settings) then
      styleFactories.makeGeometryStyle(color[theme][normalKey], {
        insets: defaultIns,
        highlightColor: color[theme][highlightKey],
        cornerRadius: Settings.cornerRadius,
        normalLowerEdgeColor: color[theme]['底边缘颜色-普通'],
        highlightLowerEdgeColor: color[theme]['底边缘颜色-高亮'],
      })
    else
      local c = gradientPalette[theme];
      local k = cfg(Settings);
      local normal = if std.objectHas(c, normalKey) then c[normalKey] else color[theme][normalKey];
      // 回车键按下时保持强调色，不要退回功能键的灰白
      local highlight =
        if normalKey == 'enter键背景(强调色)' then c['enter键背景(强调色)']
        else if std.objectHas(c, highlightKey) then c[highlightKey]
        else color[theme][highlightKey];
      {
        buttonStyleType: 'geometry',
        normalColor: normal,
        highlightColor: highlight,
        // colorLocation 长度必须与颜色数量一致，标量色时不能写
        [if std.isArray(normal) then 'colorLocation']: [0, 1],
        cornerRadius: keycapRadius(Settings, keyClass),
        insets: keycapInsets(Settings, orientation, keyClass),
        borderSize: k.borderSize,
        normalBorderColor: c['键帽描边颜色-普通'],
        highlightBorderColor: c['键帽描边颜色-高亮'],
        normalLowerEdgeColor: c['键帽底边缘颜色-普通'],
        highlightLowerEdgeColor: c['键帽底边缘颜色-高亮'],
        shadowOpacity: k.shadowOpacity,
        shadowRadius: k.shadowRadius,
      },

  // -------------------------------------------------------------------------
  // 长按气泡背景（单个字符放大的那个气泡）
  // -------------------------------------------------------------------------
  hintBackground(theme0, Settings, color)::
    local theme = resolveTheme(Settings, theme0);
    if !isEnabled(Settings) then
      styleFactories.makeGeometryStyle(color[theme]['气泡背景颜色'], {
        highlightColor: color[theme]['气泡高亮颜色'],
        cornerRadius: Settings.cornerRadius,
        shadowColor: color[theme]['长按背景阴影颜色'],
        shadowOffset: { x: 0, y: 5 },
      })
    else
      local c = gradientPalette[theme];
      local k = cfg(Settings);
      {
        buttonStyleType: 'geometry',
        normalColor: c['气泡背景颜色'],
        cornerRadius: k.hintCornerRadius,
        borderSize: k.hintBorderSize,
        normalBorderColor: c['气泡描边颜色'],
        highlightBorderColor: c['气泡描边颜色'],
        normalShadowColor: c['气泡阴影颜色'],
        highlightShadowColor: c['气泡阴影颜色'],
        shadowRadius: k.hintShadowRadius,
      },

  // -------------------------------------------------------------------------
  // 长按符号面板：背景 与 选中块
  // fallback 传入基于贴图的 fileImage 样式：未启用渐变键帽、或关闭了
  // apply_to_long_press_panel 子开关时，原样返回它。
  // -------------------------------------------------------------------------
  longPressPanelBackground(theme0, Settings, fallback)::
    local theme = resolveTheme(Settings, theme0);
    local k = cfg(Settings);
    if !isEnabled(Settings) || !k.apply_to_long_press_panel then fallback
    else
      local c = gradientPalette[theme];
      {
        buttonStyleType: 'geometry',
        normalColor: c['长按面板背景颜色'],
        highlightColor: c['长按面板选中颜色'],
        // 常态是单色、按下才是渐变，此处不能写 colorLocation
        // （长度需与颜色数量一致，否则渐变静默失效）
        cornerRadius: 12,
        insets: { top: 3, left: 4, right: 4, bottom: 3 },
        borderSize: k.hintBorderSize,
        normalBorderColor: c['长按面板描边颜色'],
        highlightBorderColor: c['长按面板描边颜色'],
        normalShadowColor: c['长按面板阴影颜色'],
        highlightShadowColor: c['长按面板阴影颜色'],
        shadowRadius: k.hintShadowRadius,
      },

  // 选中块沿用键帽参数，但始终保持强调色——它是「当前选中项」的指示，
  // 不受 enter_key_accent 影响（否则选中块和面板底色一样就看不出选了哪个）。
  longPressPanelSelected(theme0, Settings, color, fallback)::
    local theme = resolveTheme(Settings, theme0);
    local k = cfg(Settings);
    if !isEnabled(Settings) || !k.apply_to_long_press_panel then fallback
    else
      local c = gradientPalette[theme];
      {
        buttonStyleType: 'geometry',
        normalColor: c['长按面板选中颜色'],
        highlightColor: c['长按面板选中颜色'],
        colorLocation: [0, 1],
        cornerRadius: k.cornerRadius,
        insets: { top: 3, left: 4, right: 4, bottom: 3 },
        borderSize: k.borderSize,
        normalBorderColor: c['键帽描边颜色-普通'],
        highlightBorderColor: c['键帽描边颜色-高亮'],
        normalLowerEdgeColor: c['键帽底边缘颜色-普通'],
        highlightLowerEdgeColor: c['键帽底边缘颜色-高亮'],
        shadowOpacity: k.shadowOpacity,
        shadowRadius: k.shadowRadius,
      },

  // -------------------------------------------------------------------------
  // 按键动效
  //
  // animationRegistry(): 需要注册到键盘根节点的动画定义
  // animationNames():    按钮的 animation 数组
  //
  // 注意：ButtonScaleAnimation 一律保持原值不动——功能行按钮
  // （左移/行首/复制…）引用的就是它，改它会连带改掉功能行手感。
  // 渐变键帽的按下缩放使用独立的 KeycapPressAnimation。
  // -------------------------------------------------------------------------
  animationRegistry(Settings, animation)::
    { ButtonScaleAnimation: animation['26键按键动画'] }
    + (if !isEnabled(Settings) then {} else
         local k = cfg(Settings);
         {
           KeycapPressAnimation: {
             animationType: 'scale',
             isAutoReverse: false,
             scale: k.press_scale,
             pressDuration: k.press_duration,
             releaseDuration: k.release_duration,
           },
         }
         + (if k.enable_glow then {
              KeycapGlowAnimation: {
                animationType: 'cartoon',
                images: frameImages('ax1'),
                fps: k.animation_fps,
                targetScale: k.animation_target_scale,
                zPosition: 'above',
                center: { x: 0.5 },
              },
            } else {})
         + (if k.enable_ripple then {
              KeycapRippleAnimation: {
                animationType: 'cartoon',
                images: frameImages('bx1'),
                fps: k.animation_fps,
                targetScale: k.animation_target_scale,
                zPosition: 'above',
                center: { x: 0.5 },
              },
            } else {})),

  animationNames(Settings)::
    if !isEnabled(Settings) then ['ButtonScaleAnimation']
    else
      local k = cfg(Settings);
      (if k.press_scale > 0 then ['KeycapPressAnimation'] else [])
      + (if k.enable_glow then ['KeycapGlowAnimation'] else [])
      + (if k.enable_ripple then ['KeycapRippleAnimation'] else []),
}
