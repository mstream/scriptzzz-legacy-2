module Main exposing (main)

import Browser
import Browser.Navigation as Nav
import Html as H
import Url


type Model
    = Model Int


type Msg
    = UrlChanged Url.Url
    | UrlRequested Browser.UrlRequest


init : () -> Url.Url -> Nav.Key -> ( Model, Cmd Msg )
init flags url navKey =
    ( Model 0, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    ( model, Cmd.none )


view : Model -> Browser.Document Msg
view model =
    { title = "Scriptzzz"
    , body = [ H.text "Hello world!" ]
    }


main : Program () Model Msg
main =
    Browser.application
        { init = init
        , onUrlChange = UrlChanged
        , onUrlRequest = UrlRequested
        , subscriptions = subscriptions
        , update = update
        , view = view
        }
