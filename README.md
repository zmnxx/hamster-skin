# hamster-skin

元书输入法（Hamster3）皮肤的**云端编译中转仓库**。

## 用途

iOS 上的 iSH 跑 jsonnet 太慢（单个键盘入口 25~30 秒，全量 10 分钟以上），
所以皮肤编译放到 GitHub Actions 上跑。

Actions → `build-skin` → Run workflow，填入皮肤名，跑完在运行页底部
Artifacts 下载 `.cskin`。

## 本仓库不存放皮肤

源码是每次任务临时推上来的，编译完取回产物后立即删除。
仓库常态只有这份说明和 `.github/workflows/`。

如果你看到仓库里有 `jsonnet/`、`resources/` 之类的目录，说明上一次任务没有
清理完，那些内容不代表任何一款正式皮肤。
