module Scriptzzz.Browser.Client.Data exposing
    ( Flags
    , LogLevel(..)
    , PortMessage(..)
    , encodePortMessage
    , flagsDecoder
    )

import Json.Decode as JsonDec
import Json.Encode as JsonEnc
import Scriptzzz.Core.Nat as CoreNat exposing (Nat)
import Scriptzzz.Core.Posix as CorePosix
import Time


type alias Flags =
    { now : Time.Posix, timeUpdateInterval : Nat }


type LogLevel
    = Error
    | Info
    | Warning


type PortMessage
    = Log LogLevel String


encodeLogLevel : LogLevel -> JsonEnc.Value
encodeLogLevel level =
    JsonEnc.string <|
        case level of
            Error ->
                "error"

            Info ->
                "info"

            Warning ->
                "warning"


encodeLogPortMessageBody : LogLevel -> String -> JsonEnc.Value
encodeLogPortMessageBody level text =
    JsonEnc.object
        [ ( "level", encodeLogLevel level )
        , ( "text", JsonEnc.string text )
        ]


encodePortMessage : PortMessage -> JsonEnc.Value
encodePortMessage message =
    let
        encode : String -> JsonEnc.Value -> JsonEnc.Value
        encode typeName bodyValue =
            JsonEnc.object
                [ ( "type", JsonEnc.string typeName )
                , ( "body", bodyValue )
                ]
    in
    case message of
        Log level text ->
            encode "LOG" (encodeLogPortMessageBody level text)


flagsDecoder : JsonDec.Decoder Flags
flagsDecoder =
    JsonDec.map2
        Flags
        (JsonDec.field "now" CorePosix.decoder)
        (JsonDec.field "timeUpdateInterval" CoreNat.decoder)
