module App.Viewer exposing (Viewer(..), getViewer)


type Viewer
    = Guest
    | Registered String


getViewer : Maybe String -> Viewer
getViewer authToken =
    case authToken of
        Nothing ->
            Guest

        Just _ ->
            Registered "TODO"
