module App.Flags exposing (Flags)


type alias Flags =
    { authToken : Maybe String
    , githubOauthClientId : String
    }
