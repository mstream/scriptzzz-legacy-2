module Scriptzzz.Browser.Client.Message exposing (Msg(..))

import Browser
import Browser.Events as BrowserEvt
import Time
import Url exposing (Url)


type Msg
    = AppLoaded String
    | DocumentVisibilityChanged BrowserEvt.Visibility
    | TimeUpdated Time.Posix
    | UrlChanged Url
    | UrlRequested Browser.UrlRequest
    | WindowResized Int Int
