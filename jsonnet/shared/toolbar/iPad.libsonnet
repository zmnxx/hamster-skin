// 平板端工具栏入口，读取平板专属配置，并在手机工具栏基础上覆盖平板布局与少量动作。
local Settings = import '../../Custom.libsonnet';
local keycap = import '../styles/keycap.libsonnet';
local toolbarShared = import 'config.libsonnet';
local ipadRenderer = import 'iPadRenderer.libsonnet';
local toolbar = import 'iPhone.libsonnet';
local toolbarRegistryLib = import 'registry.libsonnet';

local toolbarConfig = toolbarShared.getToolbarConfig(Settings);
local ipadToolbarConfig = toolbarShared.getIpadToolbarConfig(toolbarConfig);
local toolbarMenu = toolbarShared.getIpadToolbarMenu(toolbarConfig);

{
  getToolBar(theme, overrides={})::
    local switchKeyboardType = toolbarShared.getSwitchKeyboardType(overrides);
    local ipadToolbarButtonRegistry = toolbarRegistryLib.getIpadRegistry(toolbarMenu, switchKeyboardType);
    // iPad 中间滑动区的按钮列表只保留 registry 中存在的 ID，并完成去重。
    local ipadToolbarItems = toolbarShared.getToolbarIds(
      ipadToolbarButtonRegistry,
      if std.objectHas(ipadToolbarConfig, 'center_slide') then ipadToolbarConfig.center_slide else [],
      [
        'keyboard_settings',
        'keyboard_skins',
        'keyboard_performance',
        'embedding_toggle',
        'rime_switcher',
        'google',
        'safari',
        'apple',
        'script',
        'note',
        'clipboard',
      ],
      true
    );
    local ipadRendererConfig = ipadRenderer.build(toolbarMenu, ipadToolbarItems, ipadToolbarButtonRegistry);
    toolbar.getToolBar(theme, overrides) + {
      horizontalCandidates+: {
        size: { width: '12/13' },
        maxColumns: 12,
      },
      horizontalCandidatesStyle+: {
        insets+: { left: 3, right: 10 },
      },
      // 工具栏胶囊的圆角要跟着 iPad 自己的工具栏高度走。
      // iPhone 那边算的是 (42-6)/2=18，直接拿到 iPad（57pt 高）上圆角就偏小，
      // 读成圆角矩形而不是胶囊。
      toolbarCapsuleBackgroundStyle: keycap.toolbarCapsuleBackground(
        theme,
        Settings,
        (Settings.toolbar_config.ipad.toolbar_height - 6) / 2,
        { top: 3, bottom: 3 }
      ),
      toolbarLayout: ipadRendererConfig.toolbarLayout,

      toolbarSlideButtonsIpadCenter: ipadRendererConfig.toolbarSlideButtonsIpadCenter,
      horizontalSymbolsDataSourceIpadCenter: ipadRendererConfig.horizontalSymbolsDataSourceIpadCenter,
    },
}
