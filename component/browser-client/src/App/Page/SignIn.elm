module App.Page.SignIn exposing (Model, view)

import App.Style as AppStyle
import App.Svg as AppSvg
import App.Url as AppUrl exposing (makeGithubAuthorize)
import App.Viewer as AppViewer
import App.Window as AppWin
import Html.Styled as Html exposing (Html)
import Html.Styled.Attributes as HtmlAttr
import Html.Styled.Events as HtmlEvt


type alias Model =
    ()


viewRegistered : String -> Html msg
viewRegistered username =
    Html.text <| "Hello " ++ username


viewGuest : String -> Html msg
viewGuest githubOauthClientId =
    Html.a
        [ HtmlAttr.css [ AppStyle.btn ]
        , HtmlAttr.href <| AppUrl.makeGithubAuthorize githubOauthClientId
        ]
        [ AppSvg.github
        , Html.text "with Github"
        , Html.div [] []
        ]


view : { r | authToken : Maybe String, currWindowSize : AppWin.Size, githubOauthClientId : String } -> Model -> Html msg
view { authToken, githubOauthClientId } _ =
    let
        page =
            case AppViewer.getViewer authToken of
                AppViewer.Guest ->
                    viewGuest githubOauthClientId

                AppViewer.Registered username ->
                    viewRegistered username
    in
    Html.main_
        []
        [ page ]
