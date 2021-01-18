module Scriptzzz.Browser.Client.Command exposing (loadApp, logInfo)

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


logInfo : String -> Cmd msg
logInfo =
    BrowserClientData.Log BrowserClientData.Info
        >> BrowserClientData.encodePortMessage
        >> BrowserClientPort.elmToJs
