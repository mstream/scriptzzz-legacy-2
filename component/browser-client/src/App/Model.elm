module App.Model exposing
    ( Model
    , Page(..)
    , init
    )

import App.Flags as AppFlags
import App.Page.SignIn as AppPageSignIn
import App.Window as AppWin
import Browser.Navigation as BrowserNav
import Url exposing (Url)


type Page
    = Home
    | NotFound
    | SignIn AppPageSignIn.Model


type alias Model =
    { authToken : Maybe String
    , currWindowSize : AppWin.Size
    , githubOauthClientId : String
    , navKey : BrowserNav.Key
    , page : Page
    , pixelRatio : Float
    , prevWindowSize : AppWin.Size
    , url : Url
    }


init : AppFlags.Flags -> Url -> BrowserNav.Key -> Model
init flags url navKey =
    let
        windowSize =
            { height = flags.windowHeight, width = flags.windowWidth }
    in
    { authToken = Nothing
    , currWindowSize = windowSize
    , githubOauthClientId = flags.githubOauthClientId
    , navKey = navKey
    , page = NotFound
    , pixelRatio = flags.pixelRatio
    , prevWindowSize = windowSize
    , url = url
    }
