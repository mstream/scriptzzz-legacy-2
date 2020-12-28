port module App.Ports exposing (Msg(..), subscriptions)

import App.Window as AppWin
import Dict exposing (Dict)
import Json.Decode as JsonDec
import Json.Decode.Pipeline as JsonDecPipe
import Json.Encode as JsonEnc


port incoming : (JsonDec.Value -> msg) -> Sub msg


port outgoing : JsonEnc.Value -> Cmd msg


type DecodingErr
    = InvalidBody String JsonDec.Error
    | InvalidMsg JsonDec.Error
    | UnsupportedMsg String


type Msg
    = FailedToDecode DecodingErr
    | WindowResized AppWin.Size


type alias PortMsg =
    { body : JsonEnc.Value
    , type_ : String
    }


sizeDecoder : JsonDec.Decoder AppWin.Size
sizeDecoder =
    JsonDec.succeed AppWin.Size
        |> JsonDecPipe.required "height" JsonDec.int
        |> JsonDecPipe.required "width" JsonDec.int


windowResizedMsgDecoder : JsonDec.Decoder Msg
windowResizedMsgDecoder =
    JsonDec.map WindowResized sizeDecoder


portMsgBodyDecoders : Dict String (JsonDec.Decoder Msg)
portMsgBodyDecoders =
    Dict.fromList
        [ ( "WINDOW_RESIZED", windowResizedMsgDecoder )
        ]


portMsgDecoder : JsonDec.Decoder PortMsg
portMsgDecoder =
    JsonDec.succeed PortMsg
        |> JsonDecPipe.optional "body" JsonDec.value JsonEnc.null
        |> JsonDecPipe.required "type" JsonDec.string


handlePortJsonVal : JsonEnc.Value -> Msg
handlePortJsonVal jsonVal =
    case JsonDec.decodeValue portMsgDecoder jsonVal of
        Err err ->
            InvalidMsg err |> FailedToDecode

        Ok portMsg ->
            case Dict.get portMsg.type_ portMsgBodyDecoders of
                Nothing ->
                    UnsupportedMsg portMsg.type_ |> FailedToDecode

                Just bodyDecoder ->
                    case JsonDec.decodeValue bodyDecoder portMsg.body of
                        Err err ->
                            InvalidBody portMsg.type_ err |> FailedToDecode

                        Ok msg ->
                            msg


subscriptions : Sub Msg
subscriptions =
    incoming handlePortJsonVal
