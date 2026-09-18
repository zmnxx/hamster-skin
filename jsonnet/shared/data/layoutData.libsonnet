// 定义不含功能行时的共享基础布局数据。
//
// 横屏与竖屏用**同一套**按键宽度比例：横屏原本是"左半键盘 + 中间空档 + 右半键盘"
// 的分栏布局，键宽以 784 为分母、和竖屏完全不同一套；改成与竖屏一致的整块布局后
// 分母统一为 1，两个朝向的键位关系（哪个键多宽、占几分之几）完全相同。
local keySizes = {
  '自定义键size': {
    width: {
      percentage: 1 / 8,
    },
  },
  '普通键size': {
    width: {
      percentage: 0.1,
    },
  },
  'a键size和bounds': {
    size: {
      width: {
        percentage: 0.15,
      },
    },
    bounds: {
      width: '2/3',
      alignment: 'right',
    },
  },
  'l键size和bounds': {
    size: {
      width: {
        percentage: 0.15,
      },
    },
    bounds: {
      width: '2/3',
      alignment: 'left',
    },
  },
  // t / y 键只在分栏布局里需要特殊尺寸（各自贴住半边键盘的内侧边缘）。
  // 整块布局下它们就是普通字母键，这两项保留是因为 letters.libsonnet 的
  // 'y' 模板在非竖屏分支会读它。
  't键size和bounds': {
    size: {
      width: {
        percentage: 0.1,
      },
    },
    bounds: {},
  },
  'y键size和bounds': {
    size: {
      width: {
        percentage: 0.1,
      },
    },
    bounds: {},
  },
  'shift键size': {
    width: {
      percentage: 0.15,
    },
  },
  'backspace键size': {
    width: {
      percentage: 0.15,
    },
  },
  'en2cn键size': {
    width: {
      percentage: 0.1,
    },
  },
  'cn2en键size': {
    width: {
      percentage: 0.1,
    },
  },
  'spaceLeft键size': {
    width: {
      percentage: 0.1,
    },
  },
  '123键size': {
    width: {
      percentage: 0.2,
    },
  },
  'ipad123键size': {
    width: {
      percentage: 0.1,
    },
  },
  'next键size': {
    width: {
      percentage: 0.1,
    },
  },
  'space键size': {
    width: {
      percentage: 0.4,
    },
  },
  // 分栏布局遗留的两个半宽空格。整块布局只用 space键size，
  // 这两项保留供 systemKeysSpace 里的 spaceFirst / spaceSecond 读取
  // （那两个键已不在任何布局里，只是样式仍会生成）。
  'spaceFirst键size': {
    width: {
      percentage: 0.4,
    },
  },
  'spaceSecond键size': {
    width: {
      percentage: 0.4,
    },
  },
  'spaceRight键size': {
    width: {
      percentage: 0.1,
    },
  },
  'enter键size': {
    width: {
      percentage: 0.2,
    },
  },
};

{
  getKeyboardLayout(theme):: {
    '竖屏按键尺寸': keySizes,
    '横屏按键尺寸': keySizes,
  },
}
