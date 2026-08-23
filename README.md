# 元书皮肤-简约

元书输入法（Hamster3）皮肤源码。`jsonnet/` 是唯一真源，成品 YAML 由
GitHub Actions 编译产出，**不要手改编译出来的 light/ dark/ 下的 yaml**。

## 皮肤构成

- 中文九键（T9）为主键盘，另含 26 键中文 / 英文、数字九宫格、符号键盘、浮动面板
- 键帽移植「空山素影」风格：上下渐变 + 1px 描边 + 底部暗边 + 光晕 / 涟漪逐帧动效
- 键盘背景完全透明，整片交给 iOS 26 系统背板，避免皮肤自刷底色与背板对不上色
- 强制单一深色配色（`force_single_theme: 'dark'`），部分 App 强制输入法进浅色时
  皮肤也保持深色不变白

## 目录

```
jsonnet/                  皮肤源码（唯一真源）
  Custom.libsonnet        用户可调参数：键帽风格、圆角、间距、字号、工具栏按钮
  main.jsonnet            编译入口，输出 config.yaml + 18 个键盘 yaml
  shared/styles/          配色令牌、键帽材质、字号、动效
  keyboards/              各键盘的布局与按键定义
resources/{light,dark}/   贴图（动效帧、长按面板底、气泡底），不经过 jsonnet
demo.png                  应用内皮肤预览图
version.txt              版本号，Release 的 tag 取它
```

## 编译

不在本机编译（iSH 上全量编译是几十分钟级），走 Actions：

1. 仓库 → Actions → build-skin → Run workflow
2. `skin_name` 保持 `元书皮肤-简约`（须与 `main.jsonnet` 里的 `name` 一致）
3. 跑完在运行页底部 Artifacts 下载 `cskin`

整轮约 36 秒，其中 jsonnet 编译约 13 秒。

## 命名约定

**每次新的修改都要重新起名。** 元书按皮肤名管理已装皮肤，同名 `.cskin`
导入时常常保留旧的那一份（或并存两份而选中的仍是旧的），用户会以为改动没生效。
改动内容确定后，同时更新：

- `jsonnet/main.jsonnet` 的 `name`
- `.github/workflows/build-skin.yml` 里 `skin_name` 的 default
- `version.txt`

## 本版修复（首个版本）

针对「同一份皮肤在不同 App 里表现不一致」的三处问题：

1. **工具栏按钮加不透明胶囊底**（`29292B`）。原本常态全透明，靠键盘背景托底；
   但键盘背景已改成完全透明交给系统背板，于是在强制浅色的 App 里
   `E5E5E5` 的文字压在浅色背板上只差十几阶，几乎不可见。
   只给按钮范围上色，不整条工具栏刷底 —— 后者会在背板上压出一条横贯全屏的硬边。
2. **符号栏底板改为与功能键同料**。原本只有单色 + 一条下边缘，而并排的键帽是
   渐变 + 1px 描边 + 底边缘 + 阴影，底板读起来像一块平板贴在立体键帽旁边。
   新增 `keycap.panelBackground()` 统一生成，九键与数字键盘共用。
3. **符号栏文字字重的非法值**。`fontWeight: 0` 不在枚举（`ultraLight`…`black`）内，
   改为 `regular`。

已知待验证：T9 符号栏（`type: t9Symbols`）的文字颜色疑似不受皮肤控制。
实测在强制浅色的 App 里该列文字渲染为近黑，而同一份 yaml 里声明的是
`F2F2F2`，且旁边键帽的同色值渲染正常。符号内容本身由元书
「键盘设置 → 中文九键符号设定」提供，皮肤的 `dataSource` 对该类型无效。
