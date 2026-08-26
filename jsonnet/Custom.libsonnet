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

  // 按键音。文件放在皮肤根目录的 sound/ 下，只支持 aiff 与 wav。
  // 三类按键各配一个，全局统一生效（所有键盘、横竖屏、iPhone / iPad 都读这一份）：
  //   input  输入型按键 —— character / symbol，即字母、数字、符号
  //   delete 删除键 —— backspace
  //   system 系统型按键 —— 回车、shift、tab、切键盘等
  // 三项都可省略，省略的那一类用系统自带音。
  // 想让某个键单独换音，在 main.jsonnet 的 config.keySound 里加 actions 数组。
  key_sound: {
    input: 'ios_aj.aiff',
    delete: 'ios_delete.aiff',
    // 系统键沿用输入音，保持整块键盘听感一致
    system: 'ios_aj.aiff',
  },

  // 是否启用 iOS26 风格（统一按键颜色，Light模式下调整高亮）
  ios26_style: true,

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
