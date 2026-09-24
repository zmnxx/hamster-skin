// 工具栏共享辅助模块：读取 Custom 里的工具栏配置、过滤非法按钮 ID、
// 生成布局用的 Cell 与滑动区数据源项。
{
  searchOpenURLMap: {
    google: 'https://www.google.com/search?q=#pasteboardContent',
    baidu: 'https://www.baidu.com/s?wd=#pasteboardContent',
    bing: 'https://www.bing.com/search?q=#pasteboardContent',
  },

  searchStyleNameMap: {
    google: 'toolbarButtonGoogleStyle',
    baidu: 'toolbarButtonBaiduStyle',
    bing: 'toolbarButtonBingStyle',
  },

  getToolbarConfig(Settings)::
    if std.objectHas(Settings, 'toolbar_config') then Settings.toolbar_config else {},

  // overrides 由各键盘 builder 传入（英文键盘把切换目标改成 pinyin）。
  getSwitchKeyboardType(overrides)::
    if std.type(overrides) == 'object' && std.objectHas(overrides, 'switchKeyboardType')
    then overrides.switchKeyboardType else 'alphabetic',

  getSwitchKeyboardAsset(overrides)::
    if std.type(overrides) == 'object' && std.objectHas(overrides, 'switchKeyboardAsset')
    then overrides.switchKeyboardAsset else 'chineseState',

  getToolbarMenu(toolbarConfig)::
    if std.objectHas(toolbarConfig, 'toolbar_menu') then toolbarConfig.toolbar_menu else false,

  getIpadToolbarConfig(toolbarConfig)::
    if std.objectHas(toolbarConfig, 'ipad') then toolbarConfig.ipad else {},

  // iPad 未单独配 toolbar_menu 时回落到 iPhone 那一项。
  getIpadToolbarMenu(toolbarConfig)::
    local ipadToolbarConfig = self.getIpadToolbarConfig(toolbarConfig);
    if std.objectHas(ipadToolbarConfig, 'toolbar_menu') then ipadToolbarConfig.toolbar_menu
    else self.getToolbarMenu(toolbarConfig),

  getToolbarId(registry, value, fallback)::
    if std.type(value) == 'string' && std.objectHas(registry, value) then value else fallback,

  // 过滤掉 registry 里不存在的按钮 ID；全部非法时用 fallback。
  // dedupe 供 fixed 布局使用 —— 那一档按钮全部常驻，重复 ID 会画出两个相同的键。
  getToolbarIds(registry, values, fallback, dedupe=false)::
    local source = if std.type(values) == 'array' then values else fallback;
    local filtered = [
      value
      for value in source
      if std.type(value) == 'string' && std.objectHas(registry, value)
    ];
    local normalized =
      if dedupe then
        std.foldl(
          function(acc, id) if std.member(acc, id) then acc else acc + [id],
          filtered,
          []
        )
      else filtered;
    if std.length(normalized) > 0 then normalized else fallback,

  // 固定按钮布局只需要 Cell 名称，真正的 action 由对应样式对象提供。
  makeToolbarCell(registry, id)::
    { Cell: registry[id].cellName },

  // 滑动按钮不读样式对象里的 action，数据源中单独写入 registry 提供的 action。
  makeSlideItem(registry, id, index):: {
    label: std.toString(index),
    action: registry[id].action,
    styleName: registry[id].slideStyleName,
  },
}
