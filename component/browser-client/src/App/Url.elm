module App.Url exposing (githubAccessToken, makeGithubAuthorize)

import Url exposing (Url)
import Url.Builder as UrlBuild


githubAccessToken : String
githubAccessToken =
    ""


makeGithubAuthorize : String -> String
makeGithubAuthorize clientId =
    UrlBuild.crossOrigin
        "https://github.com"
        [ "login", "oauth", "authorize" ]
        [ UrlBuild.string "client_id" clientId ]
