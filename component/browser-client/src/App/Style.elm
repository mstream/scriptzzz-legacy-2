module App.Style exposing (btn, flexCol, flexRow)

import Css
import Tailwind.Utilities as TwUtil


flexCol : Css.Style
flexCol =
    Css.batch [ TwUtil.flex, TwUtil.flex_col ]


flexRow : Css.Style
flexRow =
    Css.batch [ TwUtil.flex, TwUtil.flex_row ]


btn : Css.Style
btn =
    Css.batch
        [ flexRow
        , TwUtil.justify_between
        , TwUtil.h_10
        , TwUtil.px_6
        , TwUtil.py_2
        , TwUtil.border
        , TwUtil.border_solid
        , TwUtil.border_brand_500
        , TwUtil.text_brand_500
        , Css.hover [ TwUtil.text_white ]
        , TwUtil.bg_white
        , Css.hover [ TwUtil.bg_brand_500 ]
        , TwUtil.no_underline
        ]
