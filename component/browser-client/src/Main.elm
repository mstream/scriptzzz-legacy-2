module Main exposing (main)

import App
import Browser


main : Program App.Flags App.Model App.Msg
main =
    Browser.application
        { init = App.init
        , onUrlChange = App.onUrlChange
        , onUrlRequest = App.onUrlRequest
        , subscriptions = App.subscriptions
        , update = App.update
        , view = App.view
        }
