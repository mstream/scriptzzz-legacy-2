module Scriptzzz.Browser.Client.App exposing
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

import Browser
import Browser.Dom as BrowserDom
import Browser.Events as BrowserEvt
import Browser.Navigation as BrowserNav
import Scriptzzz.Browser.Client.App.Document as AppDoc
import Scriptzzz.Browser.Client.App.Flags as AppFlags
import Scriptzzz.Browser.Client.App.Model as AppModel
import Scriptzzz.Browser.Client.App.Ports as AppPorts
import Scriptzzz.Browser.Client.App.Route as AppRoute
import Task
import Url exposing (Url)


type alias Flags =
    AppFlags.Flags


type alias Model =
    AppModel.Model


type Msg
    = DoneGetViewport BrowserDom.Viewport
    | GotPortMsg AppPorts.Msg
    | UrlChanged Url
    | UrlRequested Browser.UrlRequest
    | WindowResized Int Int
    | WindowVisibilityChanged BrowserEvt.Visibility


getViewport : Cmd Msg
getViewport =
    Task.perform DoneGetViewport BrowserDom.getViewport


onUrlChange : Url -> Msg
onUrlChange =
    UrlChanged


onUrlRequest : Browser.UrlRequest -> Msg
onUrlRequest =
    UrlRequested


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.batch
        [ Sub.map GotPortMsg AppPorts.subscriptions
        , BrowserEvt.onResize WindowResized
        , BrowserEvt.onVisibilityChange WindowVisibilityChanged
        ]


handleDoneGetViewport : BrowserDom.Viewport -> Model -> ( Model, Cmd Msg )
handleDoneGetViewport viewport model =
    ( { model | windowViewport = Just viewport }
    , Cmd.none
    )


handlePortMsg : AppPorts.Msg -> Model -> ( Model, Cmd Msg )
handlePortMsg msg model =
    case msg of
        AppPorts.FailedToDecode _ ->
            ( model, AppPorts.log "Failed to decode a port message" )

        AppPorts.WindowScrolled ->
            ( model, getViewport )


handleUrlChanged : Url -> Model -> ( Model, Cmd Msg )
handleUrlChanged url model =
    case AppRoute.fromUrl url of
        AppRoute.NotFound ->
            ( { model | page = AppModel.NotFound }, getViewport )

        Just AppRoute.Home ->
            ( { model | page = AppModel.Home }, getViewport )

        Just (AppRoute.SandboxGame gameId) ->
            ( { model | page = AppModel.SandboxGame gameId }, getViewport )

        Just AppRoute.SandboxIndex ->
            ( { model | page = AppModel.SandboxIndex () }, getViewport )

        Just AppRoute.SignIn ->
            ( { model | page = AppModel.SignIn () }, getViewport )


handleUrlRequested : Browser.UrlRequest -> Model -> ( Model, Cmd Msg )
handleUrlRequested urlRequest model =
    case urlRequest of
        Browser.Internal url ->
            ( model, BrowserNav.pushUrl model.navKey <| Url.toString url )

        Browser.External href ->
            ( model, BrowserNav.load href )


handleWindowResized : Model -> ( Model, Cmd Msg )
handleWindowResized model =
    ( model, getViewport )


handleWindowVisibilityChanged : BrowserEvt.Visibility -> Model -> ( Model, Cmd Msg )
handleWindowVisibilityChanged visibility model =
    case visibility of
        BrowserEvt.Hidden ->
            ( { model | windowViewport = Nothing, windowVisibility = BrowserEvt.Hidden }, Cmd.none )

        BrowserEvt.Visible ->
            ( { model | windowVisibility = BrowserEvt.Visible }, getViewport )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    let
        updateModel =
            case msg of
                DoneGetViewport viewport ->
                    handleDoneGetViewport viewport

                GotPortMsg portMsg ->
                    handlePortMsg portMsg

                UrlChanged url ->
                    handleUrlChanged url

                UrlRequested urlRequest ->
                    handleUrlRequested urlRequest

                WindowResized _ _ ->
                    handleWindowResized

                WindowVisibilityChanged visibility ->
                    handleWindowVisibilityChanged visibility
    in
    updateModel model


init : Flags -> Url -> BrowserNav.Key -> ( Model, Cmd Msg )
init flags url navKey =
    update (UrlChanged url) <| AppModel.init flags url navKey


view : Model -> Browser.Document Msg
view =
    AppDoc.view
