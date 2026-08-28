// 定义符号键盘配置，左侧分类标签 + 右侧符号网格 + 底部控制栏。
local Settings = import '../../Custom.libsonnet';
local center = import '../../shared/styles/center.libsonnet';
local color = import '../../shared/styles/color.libsonnet';
local fontSize = import '../../shared/styles/fontSize.libsonnet';
local styleFactories = import '../../shared/styles/styleFactories.libsonnet';
local others = import '../../shared/styles/others.libsonnet';
local animation = import '../../shared/styles/animation.libsonnet';
local toolbar = import '../../shared/toolbar/iPhone.libsonnet';
local keycap = import '../../shared/styles/keycap.libsonnet';

// 符号分类数据源
local symbolDataSource = {
  category: ['常用', '中文', '英文', '数学', '角标', '序号', '音标', '平假', '片假', '箭头', '特殊', '拼音', '注音', '竖标', '部首', '俄文', '希腊', '拉丁', '制表', '表情'],
  '常用': ['，', '。', '？', '！', '、', '.', '……', '：', '>', '@'],
  '中文': ['《》', '‘’', '〈〉', '·', '-', 'ˉ', 'ˇ', '¨', '々', '‖', '∶', '＂', '＇', '｀', '｜', '〃', '〔〕', '「」', '『』', '．', '〖〗', '【】', '［］', '｛｝', '：', '；', '（）', '——', '“”', '……', '～', '、', '？', '！', '，', '。'],
  '英文': [',', '.', '?', '!', ':', '/', '@', '"', ';', "'", '~', '()', '<>', '[]', '{}', '*', '&', '`', '#', '%', '^', '_', '+', '-', '=', '{', '}', '|', '¥', '£', '€', '–', '¢', '฿'],
  '数学': ['=', '+', '-', '·', '/', '×', '÷', '^', '＞', '＜', '≥', '≤', '≡', '≠', '≈', '±', '√', 'π', '%', '‰', '½', '⅓', '⅔', '¼', '¾', '∵', '∴', '∈', '∉', '∅', '⊂', '⊃', '⊆', '⊇', '∩', '∪', '∧', '∨', '⊙', '⊕', '∥', '⊥', '∠', '△', '∞', '°', '℃', '℉', '∑', '∏', '∫', '∮', '∂', '∀', '∃'],
  '角标': ['º', '⁰', '¹', '²', '³', '⁴', '⁵', '⁶', '⁷', '⁸', '⁹', 'ⁱ', '⁺', '⁻', '⁼', '⁽', '⁾', 'ˣ', 'ʸ', 'ⁿ', '₀', '₁', '₂', '₃', '₄', '₅', '₆', '₇', '₈', '₉', '₊', '₋', '₌', '₍', '₎', 'ₐ', 'ₑ', 'ₒ', 'ₓ', 'ₔ'],
  '序号': ['①', '②', '③', '④', '⑤', '⑥', '⑦', '⑧', '⑨', '⑩', '❶', '❷', '❸', '❹', '❺', '❻', '❼', '❽', '❾', '❿', '⒈', '⒉', '⒊', '⒋', '⒌', '⒍', '⒎', '⒏', '⒐', '⒑', '壹', '贰', '叁', '肆', '伍', '陆', '柒', '捌', '玖', '拾', 'ⅰ', 'ⅱ', 'ⅲ', 'ⅳ', 'ⅴ', 'Ⅰ', 'Ⅱ', 'Ⅲ', 'Ⅳ', 'Ⅴ'],
  '音标': ['ɑː', 'ɔː', 'ɜː', 'iː', 'uː', 'ʌ', 'ɒ', 'ə', 'ɪ', 'ʊ', 'e', 'æ', 'eɪ', 'aɪ', 'ɔɪ', 'ɪə', 'eə', 'ʊə', 'əʊ', 'aʊ', 'p', 't', 'k', 'f', 'θ', 's', 'b', 'd', 'g', 'v', 'ð', 'z', 'ʃ', 'h', 'ts', 'tʃ', 'j', 'tr', 'ʒ', 'r', 'dz', 'dʒ', 'dr', 'w', 'm', 'n', 'ŋ', 'l'],
  '平假': ['あ', 'い', 'う', 'え', 'お', 'ぁ', 'ぃ', 'ぅ', 'ぇ', 'ぉ', 'か', 'き', 'く', 'け', 'こ', 'が', 'ぎ', 'ぐ', 'げ', 'ご', 'さ', 'し', 'す', 'せ', 'そ', 'ざ', 'じ', 'ず', 'ぜ', 'ぞ', 'た', 'ち', 'つ', 'て', 'と', 'だ', 'ぢ', 'づ', 'で', 'ど', 'っ', 'な', 'に', 'ぬ', 'ね', 'の', 'は', 'ひ', 'ふ', 'へ', 'ほ', 'ば', 'び', 'ぶ', 'べ', 'ぼ', 'ぱ', 'ぴ', 'ぷ', 'ぺ', 'ぽ', 'ま', 'み', 'む', 'め', 'も', 'や', 'ゆ', 'よ', 'ゃ', 'ゅ', 'ょ', 'ら', 'り', 'る', 'れ', 'ろ', 'わ', 'を', 'ん', 'ゎ'],
  '片假': ['ア', 'イ', 'ウ', 'エ', 'オ', 'ァ', 'ィ', 'ゥ', 'ェ', 'ォ', 'カ', 'キ', 'ク', 'ケ', 'コ', 'ガ', 'ギ', 'グ', 'ゲ', 'ゴ', 'サ', 'シ', 'ス', 'セ', 'ソ', 'ザ', 'ジ', 'ズ', 'ゼ', 'ゾ', 'タ', 'チ', 'ツ', 'テ', 'ト', 'ダ', 'ヂ', 'ヅ', 'デ', 'ド', 'ッ', 'ナ', 'ニ', 'ヌ', 'ネ', 'ノ', 'ハ', 'ヒ', 'フ', 'ヘ', 'ホ', 'バ', 'ビ', 'ブ', 'ベ', 'ボ', 'パ', 'ピ', 'プ', 'ペ', 'ポ', 'マ', 'ミ', 'ム', 'メ', 'モ', 'ヤ', 'ユ', 'ヨ', 'ャ', 'ュ', 'ョ', 'ラ', 'リ', 'ル', 'レ', 'ロ', 'ワ', 'ヲ', 'ン', 'ヮ'],
  '箭头': ['→', '←', '↑', '↓', '↖', '↗', '↙', '↘', '↔', '↕', '⇞', '⇟', '⇆', '⇅', '⇔', '⇕', '↰', '↱', '↲', '↴', '↶', '↷', '↺', '↻', '↜', '↝', '↞', '↟', '↠', '↡', '➺', '➻', '➼', '➳', '➽', '➸', '➹', '➷', '➠', '↣', '☞', '☜', '☟', '⇦', '⇧', '⇨', '⇩', '⇪', '➩', '➪', '➫', '➬', '➯', '➱', '➮', '➭', '➡', '➢', '➣', '➤', '➥', '➦', '➧', '➨'],
  '特殊': ['△', '▽', '○', '◇', '□', '☆', '▷', '◁', '♤', '♡', '♢', '♧', '▲', '▼', '●', '◆', '■', '★', '▶', '◀', '♠', '♥', '♦', '♣', '囍', '☼', '☽', '☺', '◐', '☑', '√', '✔', '☀', '☾', '♂', '☹', '◑', '×', '✕', '✘', '☚', '☛', '▪', '•', '‥', '…', '▁', '▂', '▃', '▄', '▅', '▆', '▇', '█', '∷', '※', '░', '▒', '▓', '♩', '♪', '♫', '♬', '§', '◎', '¤', '℗', '®', '©', '♭', '♯', '♮', '‖', '¶', '卍', '卐', '▬', '〓', '℡', '™', '㉿', '◕', '@', '№', '♈', '♉', '♊', '♋', '♌', '♍', '♎', '♏', '♐', '♑', '♒', '♓', '☯', '*', '＊', '✲', '❈', '❉', '✿', '❀', '❃', '❁', '☸', '✖', '✚', '✪', '❤', 'ღ', '❦', '❧', '₪', '✎', '✍', '✌', '☁', '☂', '☃', '☄', '♨', '☇', '☈', '☎', '✈', '✄', '✁', '✃', '❥', '☒', '❅', '✣', '✰', '⚀', '⚁', '⚂', '⚃', '⚄', '⚅'],
  '拼音': ['ā', 'á', 'ǎ', 'à', 'ō', 'ó', 'ǒ', 'ò', 'ē', 'é', 'ě', 'è', 'ī', 'í', 'ǐ', 'ì', 'ū', 'ú', 'ǔ', 'ù', 'ǖ', 'ǘ', 'ǚ', 'ǜ', 'ü'],
  '注音': ['ㄅ', 'ㄆ', 'ㄇ', 'ㄈ', 'ㄉ', 'ㄊ', 'ㄋ', 'ㄌ', 'ㄍ', 'ㄎ', 'ㄏ', 'ㄐ', 'ㄑ', 'ㄒ', 'ㄓ', 'ㄔ', 'ㄕ', 'ㄖ', 'ㄗ', 'ㄘ', 'ㄙ', 'ㄧ', 'ㄨ', 'ㄩ', 'ㄚ', 'ㄛ', 'ㄜ', 'ㄝ', 'ㄞ', 'ㄟ', 'ㄠ', 'ㄡ', 'ㄢ', 'ㄣ', 'ㄤ', 'ㄥ', 'ㄦ'],
  '竖标': ['︐', '︑', '︒', '︓', '︔', '︕', '︖', '︵', '︶', '︷', '︸', '︹', '︺', '︿', '﹀', '︽', '︾', '﹁', '﹂', '﹃', '﹄', '︻', '︼', '︗', '︘', '_', '¯', '＿', '￣', '﹏', '﹋', '﹍', '﹉', '﹎', '﹊', '¦', '︴', '¡', '¿', '^', 'ˇ', '¨', 'ˊ'],
  '部首': ['丨', '亅', '丿', '乛', '一', '乙', '乚', '丶', '八', '勹', '匕', '冫', '卜', '厂', '刀', '刂', '儿', '二', '匚', '阝', '丷', '几', '卩', '冂', '力', '冖', '凵', '人', '亻', '入', '十', '厶', '亠', '匸', '讠', '廴', '又', '艹', '屮', '彳', '巛', '川', '辶', '寸', '大', '飞', '干', '工', '弓', '廾', '广', '己', '彐', '彑', '巾', '口', '马', '门', '宀', '女', '犭', '山', '彡', '尸', '饣', '士', '扌', '氵', '纟', '巳', '土', '囗', '兀', '夕', '小', '忄', '幺', '弋', '尢', '夂', '子', '贝', '比', '灬', '长', '车', '歹', '斗', '厄', '方', '风', '父', '戈', '卝', '户', '火', '旡', '见', '斤', '耂', '毛', '木', '肀', '牛', '牜', '爿', '片', '攴', '攵', '气', '欠', '犬', '日', '氏', '礻', '手', '殳', '水', '瓦', '尣', '王', '韦', '文', '毋', '心', '牙', '爻', '曰', '月', '爫', '支', '止', '爪', '白', '癶', '歺', '甘', '瓜', '禾', '钅', '立', '龙', '矛', '皿', '母', '目', '疒', '鸟', '皮', '生', '石', '矢', '示', '罒', '田', '玄', '穴', '疋', '业', '衤', '用', '玉', '耒'],
  '俄文': ['а', 'б', 'в', 'г', 'д', 'е', 'ё', 'ж', 'з', 'и', 'й', 'к', 'л', 'м', 'н', 'о', 'п', 'р', 'с', 'т', 'у', 'ф', 'х', 'ц', 'ч', 'ш', 'щ', 'ъ', 'ы', 'ь', 'э', 'ю', 'я', 'А', 'Б', 'В', 'Г', 'Д', 'Е', 'Ё', 'Ж', 'З', 'И', 'Й', 'К', 'Л', 'М', 'Н', 'О', 'П', 'Р', 'С', 'Т', 'У', 'Ф', 'Х', 'Ц', 'Ч', 'Ш', 'Щ', 'Ъ', 'Ы', 'Ь', 'Э', 'Ю', 'Я'],
  '希腊': ['Α', 'Β', 'Γ', 'Δ', 'Ε', 'Ζ', 'Η', 'Θ', 'Ι', 'Κ', 'Λ', 'Μ', 'Ν', 'Ξ', 'Ο', 'Π', 'Ρ', 'Σ', 'Τ', 'Υ', 'Φ', 'Χ', 'Ψ', 'Ω', 'α', 'β', 'γ', 'δ', 'ε', 'ζ', 'η', 'θ', 'ι', 'κ', 'λ', 'μ', 'ν', 'ξ', 'ο', 'π', 'ρ', 'σ', 'τ', 'υ', 'φ', 'χ', 'ψ', 'ω'],
  '拉丁': ['À', 'Á', 'Â', 'Ã', 'Ä', 'Å', 'Ā', 'Æ', 'Ç', 'È', 'É', 'Ê', 'Ë', 'Ē', 'Ì', 'Í', 'Î', 'Ï', 'Ī', 'Ð', 'Ñ', 'Ò', 'Ó', 'Ô', 'Õ', 'Ö', 'Ō', 'Ø', 'Œ', 'Ù', 'Ú', 'Û', 'Ü', 'Ū', 'Ý', 'Ÿ', 'Þ', 'Š', 'à', 'á', 'â', 'ã', 'ä', 'å', 'æ', 'ç', 'è', 'é', 'ê', 'ë', 'ē', 'ì', 'í', 'î', 'ï', 'ī', 'ð', 'ñ', 'ò', 'ó', 'ô', 'õ', 'ö', 'ō', 'ø', 'œ', 'ù', 'ú', 'û', 'ü', 'ū', 'ý', 'þ', 'š', 'ÿ'],
  '制表': ['┝', '┞', '┟', '┠', '┡', '┢', '═', '╞', '╟', '╡', '╢', '╪', '┭', '┮', '┯', '┰', '┱', '┲', '║', '╤', '╥', '╧', '╨', '╫', '┥', '┦', '┧', '┨', '┩', '┪', '┽', '┾', '┿', '╀', '╁', '╂', '┵', '┶', '┷', '┸', '┹', '┺', '╄', '╅', '╆', '╇', '╈', '╉', '┈', '┉', '┊', '┋', '╃', '╊', '┍', '┑', '┕', '┙', '┎', '┒', '┖', '┚', '╒', '╕', '╘', '╛', '╓', '╖', '╙', '╜', '┄', '┅', '┆', '┇', '┌', '┬', '┐', '├', '┼', '┤', '└', '┴', '┘', '┏', '┳', '┓', '┣', '╋', '┫', '┗', '┻', '┛', '╔', '╦', '╗', '╠', '╬', '╣', '╚', '╩', '╝'],
  '表情': [':-D', ':-)', ':-(', ':-P', ':-O', ';-)', '(⌒▽⌒)', '(｡◕‿◕｡)', '(◕‿◕✿)', '(◠‿◠)', '(✿◠‿◠)', '(>‿◠)✌', '(∩_∩)', '(｡♥‿♥｡)', "(●'◡'●)", 'ಥ‿ಥ', '(✖╭╮✖)', '(╥_╥)', '(╯°□°)╯', '(；一_一)', '(--;)', '(￣▽￣*)ゞ', '(＾▽＾)', '(⊙ω⊙)', '(°ー°〃)', '(´･･)', '(｀_´)ゞ', '(・∀・)', '(￣ω￣)', '(｀・ω・´)', '(´･ω･)', 'o(≧▽≦)o', 'ヽ(✿ﾟ▽ﾟ)ノ', '(=^･ω･^=)', '(◕ᴗ◕✿)', '(っ˘ω˘ς)', '╮(╯▽╰)╭', '╮(╯_╰)╭', '(ㆆᴗㆆ)', 'ᕙ(⇀‸↼‶)ᕗ', '(●ˇ∀ˇ●)'],
};

local keyboard(theme, orientation) =
  local makeButtonBackground(normalKey, highlightKey) =
    keycap.buttonBackground(
      theme, orientation, Settings, color, normalKey, highlightKey,
      { top: 2, left: 2, bottom: 2, right: 2 }
    );
  local makeTextForegroundStyle(textValue) = {
    buttonStyleType: 'text',
    text: textValue,
    normalColor: color[theme]['按键前景颜色'],
    highlightColor: color[theme]['按键前景颜色'],
    fontSize: fontSize['按键前景文字大小'] - 3,
    center: center['功能键前景文字偏移'],
  };
  toolbar.getToolBar(theme) +
  symbolDataSource +
  {
    preeditHeight: others[if orientation == 'portrait' then '竖屏' else '横屏']['preedit高度'],
    toolbarHeight: others[if orientation == 'portrait' then '竖屏' else '横屏']['toolbar高度'],
    keyboardHeight: others[if orientation == 'portrait' then '竖屏' else '横屏']['keyboard高度'],

    keyboardStyle: {
      size: {
        height: { percentage: 0.73 },
      },
      insets: { top: 3, bottom: 3, left: 4, right: 4 },
      backgroundStyle: 'keyboardBackgroundStyle',
    },
    keyboardBackgroundStyle:
      if std.objectHas(Settings, 'background_image') && Settings.background_image.enabled
      then styleFactories.makeFileImageStyle(Settings.background_image.keyboard)
      else styleFactories.makeGeometryStyle(color[theme]['键盘背景颜色']),
    keyboardLayout: [
      {
        HStack: {
          style: 'symbolTopRowStyle',
          subviews: [
            { Cell: 'categoryCollection' },
            { Cell: 'descriptionCollection' },
          ],
        },
      },
      {
        HStack: {
          style: 'symbolBottomRowStyle',
          subviews: [
            { Cell: 'symbolReturnButton' },
            { Cell: 'pageUpButton' },
            { Cell: 'pageDownButton' },
            { Cell: 'lockButton' },
            { Cell: 'symbolBackspaceButton' },
          ],
        },
      },
    ],
    symbolTopRowStyle: {
      size: { height: '227/281' },
    },
    symbolBottomRowStyle: {
      size: { height: '54/281' },
    },

    // 左侧分类列表
    categoryCollection: {
      type: 'classifiedSymbols',
      size: { width: '56/375' },
      insets: { top: 4, bottom: 4 },
      backgroundStyle: 'categoryCollectionBackgroundStyle',
      dataSource: 'category',
      cellStyle: 'categoryCollectionCellStyle',
      separatorLineColor: color[theme]['符号区分隔线颜色'],
    },
    categoryCollectionBackgroundStyle: styleFactories.makeGeometryStyle(color[theme]['符号键盘左侧collection背景颜色'], {
      // 与九宫格 / 数字键盘的符号栏同处理：圆角跟键帽走
      cornerRadius: keycap.panelRadius(Settings),
    }),
    categoryCollectionCellStyle: {
      foregroundStyle: 'categoryCollectionCellForegroundStyle',
    },
    categoryCollectionCellForegroundStyle: {
      buttonStyleType: 'text',
      normalColor: color[theme]['列表未选中字体颜色'],
      highlightColor: color[theme]['列表选中字体颜色'],
      fontSize: fontSize['符号键盘左侧collection前景字体大小'],
      fontWeight: 'medium',
    },

    // 右侧符号网格
    descriptionCollection: {
      type: 'subClassifiedSymbols',
      size: { width: '319/375' },
      insets: { top: 8, bottom: 8, left: 8, right: 8 },
      backgroundStyle: 'descriptionCollectionBackgroundStyle',
      cellStyle: 'descriptionCollectionCellStyle',
      displaySeparatorLine: false,
      maximumRow: 5,
    },
    descriptionCollectionBackgroundStyle: styleFactories.makeGeometryStyle(color[theme]['符号键盘右侧collection背景颜色'], {
      cornerRadius: keycap.panelRadius(Settings),
    }),
    descriptionCollectionCellStyle: {
      backgroundStyle: 'descriptionCollectionCellBackgroundStyle',
      foregroundStyle: 'descriptionCollectionCellForegroundStyle',
    },
    descriptionCollectionCellBackgroundStyle: styleFactories.makeGeometryStyle('ffffff00', {
      highlightColor: color[theme]['字母键背景颜色-普通'],
      cornerRadius: Settings.cornerRadius,
    }),
    descriptionCollectionCellForegroundStyle: {
      buttonStyleType: 'text',
      normalColor: color[theme]['列表未选中字体颜色'],
      highlightColor: color[theme]['列表选中字体颜色'],
      fontSize: fontSize['符号键盘右侧collection前景字体大小'],
      badgeNormalColor: color[theme]['列表未选中字体颜色'],
      badgeHighlightColor: color[theme]['列表选中字体颜色'],
      badgeFontSize: fontSize['符号键盘右侧collection前景字体大小'] - 4,
    },

    // 底部控制按钮
    symbolReturnButton: {
      size: { width: '56/375' },
      backgroundStyle: 'systemButtonBackgroundStyle',
      foregroundStyle: 'symbolReturnButtonForegroundStyle',
      // 与 123 键盘的返回键一致：固定回中文主键盘。
      // returnLastKeyboard 会回到「上一个用过的键盘」，从英文键盘进符号再返回
      // 就落回英文，同一个键去向不定。
      action: { keyboardType: 'pinyin' },
      animation: keycap.animationNames(Settings),
    },
    symbolReturnButtonForegroundStyle: makeTextForegroundStyle('返回'),

    pageUpButton: {
      size: { width: '87/375' },
      backgroundStyle: 'systemButtonBackgroundStyle',
      foregroundStyle: 'pageUpButtonForegroundStyle',
      action: { shortcut: '#subCollectionPageUp' },
      animation: keycap.animationNames(Settings),
    },
    pageUpButtonForegroundStyle: makeTextForegroundStyle('上页'),

    pageDownButton: {
      size: { width: '87/375' },
      backgroundStyle: 'systemButtonBackgroundStyle',
      foregroundStyle: 'pageDownButtonForegroundStyle',
      action: { shortcut: '#subCollectionPageDown' },
      animation: keycap.animationNames(Settings),
    },
    pageDownButtonForegroundStyle: makeTextForegroundStyle('下页'),

    lockButton: {
      size: { width: '87/375' },
      backgroundStyle: 'systemButtonBackgroundStyle',
      foregroundStyle: [
        { styleName: 'unlockButtonForegroundStyle', conditionKey: '$symbolicKeyboardLockState', conditionValue: false },
        { styleName: 'lockButtonForegroundStyle', conditionKey: '$symbolicKeyboardLockState', conditionValue: true },
      ],
      action: 'symbolicKeyboardLockStateToggle',
      animation: keycap.animationNames(Settings),
    },
    lockButtonForegroundStyle: makeTextForegroundStyle('锁定'),
    unlockButtonForegroundStyle: makeTextForegroundStyle('解锁'),

    symbolBackspaceButton: {
      size: { width: '60/375' },
      backgroundStyle: 'systemButtonBackgroundStyle',
      foregroundStyle: 'symbolBackspaceButtonForegroundStyle',
      action: 'backspace',
      repeatAction: 'backspace',
      animation: keycap.animationNames(Settings),
    },
    symbolBackspaceButtonForegroundStyle: makeTextForegroundStyle('删除'),

    systemButtonBackgroundStyle: makeButtonBackground('功能键背景颜色-普通', '功能键背景颜色-高亮'),
  } + keycap.animationRegistry(Settings, animation);

{
  new(theme, orientation):
    keyboard(theme, orientation),
}
