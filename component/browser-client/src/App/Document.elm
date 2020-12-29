module App.Document exposing (view)

import App.Model as AppModel
import App.Page.Home as AppPageHome
import App.Page.NotFound as AppPageNotFound
import App.Page.Redirection as AppPageRedirection
import App.Page.SignIn as AppPageSignIn
import App.Style as AppStyle
import App.Svg as AppSvg
import Browser
import Css
import Html.Styled as Html exposing (Html)
import Html.Styled.Attributes as HtmlAttr
import Tailwind.Utilities as TwUtil


headerShadowStyle : Float -> Css.Style
headerShadowStyle viewportOffsetTop =
    if viewportOffsetTop < 1 then
        TwUtil.shadow_none

    else if viewportOffsetTop < 3 then
        TwUtil.shadow_sm

    else if viewportOffsetTop < 5 then
        TwUtil.shadow_base

    else
        TwUtil.shadow_md


footerShadowStyle : Float -> Css.Style
footerShadowStyle viewportOffsetBottom =
    if viewportOffsetBottom < 1 then
        TwUtil.shadow_none

    else if viewportOffsetBottom < 3 then
        TwUtil.neg_shadow_sm

    else if viewportOffsetBottom < 5 then
        TwUtil.neg_shadow_base

    else
        TwUtil.neg_shadow_md


viewHeader : Css.Style -> Float -> Html msg
viewHeader heightStyle viewportOffsetTop =
    let
        headerStyle : Css.Style
        headerStyle =
            Css.batch
                [ heightStyle
                , headerShadowStyle viewportOffsetTop
                , AppStyle.flexRow
                , TwUtil.fixed
                , TwUtil.justify_between
                , TwUtil.w_screen
                , TwUtil.text_2xl
                , TwUtil.text_white
                , TwUtil.bg_brand_500
                ]
    in
    Html.header
        []
        [ Html.div
            [ HtmlAttr.css [ headerStyle ] ]
            [ AppSvg.logoIcon, Html.text "I am a header", AppSvg.menu ]
        , Html.div [ HtmlAttr.css [ heightStyle ] ] []
        ]


viewContent : AppModel.Model -> Html msg
viewContent model =
    let
        content =
            case model.page of
                AppModel.Home ->
                    AppPageHome.view

                AppModel.NotFound ->
                    AppPageNotFound.view

                AppModel.Redirection ->
                    AppPageRedirection.view

                AppModel.SignIn pageModel ->
                    AppPageSignIn.view model pageModel
    in
    Html.div [ HtmlAttr.css [ TwUtil.h_64 ] ] [ content ]


viewFooter : Css.Style -> Float -> Html msg
viewFooter heightStyle viewportOffsetBottom =
    let
        footerStyle : Css.Style
        footerStyle =
            Css.batch
                [ heightStyle
                , footerShadowStyle viewportOffsetBottom
                , AppStyle.flexRow
                , TwUtil.fixed
                , TwUtil.bottom_0
                , TwUtil.w_screen
                , TwUtil.justify_between
                , TwUtil.text_lg
                , TwUtil.text_gray_100
                , TwUtil.bg_gray_300
                ]
    in
    Html.footer
        []
        [ Html.div
            [ HtmlAttr.css [ footerStyle ] ]
            [ Html.text "I am a footer" ]
        , Html.div [ HtmlAttr.css [ heightStyle ] ] []
        ]


viewBody : AppModel.Model -> List (Html msg)
viewBody model =
    case model.windowViewport of
        Nothing ->
            []

        Just winViewport ->
            [ viewHeader TwUtil.h_8 winViewport.viewport.y
            , viewContent model
            , viewFooter TwUtil.h_8 <|
                winViewport.scene.height
                    - winViewport.viewport.height
                    - winViewport.viewport.y
            ]


view : AppModel.Model -> Browser.Document msg
view model =
    let
        pageTitle =
            case model.page of
                AppModel.Home ->
                    "Home"

                AppModel.NotFound ->
                    "Not Found"

                AppModel.Redirection ->
                    "Redirecting..."

                AppModel.SignIn _ ->
                    "Sign In"
    in
    { body = viewBody model |> List.map Html.toUnstyled
    , title =
        "Scriptzzz | " ++ pageTitle
    }
