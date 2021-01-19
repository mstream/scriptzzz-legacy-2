module Scriptzzz.Browser.Client.Init exposing (init)

import Browser.Events as BrowserEvt
import Browser.Navigation as BrowserNav
import Json.Decode as JsonDec
import Scriptzzz.Browser.Client.Command as BrowserClientCmd
import Scriptzzz.Browser.Client.Data as BrowserClientData exposing (Flags)
import Scriptzzz.Browser.Client.Message exposing (Msg)
import Scriptzzz.Browser.Client.Model as BrowserClientModel exposing (Model)
import Scriptzzz.Core.Loadable as CoreLoadable
import Time
import Url exposing (Url)


decodeFlags : JsonDec.Value -> Result JsonDec.Error Flags
decodeFlags =
    JsonDec.decodeValue BrowserClientData.flagsDecoder


initFallback : JsonDec.Error -> ( Model, Cmd Msg )
initFallback decodingError =
    ( BrowserClientModel.FailedToInitialize
    , BrowserClientCmd.logError <|
        "Flags decoding error: "
            ++ JsonDec.errorToString decodingError
    )


initNormal : Flags -> Url -> BrowserNav.Key -> ( Model, Cmd Msg )
initNormal { now, timeUpdateInterval } url navigationKey =
    ( BrowserClientModel.Initialized
        { app = CoreLoadable.notStarted
        , documentVisibility = BrowserEvt.Visible
        , now = now
        , timeUpdateInterval = timeUpdateInterval
        }
    , Cmd.batch
        [ BrowserClientCmd.loadApp
        , BrowserClientCmd.logInfo "Initializing the application..."
        ]
    )


init : JsonDec.Value -> Url -> BrowserNav.Key -> ( Model, Cmd Msg )
init flagsValue url navigationKey =
    case decodeFlags flagsValue of
        Result.Err decodingError ->
            initFallback decodingError

        Result.Ok flags ->
            initNormal flags url navigationKey
