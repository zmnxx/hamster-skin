// 暴露数字 9 键入口，衔接共享上下文与构建逻辑。
local Settings = import '../../Custom.libsonnet';
local keyboardRuntime = import '../../keyboards/common/layoutAssembly/keyboardLayoutAssembly.libsonnet';
local numeric9Builder = import 'builder.libsonnet';
local numeric9Layout = import 'layout.libsonnet';

local moduleForDevice(deviceType) = {
  keyboard(theme, orientation):
    local context = keyboardRuntime.new(Settings, theme, orientation, deviceType);
    // 横竖屏用同一份布局，观感一致。
    numeric9Builder.build(context, numeric9Layout.Layout),
  new(theme, orientation):
    self.keyboard(theme, orientation),
};

moduleForDevice('iPhone') + {
  layout(deviceType): moduleForDevice(deviceType),
}
