// 暴露数字 9 键入口，衔接共享上下文与构建逻辑。
local Settings = import '../../Custom.libsonnet';
local keyboardRuntime = import '../../keyboards/common/layoutAssembly/keyboardLayoutAssembly.libsonnet';
local numeric9Builder = import 'builder.libsonnet';
local numeric9Layout = import 'layout.libsonnet';

local moduleForDevice(deviceType, swapped=null) = {
  keyboard(theme, orientation):
    local context = keyboardRuntime.new(Settings, theme, orientation, deviceType);
    // 横竖屏用同一份布局，观感一致。
    // swapped 显式传入时覆盖 Custom 的对调开关，用来单独出「全拼进 123」那份。
    numeric9Builder.build(context, numeric9Layout.layout(swapped)),
  new(theme, orientation):
    self.keyboard(theme, orientation),
};

moduleForDevice('iPhone') + {
  layout(deviceType, swapped=null): moduleForDevice(deviceType, swapped),
}
