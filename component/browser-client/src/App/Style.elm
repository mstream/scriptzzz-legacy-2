module App.Style exposing (flexCol, flexRow)

import Css
import Tailwind.Utilities as TwUtil


flexCol : Css.Style
flexCol =
    Css.batch [ TwUtil.flex, TwUtil.flex_col ]


flexRow : Css.Style
flexRow =
    Css.batch [ TwUtil.flex, TwUtil.flex_row ]
