module App.Route exposing (Route(..), fromUrl)

import Url exposing (Url)
import Url.Parser as UrlParser


type Route
    = Home
    | SignIn


routeParser : UrlParser.Parser (Route -> a) a
routeParser =
    UrlParser.oneOf
        [ UrlParser.map Home UrlParser.top
        , UrlParser.map SignIn <| UrlParser.s "sign-in"
        ]


fromUrl : Url -> Maybe Route
fromUrl =
    UrlParser.parse routeParser
