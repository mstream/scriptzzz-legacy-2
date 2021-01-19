module Scriptzzz.Browser.Client.Command exposing
    ( loadApp
    , logError
    , logInfo
    , logWarning
    )

import Process
import Scriptzzz.Browser.Client.Data as BrowserClientData
import Scriptzzz.Browser.Client.Message as BrowserClientMsg exposing (Msg)
import Scriptzzz.Browser.Client.Port as BrowserClientPort
import Task


loadApp : Cmd Msg
loadApp =
    Task.perform
        (\_ -> BrowserClientMsg.AppLoaded "APP_MODEL")
        (Process.sleep 5000.0)


log : BrowserClientData.LogLevel -> String -> Cmd msg
log level =
    BrowserClientData.Log level
        >> BrowserClientData.encodePortMessage
        >> BrowserClientPort.elmToJs


logError : String -> Cmd msg
logError =
    log BrowserClientData.Error


logInfo : String -> Cmd msg
logInfo =
    log BrowserClientData.Info


logWarning : String -> Cmd msg
logWarning =
    log BrowserClientData.Warning
