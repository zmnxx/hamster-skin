// 万象原有的按键缩放动画。
//
// 功能行按钮（左移/行首/复制…）引用的是这个，不要改动它，
// 否则会连带改掉功能行的按压手感。
//
// 键帽自己的按下动效（缩放 + 光晕 + 涟漪）在 keycap.libsonnet 里定义，
// 名字是 KeycapPressAnimation / KeycapGlowAnimation / KeycapRippleAnimation。
{
  '26键按键动画': {
    animationType: 'scale',
    isAutoReverse: true,
    scale: 0.87,
    pressDuration: 60,
    releaseDuration: 80,
  },
}
