# 元书皮肤

[元书输入法](https://ihsiao.com/apps/hamster/)（Hamster3）皮肤，基于万象皮肤移植空山素影的键帽外观，并做了一系列修复与优化。

配色、间距、动效都可调，源码是 jsonnet，推上来由 GitHub Actions 自动编译打包成可安装的 `.cskin`。

## 拿到皮肤

不想自己编译的话，去 [Releases](../../releases) 下载 `.cskin`，传到 iPhone 上用元书打开即可导入。

想自己改的话见下面两条路线。

## 改皮肤：先分清改的是数值还是结构

元书加载的是 `light/` `dark/` 下的成品 YAML，`jsonnet/` 只是生成它们的源码。
两者都能改，但代价差 40 倍，所以先判断你要改什么。

### 改数值 → 不要编译

配色、间距、圆角、字号、键盘高度、工具栏高度、某个键的动作、上下划符号——
这些都是 YAML 里的值，直接改成品文件完全等价。

`tools/skin_fastedit.py` 就是干这个的：

```bash
FE=tools/skin_fastedit.py
SKIN=<解包后的皮肤目录>

python3 $FE cache "$SKIN"                    # 建缓存，只需一次
python3 $FE get   "$SKIN" toolbarHeight      # 看现值
python3 $FE set   "$SKIN" toolbarHeight 42   # 改
python3 $FE batch "$SKIN" edits.txt          # 改多处
python3 $FE pack  "$SKIN" out.cskin          # 写出并打包
```

选择器格式 `[主题:][文件名:]字段路径`，主题和文件名支持 `*`：

```
toolbarHeight                      所有键盘
preeditForegroundStyle.fontSize    嵌套字段用点号
light:*:toolbarHeight              只改 light
*:numeric*:collection.insets       只改数字键盘
```

batch 指令文件一行一条，`#` 是注释，`!create` 前缀允许新建字段：

```
# 拼音区配色
preeditStyle.backgroundStyle toolbarBackgroundStyle
!create preeditForegroundStyle.normalColor F2F2F2
toolbarHeight 42
```

几个要知道的点：

- `pack` 写出的是 **JSON 格式的 `.yaml`**。JSON 是 YAML 的合法子集，元书能正常读
  （实测零改动往返 36 个文件差异 0）。这么做是因为 YAML 序列化要 27 秒、JSON 只要 2 秒。
  代价是体积 +20%、可读性差些。
- `!create` **只新建末级键，不造中间层节点**。往没有 `collection` 的键盘写
  `collection.separatorLineColor` 会被跳过并报「N 处不存在」，这是对的——
  否则会捏出一个假节点，元书按名字找不到反而更难查。
- 改完 YAML 后 `jsonnet/` 就和成品不一致了。要继续用 jsonnet 维护就把改动同步回源码。

### 改结构 → 跑 Actions

增删按键、改布局行列比例、换键盘类型这些绕不开 jsonnet。

改完 `jsonnet/` 推上来，到 [Actions](../../actions) 里手动跑 **build-skin**，
在运行页面底部的 Artifacts 下载 `cskin`。勾上 `make_release` 会同时发一个 Release。

故意做成手动触发而不是 push 自动触发——改一个值不该每次都跑 CI。

**为什么不在本地编译**：jsonnet 是单线程递归求值，没有 JIT。在 iOS 的 iSH 里
单个键盘要 30 秒左右，一套 36 个文件全量编译 10 分钟以上，其中 91% 的时间都耗在编译上。
GitHub 的 runner 是 x86 多核，全量几十秒。

## 目录

```
jsonnet/          皮肤源码（改结构时动这里）
  Custom.libsonnet    所有开关与配置的入口
  main.jsonnet        编译入口，决定产出哪些键盘文件
  keyboards/          各键盘实现
  shared/             共享的样式、数据、工具栏、功能行
resources/        贴图（光晕 ax1_*、涟漪 bx1_*、九宫格底图），不经过 jsonnet
tools/
  skin_fastedit.py    改数值的快速通道
demo.png          应用内的皮肤预览图
version.txt       版本号，Release 的 tag 取这里
```

`jsonnet/README.md` 里有详细的「想改什么 → 改哪个文件」对照表，以及所有可配置项说明。

## 许可

皮肤源码基于万象皮肤（作者 BlackCCCat）与空山素影皮肤，遵循原作者的许可条款。
本仓库的改动部分随原皮肤许可一并开放，随便用。
