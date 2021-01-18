module Scriptzzz.Browser.Client.Init exposing (init)

import Browser.Events as BrowserEvt
import Browser.Navigation as BrowserNav
import Json.Decode as JsonDec
import Scriptzzz.Browser.Client.Command as BrowserClientCmd
import Scriptzzz.Browser.Client.Data as BrowserClientData exposing (Flags)
import Scriptzzz.Browser.Client.Message exposing (Msg)
import Scriptzzz.Browser.Client.Model exposing (Model)
import Scriptzzz.Core.Loadable as CoreLoadable
import Time
import Url exposing (Url)


decodeFlags : JsonDec.Value -> Result JsonDec.Error Flags
decodeFlags =
    JsonDec.decodeValue BrowserClientData.flagsDecoder


init : JsonDec.Value -> Url -> BrowserNav.Key -> ( Model, Cmd Msg )
init flagsValue url navKey =
    case decodeFlags flagsValue of
        Result.Err decodingError ->
            Debug.todo <|
                "Implement flags parsing recovery: "
                    ++ JsonDec.errorToString decodingError

        Result.Ok { now, timeUpdateInterval } ->
            ( { app = CoreLoadable.notStarted
              , documentVisibility = BrowserEvt.Visible
              , now = now
              , timeUpdateInterval = timeUpdateInterval
              }
            , Cmd.batch
                [ BrowserClientCmd.loadApp
                , BrowserClientCmd.logInfo "Initializing the application..."
                ]
            )
