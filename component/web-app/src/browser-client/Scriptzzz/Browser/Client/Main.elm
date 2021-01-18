module Scriptzzz.Browser.Client.Main exposing (main)

import Browser
import Json.Decode as JsonDec
import Scriptzzz.Browser.Client.Data exposing (Flags)
import Scriptzzz.Browser.Client.Init as BrowserClientInit
import Scriptzzz.Browser.Client.Message as BrowserClientMsg exposing (Msg)
import Scriptzzz.Browser.Client.Model exposing (Model)
import Scriptzzz.Browser.Client.Subscriptions as BrowserClientSub
import Scriptzzz.Browser.Client.Update as BrowserClientUpdate
import Scriptzzz.Browser.Client.View as BrowserClientView


main : Program JsonDec.Value Model Msg
main =
    Browser.application
        { init = BrowserClientInit.init
        , onUrlChange = BrowserClientMsg.UrlChanged
        , onUrlRequest = BrowserClientMsg.UrlRequested
        , subscriptions = BrowserClientSub.subscriptions
        , update = BrowserClientUpdate.update
        , view = BrowserClientView.view
        }
