module Scriptzzz.Browser.Client.View exposing (view)

import Browser
import Element as El exposing (Element)
import Element.Background as ElBg
import Element.Font as ElFont
import Scriptzzz.Browser.Client.Model as BrowserClientModel exposing (Model)
import Scriptzzz.Core.Loadable as CoreLoadable
import Scriptzzz.Core.Nat as CoreNat


viewApp : BrowserClientModel.App -> Element msg
viewApp model =
    El.text model


viewBodyInitialized : BrowserClientModel.InitializedModel -> Element msg
viewBodyInitialized { app, now } =
    case CoreLoadable.getState CoreNat.max now app of
        CoreLoadable.Failed _ ->
            El.text "error"

        CoreLoadable.NotStarted ->
            El.text "nothing to show LOOL"

        CoreLoadable.Started ->
            El.text "loading... LOL"

        CoreLoadable.Succeeded appModel ->
            viewApp appModel


viewBody : Model -> Element msg
viewBody model =
    El.el [ El.centerX, El.centerY ] <|
        case model of
            BrowserClientModel.FailedToInitialize ->
                El.text "Initialization failure"

            BrowserClientModel.Initialized initializedModel ->
                viewBodyInitialized initializedModel


view : Model -> Browser.Document msg
view model =
    { body =
        [ El.layout
            [ ElBg.color (El.rgba 0 0 0 1)
            , ElFont.color (El.rgba 1 1 1 1)
            ]
            (viewBody model)
        ]
    , title = "Scriptzzz"
    }
