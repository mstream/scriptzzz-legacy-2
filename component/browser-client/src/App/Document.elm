module App.Document exposing (view)

import App.Model as AppModel
import App.Page.Home as AppPageHome
import App.Page.NotFound as AppPageNotFound
import App.Page.SignIn as AppPageSignIn
import App.Style as AppStyle
import App.Svg as AppSvg
import Browser
import Html.Styled as Html exposing (Html)
import Html.Styled.Attributes as HtmlAttr
import Tailwind.Utilities as TwUtil


viewHeader : Html msg
viewHeader =
    let
        headerCss =
            HtmlAttr.css
                [ TwUtil.flex_none
                , AppStyle.flexRow
                , TwUtil.justify_between
                , TwUtil.h_8
                , TwUtil.text_2xl
                , TwUtil.text_white
                , TwUtil.bg_brand_500
                ]
    in
    Html.header
        [ headerCss ]
        [ AppSvg.logoIcon, Html.text "I am a header", AppSvg.menu ]


viewContent : AppModel.Model -> Html msg
viewContent model =
    let
        content =
            case model.page of
                AppModel.Home ->
                    AppPageHome.view

                AppModel.NotFound ->
                    AppPageNotFound.view

                AppModel.SignIn pageModel ->
                    AppPageSignIn.view model pageModel
    in
    Html.div [ HtmlAttr.css [ TwUtil.flex_auto ] ] [ content ]


viewFooter : Html msg
viewFooter =
    let
        footerCss =
            HtmlAttr.css
                [ TwUtil.flex_none
                , AppStyle.flexRow
                , TwUtil.justify_between
                , TwUtil.h_8
                , TwUtil.text_lg
                , TwUtil.text_gray_100
                , TwUtil.bg_gray_300
                ]
    in
    Html.footer [ footerCss ] [ Html.text "I am a footer" ]


viewBody : AppModel.Model -> List (Html msg)
viewBody model =
    [ viewHeader, viewContent model, viewFooter ]


view : AppModel.Model -> Browser.Document msg
view model =
    let
        pageTitle =
            case model.page of
                AppModel.Home ->
                    "Home"

                AppModel.NotFound ->
                    "Not Found"

                AppModel.SignIn _ ->
                    "Sign In"
    in
    { body = viewBody model |> List.map Html.toUnstyled
    , title =
        "Scriptzzz | " ++ pageTitle
    }
