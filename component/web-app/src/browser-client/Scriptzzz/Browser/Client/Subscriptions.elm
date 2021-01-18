module Scriptzzz.Browser.Client.Subscriptions exposing (subscriptions)

import Browser.Events as BrowserEvt
import Scriptzzz.Browser.Client.Message as BrowserClientMsg exposing (Msg)
import Scriptzzz.Browser.Client.Model exposing (Model)
import Scriptzzz.Core.Nat as CoreNat exposing (Nat)
import Time


timeUpdate : Nat -> Sub Msg
timeUpdate interval =
    Time.every
        (interval |> CoreNat.toInt |> toFloat)
        BrowserClientMsg.TimeUpdated


documentVisibilityChange : Sub Msg
documentVisibilityChange =
    BrowserEvt.onVisibilityChange
        BrowserClientMsg.DocumentVisibilityChanged


windowResize : Sub Msg
windowResize =
    BrowserEvt.onResize BrowserClientMsg.WindowResized


subscriptions : Model -> Sub Msg
subscriptions { timeUpdateInterval } =
    Sub.batch
        [ documentVisibilityChange
        , timeUpdate timeUpdateInterval
        , windowResize
        ]
