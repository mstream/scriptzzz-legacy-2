port module Scriptzzz.Browser.Client.Port exposing (elmToJs, jsToElm)

import Json.Encode as JsonEnc


port elmToJs : JsonEnc.Value -> Cmd msg


port jsToElm : (JsonEnc.Value -> msg) -> Sub msg
