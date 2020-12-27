module App.Svg exposing (logoFull, logoIcon, menu)

import Svg.Styled as Svg exposing (Svg)
import Svg.Styled.Attributes as SvgAttr
import Tailwind.Utilities as TwUtils


make : Int -> Int -> String -> Svg msg
make width height path =
    Svg.svg
        [ SvgAttr.css [ TwUtils.h_full, TwUtils.fill_current ]
        , SvgAttr.viewBox <| "0 0 " ++ String.fromInt width ++ " " ++ String.fromInt height
        ]
        [ Svg.path [ SvgAttr.d path ] [] ]


makeLogo : Int -> Svg msg
makeLogo width =
    make width 40 "M133.1 14.2h13.7v2.6L136 29.4h10.8v2.3h-14V29l10.7-12.6h-10.4zm-17.3 0h13.6v2.6l-10.8 12.6h10.8v2.3h-14V29l10.8-12.6h-10.4zm-17.3 0H112v2.6l-10.8 12.6h10.8v2.3h-14V29l10.8-12.6H98.5zm-9-5v5h5.9v2.2h-6V26q0 2.2.7 2.8.5.6 2.3.6h3v2.4h-3q-3.3 0-4.6-1.2-1.2-1.3-1.2-4.6v-9.5h-2.1v-2.2h2v-5zm-21 19.9v9.2h-2.8V14.2h2.9v2.6q.9-1.5 2.2-2.3 1.4-.7 3.4-.7 3.1 0 5.1 2.5 2 2.5 2 6.7 0 4-2 6.6-2 2.5-5.1 2.5-2 0-3.4-.7-1.3-.8-2.2-2.3zm9.8-6.1q0-3.2-1.3-5-1.3-1.8-3.5-1.8-2.3 0-3.6 1.8-1.3 1.8-1.3 5 0 3.1 1.3 5 1.3 1.7 3.6 1.7 2.2 0 3.5-1.8 1.3-1.8 1.3-5zm-22-8.8h3v17.5h-3zm0-6.8h3V11h-3zm-3.5 9.5l-1-.4q-.6-.2-1.3-.2-2.4 0-3.7 1.6-1.3 1.6-1.3 4.6v9.2h-3V14.2h3v2.7q.9-1.6 2.3-2.4 1.5-.7 3.6-.7h.6l.8.1zM5 0a5 5 0 00-5 5v30a5 5 0 005 5h30a5 5 0 005-5V5a5 5 0 00-5-5zm6 8A19.5 19.5 0 0117.8 9v3.1c-1.2-.6-2.3-1-3.4-1.3-1-.3-2-.4-3-.4-1.8 0-3 .3-4 1S6 13.1 6 14.3c0 1 .3 1.9 1 2.4.5.5 1.7 1 3.4 1.3l2 .3c2.3.5 4 1.3 5.1 2.4a6.1 6.1 0 011.7 4.6c0 2.2-.7 4-2.2 5a10.7 10.7 0 01-6.7 1.8 26.3 26.3 0 01-7.4-1.5v-3.2c1.3.7 2.5 1.3 3.8 1.6 1.2.4 2.4.6 3.6.6a7 7 0 004.2-1c1-.8 1.4-1.8 1.4-3.1 0-1.2-.3-2-1-2.7a7.2 7.2 0 00-3.5-1.5L9.5 21c-2.4-.5-4-1.2-5.1-2.2-1-1-1.6-2.4-1.6-4.2A6 6 0 015 9.7 9.3 9.3 0 0111 8zm21.1 5.8a12 12 0 015 1v2.7a10.9 10.9 0 00-4.9-1.3c-1.8 0-3.3.6-4.3 1.8a7.3 7.3 0 00-1.6 5c0 2 .6 3.8 1.6 5 1 1.1 2.5 1.7 4.3 1.7a9.5 9.5 0 005-1.3V31a11.8 11.8 0 01-5.3 1.1c-2.6 0-4.7-.8-6.3-2.4a9.4 9.4 0 01-2.3-6.7c0-2.9.8-5.1 2.4-6.8a8.5 8.5 0 016.4-2.4z"


logoFull : Svg msg
logoFull =
    makeLogo 150


logoIcon : Svg msg
logoIcon =
    makeLogo 40


menu : Svg msg
menu =
    make 24 24 "M3 18h18v-2H3v2zm0-5h18v-2H3v2zm0-7v2h18V6H3z"
