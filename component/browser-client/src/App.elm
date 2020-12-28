module App exposing
    ( Flags
    , Model
    , Msg
    , init
    , onUrlChange
    , onUrlRequest
    , subscriptions
    , update
    , view
    )

import App.Document as AppDoc
import App.Flags as AppFlags
import App.Model as AppModel
import App.Ports as AppPorts
import App.Route as AppRoute
import Browser
import Browser.Navigation as BrowserNav
import Url exposing (Url)


type alias Flags =
    AppFlags.Flags


type alias Model =
    AppModel.Model


type Msg
    = GotPortMsg AppPorts.Msg
    | UrlChanged Url
    | UrlRequested Browser.UrlRequest


onUrlChange : Url -> Msg
onUrlChange =
    UrlChanged


onUrlRequest : Browser.UrlRequest -> Msg
onUrlRequest =
    UrlRequested


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.map GotPortMsg AppPorts.subscriptions


handleUrlChanged : Url -> Model -> ( Model, Cmd Msg )
handleUrlChanged url model =
    case AppRoute.fromUrl url of
        Nothing ->
            ( { model | page = AppModel.NotFound }, Cmd.none )

        Just AppRoute.Home ->
            ( { model | page = AppModel.Home }, Cmd.none )

        Just AppRoute.SignIn ->
            ( { model | page = AppModel.SignIn () }, Cmd.none )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GotPortMsg (AppPorts.FailedToDecode _) ->
            ( model, Cmd.none )

        GotPortMsg (AppPorts.WindowResized newSize) ->
            ( { model | prevWindowSize = model.currWindowSize, currWindowSize = newSize }
            , Cmd.none
            )

        UrlChanged url ->
            handleUrlChanged url model

        UrlRequested _ ->
            ( model, Cmd.none )


init : Flags -> Url -> BrowserNav.Key -> ( Model, Cmd Msg )
init flags url navKey =
    update (UrlChanged url) <| AppModel.init flags url navKey


view : Model -> Browser.Document Msg
view =
    AppDoc.view
