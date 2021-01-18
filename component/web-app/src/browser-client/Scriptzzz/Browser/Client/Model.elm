module Scriptzzz.Browser.Client.Model exposing (App, Model)

import Browser.Events as BrowserEvt
import Scriptzzz.Core.Loadable as CoreLoadable
import Scriptzzz.Core.Nat exposing (Nat)
import Time


type alias App =
    String


type alias Model =
    { app : CoreLoadable.ViaHttp App
    , documentVisibility : BrowserEvt.Visibility
    , now : Time.Posix
    , timeUpdateInterval : Nat
    }
