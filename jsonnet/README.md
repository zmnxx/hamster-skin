# 万象键盘 · 空山键帽

基于 [万象键盘](https://github.com/BlackCCCat) 的元书（Hamster3）皮肤，
移植了「空山素影」的键帽外观与按下动效，并统一为单色暗色主题。

- 作者：BlackCCCat（原皮肤）
- 键帽移植与定制：见「改动说明」
- 版本：见 `version.txt`

---

## 一、皮肤包含哪些键盘

共 6 种，全部在 `config.yaml` 里声明：

| 键盘 | 说明 | 竖屏 / 横屏 | iPad |
| --- | --- | --- | --- |
| `pinyin` | 中文主键盘。九宫格或 26 键，由 `keyboard_layout` 决定 | 有 | 有 |
| `temp_pinyin` | 临时中文 26 键。在英文键盘上划时切回中文用 | 有 | — |
| `alphabetic` | 英文 26 键 | 有 | 有 |
| `numeric` | 数字九宫格 | 有 | 有 |
| `symbolic` | 符号键盘 | 有 | — |
| `panel` | 浮动功能面板 | 有 | — |

> 14 键、18 键布局已从本皮肤移除。若需要，请用原版万象。

`config.yaml` 里 `pinyin` 那一组的文件名固定是 `pinyin_26_*`，
与 `keyboard_layout` 取什么值无关——元书只认这个名字，
文件里装的是九键还是 26 键由 `main.jsonnet` 决定。

---

## 二、我要改 XX，去哪个文件

改任何东西之前先看这张表，绝大多数需求只需动一个文件。

| 想改什么 | 改哪里 |
| --- | --- |
| **键盘整体配色** | `shared/styles/color.libsonnet` 顶部的 `base_light` / `base_dark` |
| **键帽外观**（渐变、描边、圆角、投影） | `shared/styles/keycap.libsonnet` 顶部的 `kongshan` 对象 |
| **键帽圆角 / 间距 / 动效开关** | `Custom.libsonnet` 的 `keycap_config`（26 键单独用 `insets26` / `cornerRadius26`，功能行用 `insetsFunctionRow` / `cornerRadiusFunctionRow`） |
| **所有配色** | `shared/styles/color.libsonnet`（`base_light` / `base_dark` 两套令牌） |
| **强制单色（不跟随系统深浅）** | `Custom.libsonnet` 的 `force_single_theme` |
| **回车键是否用蓝色** | `Custom.libsonnet` 的 `enter_key_accent` |
| **中文键盘布局**（九键 / 26 键 / 27 键） | `Custom.libsonnet` 的 `keyboard_layout` |
| **英文键盘上下划符号与动作** | `shared/data/swipeDataEn.libsonnet` |
| **中文键盘上下划** | `shared/data/swipeData.libsonnet` |
| **长按符号面板内容** | `shared/data/hintSymbolsData.libsonnet` |
| **工具栏按钮顺序与内容** | `Custom.libsonnet` 的 `toolbar_config` |
| **工具栏高度 / 按下反馈** | `toolbar_config.toolbar_height` / `shared/toolbar/iPhone.libsonnet` 的 `toolbarButtonBackgroundStyle` |
| **候选字颜色** | `color.libsonnet` 的 `候选字体选中字体颜色` / `候选字体未选中字体颜色` / `选中候选背景颜色` |
| **preedit 拼音区颜色** | `shared/toolbar/iPhone.libsonnet` 的 `preeditStyle` / `preeditForegroundStyle` |
| **符号区分隔线颜色** | `color.libsonnet` 的 `符号区分隔线颜色` |
| **功能行按钮顺序** | `Custom.libsonnet` 的 `function_button_config.order` |
| **各处字号** | `shared/styles/fontSize.libsonnet` |
| **前景文字/图标位置微调** | `shared/styles/center.libsonnet` |
| **键盘高度** | `shared/styles/others.libsonnet` 的 `keyboard高度` |
| **某个键的按键动作** | 对应键盘的 `builder.libsonnet` 或 `systemKeys*.libsonnet` |

---

## 三、目录结构

```text
WanxiangSkin/
├── config.yaml            键盘清单（由 main.jsonnet 生成，不要手改）
├── demo.png               应用内预览图
├── version.txt            版本号
├── README.md              本文档
├── light/  dark/          编译产物：各键盘 yaml + resources 贴图
└── jsonnet/               皮肤源码
    ├── Custom.libsonnet   ★ 所有可配置项都在这里
    ├── main.jsonnet       入口：声明 config.yaml + 决定每个键盘用哪个实现
    ├── keyboards/         按键盘类型组织的实现
    └── shared/            多个键盘共用的样式、数据、组件
```

### `jsonnet/keyboards/` — 键盘实现

| 目录 | 内容 |
| --- | --- |
| `pinyin9/` | 中文九宫格。`t9.libsonnet` 是九键字母分组，`panels.libsonnet` 是左侧符号区 |
| `pinyin26/` | 中文 26 键 |
| `alphabetic26/` | 英文 26 键 |
| `numeric9/` | 数字九宫格 |
| `symbolic/` | 符号键盘（含全部符号数据源） |
| `tempPinyin/` | 临时中文 26 键，在 `pinyin26` 上做少量覆写 |
| `float/` | 浮动功能面板 |
| `common/keyboard26/` | 26 键共用：布局、字母规格、按钮工厂、iPad 覆写 |
| `common/systemKeys26/` | 26 键的功能键，按键拆分成独立文件（shift / 回车 / 空格 / 退格 / 中英 / 切换） |
| `common/layoutAssembly/` | 把共享布局数据和功能行补丁装配成最终布局 |

每种键盘的文件命名规律一致：

- `iPhone.libsonnet` / `iPad.libsonnet` — 对外入口，只做装配转发
- `builder.libsonnet` — 主体构建：把布局、样式、按钮拼成完整键盘
- `layout.libsonnet` — 布局骨架（HStack 是行、VStack 是列）
- `panels.libsonnet` — 该键盘特有的 collection 区域

### `jsonnet/shared/` — 共用部分

| 目录 / 文件 | 内容 |
| --- | --- |
| `styles/color.libsonnet` | ★ 全部颜色令牌，深浅两套；末尾处理 `force_single_theme` |
| `styles/keycap.libsonnet` | ★ 空山素影键帽：背景、气泡、长按面板、三种按下动效 |
| `styles/fontSize.libsonnet` | 全部字号 |
| `styles/center.libsonnet` | 全部前景偏移（文字/图标在键内的位置） |
| `styles/others.libsonnet` | 三个区域的高度 |
| `styles/animation.libsonnet` | 万象原有的按键缩放动画（功能行在用，勿改） |
| `styles/styleFactories.libsonnet` | 样式构造函数（text / systemImage / geometry / fileImage） |
| `styles/keyStyles.libsonnet` | 26 键字母、数字键的文字前景批量生成 |
| `styles/swipeKeyStyles.libsonnet` | 上下划角标与气泡样式 |
| `styles/hintSymbolsStyles.libsonnet` | 长按符号面板样式 |
| `styles/baseKeyStyles.libsonnet` | 26 键与九键共用的按键背景注册 |
| `styles/slideButtonStyles.libsonnet` | 工具栏滑动区按钮样式 |
| `data/swipeData.libsonnet` | 中文键盘、数字键盘的上下划数据 |
| `data/swipeDataEn.libsonnet` | ★ 英文 26 键上下划数据 |
| `data/hintSymbolsData.libsonnet` | 长按符号面板内容 |
| `data/layoutData.libsonnet` | 与功能行无关的基础按键尺寸 |
| `toolbar/` | 工具栏：`config` 解析设置、`registry` 按钮注册表、`iPhone`/`iPad` 组装 |
| `functionButtons/` | 功能行：`specs` 动作定义、`styles` 前景、`functionRowPatch` 布局补丁 |
| `buttonHelpers/` | 按键辅助：长按/划动交互判定、字母键批量生成、回车键通知 |

---

## 四、可配置项（`jsonnet/Custom.libsonnet`）

### 布局

- `keyboard_layout` — 中文键盘布局：`9` 九宫格（默认）/ `26` 全键 / `27` 搜狗双拼 27 键
- `wanxiang_9_hintSymbol` — 九键长按符号是否直接上屏
- `swap_9_123_symbol` — 九键左下角 `123` 与符号键是否互换
- `swap_numeric_return_symbol` — 数字键盘返回键与切换键是否互换
- `is_letter_capital` — 26 字母键是否显示大写

### 键帽风格（移植「空山素影」）

- `keycap_style`
  - `'kongshan'`（默认）— 上下渐变 + 半透明描边 + 底部亮边 + 光晕/涟漪动效
  - `'default'` — 万象原版键帽（单色、无描边、无渐变）
  - 只影响按键本身；工具栏与功能行的**按钮内容与顺序**始终保持万象原样，
    但它们的尺寸与配色在 v5 做过统一（见「六、修改记录」）
- `keycap_config`（仅 `kongshan` 生效）
  - `cornerRadius` / `cornerRadius26` / `cornerRadiusFunctionRow` — 键帽圆角。
    26 键键位窄（约 34pt），单独用 `cornerRadius26`（11），沿用 14 会接近药丸形
  - `insets` / `insets26` / `insetsFunctionRow` — 键帽间距（竖横屏分开配）。
    相邻两键的间隙 = 左键 `right` + 右键 `left`
    - 九键 / 数字 / 符号：单元格约 76pt，左右各 4 → 间隙 8pt，占 10%
    - 26 键：单元格只有约 38pt，沿用 4pt 会让间隙占到 21%，所以用 `insets26`（各 2pt）
    - 功能行：固定 8 键平铺全宽，单元格约 48pt，介于两者之间，用
      `insetsFunctionRow`（各 2.5pt）。**这一套是所有键盘共用的**——功能行原本
      复用各键盘的字母键背景，导致九键页与 26 键页的功能行键帽大小不同，
      切键盘时会跳动；现在统一走 `functionRowButtonBackgroundStyle`
    - iPad 26 键单元格约 73pt，由 `iPadBuilder` 覆写回通用间距
  - `borderSize` / `shadowOpacity` / `shadowRadius` — 描边与投影
  - `hintCornerRadius` / `hintBorderSize` / `hintShadowRadius` — 长按气泡
  - `press_scale` / `press_duration` / `release_duration` — 按下缩放（设 0 关闭）
  - `enable_glow` — 按下时中心扩散的白色光晕（`ax1_1~ax1_10.png`）
  - `enable_ripple` — 按下时的涟漪气泡（`bx1_1~bx1_10.png`）
  - `animation_fps` / `animation_target_scale` — 动效帧率与放大倍数
  - `apply_to_long_press_panel` — 长按符号面板是否也用空山素影配色

配色令牌集中在 `shared/styles/keycap.libsonnet` 顶部的 `kongshan` 对象，
改配色只需动这一处，五种键盘同时生效。

### 强制单一配色

- `force_single_theme`
  - `'dark'`（默认）— 无论系统深浅色、无论 App 是否强制浅色，始终使用暗色
  - `'light'` — 始终浅色
  - `false` — 跟随系统（万象原有行为）

原理：元书在浅色模式下加载 `light/` 的 yaml，所以让 `light` 直接复用 `dark`
的全部颜色令牌，两套 yaml 内容完全一致。与 Write 2023 皮肤同一思路。
实现位置：`color.libsonnet` 末尾的 `forced` 分支 + `keycap.libsonnet` 的
`resolveTheme()`（键帽配色要跟着走，否则会出现键帽白、其他区域黑的割裂）。

### 回车键配色

- `enter_key_accent`
  - `false`（默认）— 回车与其他功能键完全同色
  - `true` — 恢复万象原有的蓝色回车

部分 App 会把 `returnKeyType` 设成「发送 / 前往 / 搜索」，万象原本对这些类型
套用蓝色强调背景，导致同一个键在不同 App 里一会儿蓝一会儿灰。关掉后统一。
长按符号面板的「选中项」不受影响，仍用强调色，否则看不出选了哪个。

### 26 键交互

- `show_swipe` — 是否显示上下划角标
- `swipe_assist_mode` — 中文 26 键划动辅助：`none` / `up` / `down` / `all`
- `button_123_config` — `123` 键的滑动切换 / 长按菜单 / 上下划目标键盘
- `button_symbol_config` — 九键与数字键盘符号键的同类配置
- `shift_config` — shift 键在预编辑状态的特殊动作
- `tips_button_action` — tips 键上屏动作
- `show_wanxiang` — 空格键是否显示「万象」标识
- `horizon_candidate_button` — 横向候选栏最右按钮：`0` 无 / `1` 展开 / `2` 收起键盘

### 功能行

- `function_button_config.with_functions_row` — 是否启用功能行（iPhone / iPad 分开）
- `function_button_config.enable_notification` — 功能键是否随预编辑状态变化
- `function_button_config.order` — 按钮顺序。可用：
  `left` 左移、`head` 行首、`select` 全选、`cut` 剪切、`copy` 复制、
  `paste` 粘贴、`tail` 行尾、`right` 右移

  其中 `tail` 是双态键：不打字时是「行尾」（`#行尾`），打字时切换为
  「候选」（`#candidatesBarStateToggle`，展开/收起候选栏）。

### 工具栏

- `toolbar_config.toolbar_menu` — 用 App 的键盘菜单还是皮肤内置浮动面板
- `toolbar_config.toolbar_height` — 工具栏高度
- `toolbar_config.mode` — `segmented`（固定+两段滑动）或 `carousel`（首尾固定+中间滑动）
- `toolbar_config.segmented` / `carousel` / `ipad` — 各模式下的按钮排列

可用按钮 ID 见 `Custom.libsonnet` 内的注释列表（脚本、常用语、剪贴板、
搜索、简繁切换、方案切换、左右手模式等 20 余项）。

### 字号与外观

- `font_size_config` — 26 键字母、九键字母、数字键盘数字的字号
- `button_insets` — 按键间距（`keycap_style: 'kongshan'` 时由 `keycap_config.insets` 接管）
- `cornerRadius` — 按键圆角（同上，`kongshan` 时只影响符号键盘 collection）
- `ios26_style` — iOS 26 风格配色覆盖

---

## 五、英文 26 键上下划（参考 Write 2023）

数据表：`shared/data/swipeDataEn.libsonnet`

q~m 全部 26 键都配了上划 + 下划，共 52 个动作，无重复：

```
        上划                          下划
第一行  1 2 3 4 5 6 7 8 9 0         ~ @ # $ % ^ & * ( )
第二行  - = / \ | ` : " '           左 _ + [ ] { } ; 右
第三行  、。？！…《》                 全 剪 复 贴 方 首 尾
```

第二行两端 a / l 的下划是左手 / 右手单手模式，第三行下划是编辑动作
（全选 / 剪切 / 复制 / 粘贴 / 方案切换 / 行首 / 行尾）。

角标样式：上划标在键帽右上角、下划标在左上角，字号 8，字母本体仍居中。

- 位置：`shared/styles/center.libsonnet` 的『英文上划/下划文字偏移』
- 字号：`shared/styles/fontSize.libsonnet` 的『英文划动角标文字大小』
- 中文键盘与数字键盘的上下划标记不受影响，仍是原来的上下居中样式

---

## 六、编译

皮肤源码是 jsonnet，元书加载的是编译产物 yaml。

### 只改数值？别编译

元书只读 `light/` `dark/` 下的成品 yaml，`jsonnet/` 纯粹是源码存档。
改配色、间距、字号这类**数值**，直接改 yaml 完全等价，而且快得多：

```bash
FE=/var/minis/shared/hamster-skin/skin_fastedit.py
SKIN=<皮肤目录>

python3 "$FE" cache "$SKIN"                    # 建缓存，约 150 秒，只需一次
python3 "$FE" get   "$SKIN" toolbarHeight      # 看现值
python3 "$FE" set   "$SKIN" toolbarHeight 42   # 改，秒级
python3 "$FE" batch "$SKIN" /tmp/edits.txt     # 改多处
python3 "$FE" pack  "$SKIN" out.cskin          # 写出并打包，约 30 秒
```

本仓库已经带好缓存（`.fastedit_cache.json`），可以跳过 `cache` 直接用。

耗时对比（iSH，36 个键盘文件）：

| 路线 | 首次 | 之后每改一次 |
| --- | --- | --- |
| jsonnet 全量编译 | ~10 分钟 | ~10 分钟 |
| skin_fastedit | ~150 秒（建缓存） | ~35 秒（改 + 打包） |

注意 `pack` 写出的是 **JSON 格式的 .yaml**——JSON 是 YAML 的合法子集，
元书能正常读（实测零改动往返 36 个文件差异 0）。这样做是因为 YAML 序列化
要 27 秒而 JSON 只要 2 秒。代价是体积 +20%、可读性差些。

**改了 yaml 之后 `jsonnet/` 就与成品不一致了**，要继续用 jsonnet 维护的话
记得把改动同步回源码。

### 改结构才需要编译

加减按键、改布局比例、换键盘类型这类改动绕不开 jsonnet：

```bash
cd jsonnet
jsonnet -J . -S -m ../  main.jsonnet     # 一次性全量编译
```

在 Minis / iSH 等资源受限环境里，单个键盘编译约 15~35 秒，
一次性编译 36 个文件容易超时或崩溃。建议逐个编译，脚本见
`/var/minis/shared/hamster-skin/`：

```bash
sh render_all.sh <输出目录> <键盘名前缀>   # 一次只跑一组
python3 validate_and_emit.py --write      # 校验并写入 light/ dark/
python3 health_check.py                   # 跨键盘一致性体检
python3 verify_scope.py                   # 确认改动都在白名单内
python3 compare_errors.py                 # 与基线对比，确认没引入新错误
python3 render_funcrow.py <渲染目录> <输出.png>  # 画功能行尺寸对照图
```

`health_check.py` 里有两项针对本项目历史 bug 的回归检查，值得留意：

- **颜色退回系统色** — 任何 `text` / `systemImage` / `assetImage` 样式若没同时写
  `normalColor` 和 `highlightColor`，元书就会用系统 label 色；分隔线默认开启的
  collection 若没写 `separatorLineColor` 就用系统灰。两者在被强制浅色的 App 里
  都会「看不清」。这类问题真机上只表现为某处颜色不对，很难定位，所以固化成检查项。
- **功能行跨键盘尺寸一致性** — 按「设备 × 朝向」分组，要求同组内所有键盘的
  `functionRowButtonBackgroundStyle` 完全一致，且 8 个按钮都指向它。

---

## 七、改动说明（相对原版万象）

### 新增

1. **空山素影键帽** — 上下渐变、半透明描边、底部亮边、圆角 14、投影，
   以及三层按下动效（缩放 + 光晕 10 帧 + 涟漪 10 帧）。
   工具栏与功能行未改动，仍用万象原有的 `ButtonScaleAnimation`。
2. **强制单一配色** — `force_single_theme`，解决部分 App 强制浅色时皮肤变白。
3. **回车键统一配色** — `enter_key_accent`，解决不同 App 里回车一会儿蓝一会儿灰。
4. **英文 26 键上下划** — 参考 Write 2023 重做，26 键全覆盖 + 角标式布局。
5. **功能行尺寸统一（v5）** — 功能行原本复用各键盘的字母键背景样式，于是
   26 键页用 2pt 间距、九键 / 数字页用 4pt，8 个按钮平铺全宽时单元格都是约
   48pt，键帽却一大一小，切键盘时明显跳动。现在独立出
   `functionRowButtonBackgroundStyle`（`keycap_config.insetsFunctionRow`
   + `cornerRadiusFunctionRow`），六种键盘的功能行完全同尺寸。

### 修复

1. **数字键盘背景比其他键盘浅** — `numeric9/builder.libsonnet` 的 `keyboardStyle`
   漏写 `backgroundStyle`，且 `keyboardBackgroundStyle` 引用了皮肤里并不存在的
   `bg.png`。元书遇到缺图会退回系统默认底色。已改为与其他键盘同一套 geometry。
2. **九键长按气泡无底** — 九键按键的 `hintStyle` 引用 `alphabeticHintBackgroundStyle`，
   但万象没在九键里定义它。样式名不存在时元书静默不渲染。已补上。
3. **preedit 拼音区在浅色 App 下看不清（v5）** — 候选栏上面那条拼音串显示区，
   `preeditStyle` 没挂 `backgroundStyle`（原代码是注释掉的），
   `preeditForegroundStyle` 也只有 `insets`，既无 `buttonStyleType` 也无颜色。
   元书遇到没写颜色的文字样式会退回**系统 label 色**——被强制浅色的 App 里
   label 是黑色，于是深色皮肤上出现黑字，几乎看不见。现在显式指定
   `toolbarBackgroundStyle` 作底 + `按键前景颜色` 作字。
4. **左侧符号区分隔线看不清（v5）** — `t9Symbols` / `categorySymbols` /
   `classifiedSymbols` 默认显示分隔线，但不写 `separatorLineColor` 就用系统灰。
   新增配色令牌 `符号区分隔线颜色`，覆盖九键左侧符号区、数字键盘符号区
   （竖屏 / 横屏 / 横屏分类区）、符号键盘左侧分类列表共 5 处。
   同时给 `collectionCellForegroundStyle` 补上 `highlightColor`，
   否则按下瞬间文字同样会退回系统色。
5. **符号键盘纵向候选栏删除键无图标（v5）** — `verticalCandidateBackspaceButton`
   引用 `backspaceButtonForegroundStyle`，但符号键盘里没有这个节点
   （它的删除键是文字版 `symbolBackspaceButtonForegroundStyle`）。
   改为引用同区域已有的 `verticalCandidateBackspaceButtonForegroundStyle`。

### 工具栏与候选栏优化（v5）

1. **工具栏高度 50 → 42** — 50 是为显示 comment 留的余量，实测 42 够用，
   键盘整体矮 8pt。改 `toolbar_config.toolbar_height`。
2. **工具栏按钮按下有反馈** — `toolbarButtonBackgroundStyle` 原本
   `normalColor` / `highlightColor` 都是 0（全透明），按下毫无变化。
   现在常态仍透明、按下给一层与键帽高亮同源的淡色底，圆角 8pt。
3. **候选栏配色统一到灰白系** — 原本首选是金棕（`E8A317` + `3A3520` 底）、
   其他候选是青绿（`1FB382`），与中性灰键帽色相跨度太大。现在改为靠明度
   区分：首选纯白 + `3D3D3D` 底，其他候选 `B4B4B8`。

### 精简

移除 14 键、18 键布局及其全部依赖：

- 删除 `keyboards/pinyin14/`、`keyboards/pinyin18/`、`keyboards/common/pinyin14_18/`
- 删除 `entries/` 整个目录（9 个文件都只是一行 import 转发，无人引用，
  `main.jsonnet` 直接 import `keyboards/` 下的实现）
- 清理 `hintSymbolsData` 的 `pinyin_18` / `pinyin_14` / `pinyin9`（381 行）
- 清理 `swipeData` 的 `swipe_up_14` / `swipe_down_14` / `swipe_up_18` / `swipe_down_18`（154 行）
- 清理 `functionRowPatch` 只服务 14/18 键的 `compactLandscape*`（41 行）
- 清理 `Custom.libsonnet` 的 `is_wanxiang_18` / `is_wanxiang_14` /
  `pinyin_14_18_letter_font_size`（已失效的兼容项）
- 合并 README 与 MODULES 两份重复文档为本文档

源码从 85 个文件 10427 行降到 64 个文件 9015 行，编译产物逐字节不变。
