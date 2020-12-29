module App.Model exposing
    ( Model
    , Page(..)
    , init
    )

import App.Flags as AppFlags
import App.Page.SignIn as AppPageSignIn
import App.Window as AppWin
import Browser.Dom as BrowserDom
import Browser.Events as BrowserEvt
import Browser.Navigation as BrowserNav
import Url exposing (Url)


type Page
    = Home
    | NotFound
    | Redirection
    | SignIn AppPageSignIn.Model


type alias Model =
    { authToken : Maybe String
    , githubOauthClientId : String
    , navKey : BrowserNav.Key
    , page : Page
    , url : Url
    , windowViewport : Maybe BrowserDom.Viewport
    , windowVisibility : BrowserEvt.Visibility
    }


init : AppFlags.Flags -> Url -> BrowserNav.Key -> Model
init flags url navKey =
    { authToken = Nothing
    , githubOauthClientId = flags.githubOauthClientId
    , navKey = navKey
    , page = Redirection
    , url = url
    , windowViewport = Nothing
    , windowVisibility = BrowserEvt.Visible
    }
