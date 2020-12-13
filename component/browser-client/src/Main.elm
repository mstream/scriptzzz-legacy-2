module Main exposing (main)

import Bootstrap.Modal as Modal
import Bootstrap.Navbar as Navbar
import Browser
import Browser.Navigation as Navigation
import Html as H
import Html.Attributes as HA
import Maybe
import Url
import Url.Parser as Parser


type Page
    = Home
    | NotFound


type alias Model =
    { modalVisibility : Modal.Visibility
    , navKey : Navigation.Key
    , navState : Navbar.State
    , page : Page
    }


type Msg
    = NavMsg Navbar.State
    | UrlChanged Url.Url
    | UrlRequested Browser.UrlRequest


initModel : Navigation.Key -> Navbar.State -> Model
initModel navKey navState =
    { modalVisibility = Modal.hidden
    , navKey = navKey
    , navState = navState
    , page = Home
    }


init : () -> Url.Url -> Navigation.Key -> ( Model, Cmd Msg )
init flags url navKey =
    let
        ( navState, navCmd ) =
            Navbar.initialState NavMsg

        ( model, urlCmd ) =
            initModel navKey navState
                |> updateUrl url
    in
    ( model, Cmd.batch [ urlCmd, navCmd ] )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    ( model, Cmd.none )


routeParser : Parser.Parser (Page -> a) a
routeParser =
    Parser.oneOf [ Parser.map Home Parser.top ]


decodeUrl : Url.Url -> Maybe Page
decodeUrl url =
    { url | path = Maybe.withDefault "" url.fragment, fragment = Nothing } |> Parser.parse routeParser


updateUrl : Url.Url -> Model -> ( Model, Cmd Msg )
updateUrl url model =
    ( { model | page = decodeUrl url |> Maybe.withDefault NotFound }, Cmd.none )


viewMenu : Model -> H.Html Msg
viewMenu model =
    Navbar.config NavMsg
        |> Navbar.withAnimation
        |> Navbar.container
        |> Navbar.brand [ HA.href "#" ] [ H.text "Scriptzzz" ]
        |> Navbar.view model.navState


viewContent : Model -> H.Html Msg
viewContent model =
    H.div [] []


viewModal : Model -> H.Html Msg
viewModal model =
    H.div [] []


view : Model -> Browser.Document Msg
view model =
    { title = "Scriptzzz"
    , body =
        [ List.map (\v -> v model) [ viewMenu, viewContent, viewModal ]
            |> H.div []
        ]
    }


main : Program () Model Msg
main =
    Browser.application
        { init = init
        , onUrlChange = UrlChanged
        , onUrlRequest = UrlRequested
        , subscriptions = subscriptions
        , update = update
        , view = view
        }
