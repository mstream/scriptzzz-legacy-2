module Scriptzzz.Browser.Client.Update exposing (update)

import Scriptzzz.Browser.Client.Command as BrowserClientCmd
import Scriptzzz.Browser.Client.Message as BrowserClientMsg exposing (Msg)
import Scriptzzz.Browser.Client.Model exposing (Model)
import Scriptzzz.Core.Loadable as CoreLoadable


update :
    Msg
    -> Model
    -> ( Model, Cmd Msg )
update msg model =
    case msg of
        BrowserClientMsg.AppLoaded appModel ->
            ( { model | app = CoreLoadable.succeeded appModel }
            , BrowserClientCmd.logInfo "Application initialized."
            )

        BrowserClientMsg.DocumentVisibilityChanged visibility ->
            ( { model | documentVisibility = visibility }, Cmd.none )

        BrowserClientMsg.TimeUpdated now ->
            ( { model | now = now }, Cmd.none )

        _ ->
            ( model, Cmd.none )
