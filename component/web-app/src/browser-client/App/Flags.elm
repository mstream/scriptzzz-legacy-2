module App.Flags exposing (Flags)


type alias Flags =
    { apiUrl : String
    , authToken : Maybe String
    , githubOauthClientId : String
    }
