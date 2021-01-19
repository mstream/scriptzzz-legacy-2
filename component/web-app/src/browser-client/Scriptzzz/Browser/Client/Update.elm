module Scriptzzz.Browser.Client.Update exposing (update)

import Scriptzzz.Browser.Client.Command as BrowserClientCmd
import Scriptzzz.Browser.Client.Message as BrowserClientMsg exposing (Msg)
import Scriptzzz.Browser.Client.Model as BrowserClientModel exposing (Model)
import Scriptzzz.Core.Loadable as CoreLoadable


updateInitialized : Msg -> BrowserClientModel.InitializedModel -> ( BrowserClientModel.InitializedModel, Cmd Msg )
updateInitialized message model =
    case message of
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


update : Msg -> Model -> ( Model, Cmd Msg )
update message model =
    case model of
        BrowserClientModel.Initialized initializedModel ->
            updateInitialized message initializedModel
                |> Tuple.mapFirst BrowserClientModel.Initialized

        _ ->
            ( model, Cmd.none )
