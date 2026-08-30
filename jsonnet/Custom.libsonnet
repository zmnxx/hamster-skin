{
  // 中文键盘布局
  // 9:  九宫格（默认）
  // 26: 全键
  // 27: 27 键（26 键 + 分号键，供双拼方案输入 ing）
  keyboard_layout: 9,

  // 9键按键长按符号是否直接上屏
  t9_hint_symbol_direct_output: true,
  // 9键键盘是否交换左下角数字键盘和符号键盘按钮位置
  swap_9_123_symbol: true,
  // 数字键盘是否交换左侧返回按钮和右侧切换键盘按钮位置
  swap_numeric_return_symbol: true,

  // 功能按键配置
  function_button_config: {
    // 是否启用功能行（按设备区分）
    with_functions_row: {
      iPhone: true,
      iPad: false,
    },

    // 是否启用功能按键通知功能
    enable_notification: true,

    // 功能行按钮顺序，也可以注释掉不需要的按钮，但不建议这么做
    // 可用值:
    // left: 左移
    // head: 行首
    // select: 选择
    // cut: 剪切
    // copy: 复制
    // paste: 粘贴
    // tail: 行尾
    // right: 右移
    order: [
      'left',
      'head',
      'select',
      'cut',
      'copy',
      'paste',
      'tail',
      'right',
    ],
  },

  // 26字母按键是否显示大写
  is_letter_capital: false,

  // 是否修复部分 sf_symbol 不显示问题
  fix_sf_symbol: false,

  // 是否显示上下划前景
  show_swipe: true,

  // 中文 26 键划动辅助模式
  // none: 关闭
  // up:   上划输入对应字母大写，并把原上划内容追加到长按气泡
  // down: 下划输入对应字母大写，并把原下划内容追加到长按气泡
  // all:  上下划都输入对应字母大写，并把原上划、下划内容依次追加到长按气泡
  swipe_assist_mode: 'none',

  // 26键 / 14键 / 18键 的 123 按键交互配置
  button_123_config: {    // true: 保持当前 horizontalSymbols 滑动切换
    // false: 改用下方配置的长按菜单或上下滑动
    enable_slide: false,

    // 当 enable_slide 为 false 时生效
    // hint_symbols: 使用长按菜单显示「符号键盘 / emoji键盘」
    // swipe: 使用上下滑动切换「符号键盘 / emoji键盘」
    secondary_action_mode: 'swipe',

    // 当 secondary_action_mode 为 swipe 时生效
    // 可选值: symbolic / emojis
    swipe_up_keyboard: 'emojis',
    swipe_down_keyboard: 'symbolic',

    // 是否显示 123Button 的上下划角标
    // 只影响角标显示，不影响 swipe 动作本身
    show_swipe_indicators: false,
  },

  // 九键 / 数字键盘的符号按钮交互配置
  button_symbol_config: {
    // true: 保持当前 horizontalSymbols 滑动切换
    // false: 改用下方配置的长按菜单或上下滑动
    enable_slide: false,

    // 当 enable_slide 为 false 时生效
    // hint_symbols: 使用长按菜单显示「emoji键盘」
    // swipe: 仅使用上滑切换到次级键盘
    secondary_action_mode: 'swipe',

    // 当 secondary_action_mode 为 swipe 时生效
    // symbolButton 点击动作本身进入 symbolic，次级目标保留 emoji 键盘。
    swipe_up_keyboard: 'emojis',
  },

  // tips 上屏动作。想让它直接上屏逗号就改成 { character: ',' }
  tips_button_action: { sendKeys: 'Break' },

  // 按键音。文件放在皮肤根目录的 sound/ 下。
  // 三类按键各配一个，全局统一生效（所有键盘、横竖屏、iPhone / iPad 都读这一份）：
  //   input  输入型按键 —— character / symbol，即字母、数字、符号
  //   delete 删除键 —— backspace
  //   system 系统型按键 —— 回车、shift、tab、切键盘等
  // 三项都可省略，省略的那一类用系统自带音。
  // 让多类指向同一个文件即可共用一个音，不必复制多份。
  //
  // actions：按 action 给单个键指定音效，优先级高于上面三类。
  // 每项 { action: <KeyboardAction>, url: <文件名> }；action 重复时取首个。
  //
  // 格式（踩过的坑）：官方说「仅支持 aiff、wav」，指的是**无压缩 AIFF**。
  // AIFC（FORM type = AIFC，带 FVER 块、压缩标识如 fl32 浮点）虽然后缀也是
  // .aif，元书不播，且静默回落系统音、不报错。从别的皮肤搬音效时先看 FORM
  // type：是 AIFC 就必须转成 AIFF / 无压缩 / 单声道 / 16bit / 44100Hz。
  //
  // 长按连发与跟手节奏：按键音由每次按键动作触发，长按 backspace 时
  // repeatAction 每次重复删除都会重新触发 delete 音，所以音效自然跟着连发。
  // 前提是**音频本身要短、且没有前导静音**：
  //   - 有前导静音 → 听起来比手指慢半拍（元书自带音效前面有 48ms 静音）
  //   - 音频比连发间隔长 → 上一声还没放完下一声就来，会互相打断听着发闷
  // 本皮肤两个音都裁到 10ms 内、首声在 1ms 内起振，连发与单击都跟得上手。
  //
  // 音量：元书没有音量参数，只能改音频文件本身，这里保持源音频原始电平不动。
  key_sound: {
    // 输入键 + 系统键：用户提供的清脆双击音（取第一下瞬态）
    input: 'key_input.aiff',
    system: 'key_input.aiff',
    // 删除键：皮肤原来的按键音移到这里
    delete: 'key_delete.aiff',
  },

  // 是否启用 iOS26 风格（统一按键颜色，Light模式下调整高亮）
  ios26_style: true,

  // 背景贴图。开启后各区域铺一张固定的背景图，不再透出 iOS 系统键盘背板 ——
  // 好处是任何 App 里观感完全一致，代价是不再随 App 变化。
  // false 时回到透明背景（透出系统背板）。
  //
  // 图放在 <light|dark>/resources/ 下，每张图配一个同名 .yaml 描述子图区域。
  //
  // 为什么要分这么多张：元书每个区域只有**一个**背景槽，
  // 且四个区域各自独立（preedit / toolbar / 候选栏 / 按键区）。
  //   toolbar   这个槽原本被通长胶囊占用，于是胶囊圆角外那圈没人画、
  //             露出系统背板（深色 App 里近黑，看着不协调）。
  //             所以把胶囊直接画进 toolbar_back，槽指向图即可两者兼得。
  //   cand      横向候选栏与工具栏同位置、出现时工具栏隐藏，是独立的槽；
  //             不给图就露出黑底（打字时候选区发黑就是这个原因）。
  //   vcand     纵向候选栏占「工具栏 + 按键区」，同理。
  // 四张图都从同一张源图的对应条带裁出，接缝处颜色自然连续。
  //
  // 顶边不切圆角，改成**整条 alpha 渐隐**（顶部 18pt 由全透明平滑升到不透明）。
  //
  // 原因：皮肤无法知道当前 App 里系统有没有画圆角背板（元书没有这类
  // conditionKey），一张静态图必须同时伺候两种情况：
  //   有系统圆角（实测圆弧半径约 20.7pt）—— 图若自带圆角，两条弧不重合，
  //     会在夹缝里露出一条月牙；
  //   无系统圆角 —— 图自带圆角就是个突兀的 R 角。
  // 渐隐两种情况都成立：有圆角时弧区图近乎全透明、看到的是系统自己的圆角；
  // 无圆角时四角是方的，顶边由背板色柔和过渡到图色，不出现硬直线。
  // 渐隐高度取 18pt，略小于系统圆弧半径，够盖住弧区又不至于把 preedit 洗白。
  //
  // 下边缘不做处理：按键区底下还有系统那条地球/麦克风区域，那块皮肤画不到。
  background_image: {
    enabled: true,
    keyboard: 'kb_back',        // 按键区
    preedit: 'preedit_back',    // 预编辑区（开启内嵌输入模式时不渲染）
    toolbar: 'toolbar_back',    // 工具栏（胶囊已烘进图里）
    candidates: 'cand_back',    // 横向候选栏（与工具栏同位置）
    vcandidates: 'vcand_back',  // 纵向候选栏（工具栏 + 按键区）
  },

  // 强制单一配色：忽略系统深浅色，始终使用暗色配色
  // 部分 App 会强制把输入法拉成浅色模式，开启此项后皮肤在那些 App 里
  // 也保持暗色，不会突然变白。
  // 实现方式：light 主题直接复用 dark 的全部颜色令牌与键帽配色，
  // 两套 yaml 内容一致。
  force_single_theme: 'dark',   // 'dark' / 'light' / false（false = 跟随系统）

  // 回车键是否使用强调色（蓝色）
  // false: 回车与其他功能键同色，避免部分 App 里蓝、部分 App 里灰的不统一观感
  enter_key_accent: false,

  // 字号配置
  font_size_config: {
    // 仅控制26字母键(q~m)前景文字大小
    pinyin_26_letter_font_size: 20,

    // 仅控制9键字母前景文字大小
    pinyin_9_letter_font_size: 20,

    // 仅控制数字键盘数字前景文字大小
    numeric_digit_font_size: 20,
  },

  // 按键间距
  button_insets: {
    // 紧凑布局
    portrait: { top: 2, left: 1.5, right: 1.5, bottom: 2 },

    // 紧凑布局
    landscape: { top: 1.5, left: 1, bottom: 1.5, right: 1 },
  },

  // 按键圆角，建议 7 / 8 / 8.5
  // 注意：keycap_style 为 'gradient' 时，按键本身的圆角由
  // keycap_config.cornerRadius 决定，这里的值只影响符号键盘 collection 等非按键区域。
  cornerRadius: 8,

  // 键帽风格
  // 'default':  单色键帽（无渐变、无描边）
  // 'gradient': 渐变键帽（上下渐变 + 半透明描边 + 底部亮边 + 光晕/涟漪动效）
  // 只影响按键本身，不动工具栏与功能行
  keycap_style: 'gradient',

  // 键帽细节参数，仅在 keycap_style == 'gradient' 时生效
  keycap_config: {
    // 键帽圆角
    cornerRadius: 14,
    // 26 键专用圆角。26 键键位窄（约 34pt），圆角 14 会接近药丸形，略降更方正
    cornerRadius26: 11,

    // 键帽间距。相邻两键的间隙 = 左键 right + 右键 left
    // 九键 / 数字键盘 / 符号键盘：单元格约 76pt，左右各 4 → 间隙 8pt，占 10%
    insets: {
      portrait: { top: 3, left: 4, right: 4, bottom: 3 },
      landscape: { top: 3, left: 3, right: 3, bottom: 3 },
    },
    // 26 键专用间距。单元格只有约 38pt，沿用 4pt 会让间隙占到 21%，明显偏松
    insets26: {
      portrait: { top: 3, left: 2, right: 2, bottom: 3 },
      landscape: { top: 2.5, left: 1.5, right: 1.5, bottom: 2.5 },
    },

    // 键帽描边宽度
    borderSize: 1,

    // 键帽投影
    shadowOpacity: 0.08,
    shadowRadius: 4,

    // 长按气泡圆角与描边
    hintCornerRadius: 10,
    hintBorderSize: 0.5,
    hintShadowRadius: 3,

    // 按下动效
    // scale:  按下缩放（0 表示关闭）
    press_scale: 0.84,
    press_duration: 35,
    release_duration: 130,

    // glow:   按下时中心扩散的白色光晕（ax1_1~ax1_10.png）
    enable_glow: true,
    // ripple: 按下时的涟漪气泡（bx1_1~bx1_10.png）
    enable_ripple: true,
    // 动效帧率与目标放大倍数
    animation_fps: 40,
    animation_target_scale: 0.3,
  },

  // shift 特殊动作配置（仅用于26键）
  shift_config: {
    // 是否启用 shift 的预编辑特殊动作
    enable_preedit: true,

    // shift 在预编辑状态的动作
    preedit_action: { character: '/' },

    // shift 在预编辑状态显示的 sf symbol
    // 为空时使用默认符号
    preedit_sf_symbol: '',

    // 26键shift按键预编辑状态上划操作
    // 可选：分词、辅助筛选，分词为'，辅助筛选为`
    preedit_swipeup_action: '辅助筛选',
  },

  // 横向候选栏最右侧按钮：
  // 0: 无
  // 1: 展开候选按钮
  // 2: 收起键盘按钮（开启预测时建议使用，方便收起键盘）
  horizon_candidate_button: 2,

  // 工具栏布局配置
  toolbar_config: {
    // 是否启用键盘菜单页面
    // false: 使用皮肤内置的悬浮键盘
    // true: 使用 app 的 keyboardMenu
    toolbar_menu: false,

    // 工具栏高度。50 是为「显示 comment（注释）」留的余量；
    // 实测 42 已经能放下候选字 + 注释，且整体键盘矮 8pt，观感更紧凑。
    // 若你在 App 里关掉了 comment 显示，还可以降到 36~40。
    toolbar_height: 42,

    // 工具栏滑动区域按钮显示方向
    content_right_to_left: false,

    // segmented:
    // 固定按钮 + 左侧横向滑动 + 固定中间按钮 + 右侧横向滑动 + 固定收起按钮
    //
    // carousel:
    // 固定首按钮 + 中间整体横向滑动 + 固定尾按钮
    //
    // fixed:
    // 全部按钮等宽平铺，没有滑动区，fixed 数组里的按钮全部常驻可见。
    // 适合「所有功能一眼看全、不想滑动」的场景；按钮数建议 ≤ 8，
    // 再多每个键会窄到放不下两个汉字。
    mode: 'fixed',

    // 可用按钮 ID:
    // script: 脚本
    // note: 常用语
    // clipboard: 剪切板
    // hide: 收起键盘
    // menu_or_panel: 键盘菜单或浮动键盘
    // google: Google 搜索
    // baidu: 百度搜索
    // bing: Bing 搜索
    // safari: 浏览器打开剪切板内容
    // apple: App Store 搜索
    // keyboard_settings: 键盘设置
    // keyboard_skins: 皮肤管理
    // skin_adjust: 皮肤调整
    // keyboard_performance: 内存占用
    // rime_switcher: 方案切换
    // embedding_toggle: 内嵌开关
    // symbol: 符号键盘
    // emoji: 表情键盘
    // left_hand: 左手键盘
    // right_hand: 右手键盘
    // switch_keyboard: 切换手机键盘
    // simplified_traditional: 简繁切换
    // undo: 撤销
    // redo: 重做
    // cut: 剪切
    // copy: 复制
    // paste: 粘贴

    fixed: {
      // mode = 'fixed' 时生效：数组里的按钮全部常驻、等宽平铺，没有滑动区。
      // 顺序即显示顺序。8 个键在 iPhone 竖屏下每键约 46pt，放两个汉字正好。
      // 排列: 菜单、搜索、网址、商店、常用、剪贴、脚本、收起
      buttons: [
        'menu_or_panel',
        'google',
        'safari',
        'apple',
        'note',
        'clipboard',
        'script',
        'hide',
      ],
    },

    segmented: {
      // 第一种布局
      // 排列: 脚本、搜索、网址、商店、菜单、常用、剪贴、收起
      // 搜索(google)、网址(safari)、商店(apple)在可滑动格子里(显示2个)
      // 其余固定: 脚本、菜单、常用、剪贴(2个在右侧滑动区恰好填满显示)、收起
      left_fixed: 'script',
      left_slide: [
        'google',
        'safari',
        'apple',
      ],
      center_fixed: 'menu_or_panel',
      right_slide: [
        'note',
        'clipboard',
      ],
      right_fixed: 'hide',
    },

    carousel: {
      // 第二种布局
      // 中间区域当前显示 5 个按钮，只有按钮数量超过 5 个时才会产生横向滑动
      left_fixed: 'menu_or_panel',
      center_slide: [
        'script',
        'google',
        'note',
        'clipboard',
        'emoji',
        'symbol',
        'skin_adjust',
        'keyboard_settings',
        'keyboard_skins',
        'baidu',
        'bing',
        // 如有需要添加的按钮直接在后面添加即可
      ],
      right_fixed: 'hide',
    },

    // iPad 工具栏
    // 首按钮固定为 menu_or_panel
    // 末按钮固定为 hide
    // 中间为显示 11 个按钮的横向滑动区域
    ipad: {
      // 是否启用键盘菜单页面
      // false: 使用皮肤内置的悬浮键盘
      // true: 使用 app 的 keyboardMenu
      toolbar_menu: false,

      // 工具栏滑动区域按钮显示方向
      content_right_to_left: false,

      // 工具栏高度（在开启comment的情况下，iPad上该高度比较合适）
      toolbar_height: 57,

      // 可用按钮 ID:
      // keyboard_settings: 键盘设置
      // keyboard_skins: 皮肤管理
      // skin_adjust: 皮肤调整
      // keyboard_performance: 内存占用
      // embedding_toggle: 内嵌开关
      // rime_switcher: 方案切换
      // google: Google 搜索
      // baidu: 百度搜索
      // bing: Bing 搜索
      // safari: 浏览器打开剪切板内容
      // apple: App Store 搜索
      // script: 脚本
      // note: 常用语
      // clipboard: 剪切板
      // symbol: 符号键盘
      // emoji: 表情键盘
      // 中间区域当前显示 11 个按钮，只有按钮数量超过 11 个时才会产生横向滑动
      center_slide: [
        'keyboard_settings',
        'keyboard_skins',
        'embedding_toggle',
        'rime_switcher',
        'google',
        'safari',
        'script',
        'note',
        'clipboard',
        'symbol',
        'emoji',
        'baidu',
        'bing',
        'apple',
        'skin_adjust',
        'keyboard_performance',
      ],
    },
  },
}
