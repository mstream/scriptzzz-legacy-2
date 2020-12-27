port module App exposing
    ( Flags
    , Model
    , Msg
    , init
    , onUrlChange
    , onUrlRequest
    , subscriptions
    , update
    , view
    )

import App.Style as AppStyle
import App.Svg as AppSvg
import Browser
import Browser.Navigation as BrowserNav
import Dict exposing (Dict)
import Html.Styled as Html exposing (Html)
import Html.Styled.Attributes as HtmlAttr
import Json.Decode as JsonDec
import Json.Decode.Pipeline as JsonDecPipe
import Json.Encode as JsonEnc
import Tailwind.Utilities as TwUtil
import Url exposing (Url)



-- PORTS


port incoming : (JsonDec.Value -> msg) -> Sub msg


port outgoing : JsonEnc.Value -> Cmd msg


type PortMsgDecodingErr
    = InvalidBody String JsonDec.Error
    | InvalidMsg JsonDec.Error
    | UnsupportedMsg String


type alias PortMsg =
    { body : JsonEnc.Value
    , type_ : String
    }


sizeDecoder : JsonDec.Decoder Size
sizeDecoder =
    JsonDec.succeed Size
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


handlePortMsg : JsonEnc.Value -> Msg
handlePortMsg jsonVal =
    case JsonDec.decodeValue portMsgDecoder jsonVal of
        Err err ->
            InvalidMsg err |> GotPortMsgDecodingErr

        Ok portMsg ->
            case Dict.get portMsg.type_ portMsgBodyDecoders of
                Nothing ->
                    UnsupportedMsg portMsg.type_ |> GotPortMsgDecodingErr

                Just bodyDecoder ->
                    case JsonDec.decodeValue bodyDecoder portMsg.body of
                        Err err ->
                            InvalidBody portMsg.type_ err |> GotPortMsgDecodingErr

                        Ok msg ->
                            msg


onUrlChange : Url -> Msg
onUrlChange =
    UrlChanged


onUrlRequest : Browser.UrlRequest -> Msg
onUrlRequest =
    UrlRequested


portSubscription : Sub Msg
portSubscription =
    incoming handlePortMsg



-- MODEL


type alias Size =
    { height : Int
    , width : Int
    }


type alias Flags =
    { pixelRatio : Float
    , windowSize : Size
    }


type alias Model =
    { currWindowSize : Size
    , navKey : BrowserNav.Key
    , pixelRatio : Float
    , prevWindowSize : Size
    , url : Url
    }


type WindowArea
    = Small
    | Medium
    | Large


type WindowOrientation
    = Horizontal
    | Vertical


getWindowArea : Size -> WindowArea
getWindowArea size =
    let
        area =
            toFloat (size.width * size.height) / 1000
    in
    if area < 750 then
        Small

    else if area < 1000 then
        Medium

    else
        Large


getCurrWindowArea : { r | currWindowSize : Size } -> WindowArea
getCurrWindowArea =
    .currWindowSize >> getWindowArea


getPrevWindowArea : { r | prevWindowSize : Size } -> WindowArea
getPrevWindowArea =
    .prevWindowSize >> getWindowArea


getWindowOrientation : Size -> WindowOrientation
getWindowOrientation size =
    if size.width > size.height then
        Horizontal

    else
        Vertical


getCurrWindowOrientation : { r | currWindowSize : Size } -> WindowOrientation
getCurrWindowOrientation =
    .currWindowSize >> getWindowOrientation


getPrevWindowOrientation : { r | prevWindowSize : Size } -> WindowOrientation
getPrevWindowOrientation =
    .prevWindowSize >> getWindowOrientation


initModel : Flags -> Url -> BrowserNav.Key -> Model
initModel flags url navKey =
    { currWindowSize = flags.windowSize
    , navKey = navKey
    , pixelRatio = flags.pixelRatio
    , prevWindowSize = flags.windowSize
    , url = url
    }


init : Flags -> Url -> BrowserNav.Key -> ( Model, Cmd Msg )
init flags url navKey =
    ( initModel flags url navKey, Cmd.none )



-- UPDATE


type Msg
    = GotPortMsgDecodingErr PortMsgDecodingErr
    | UrlChanged Url
    | UrlRequested Browser.UrlRequest
    | WindowResized Size


subscriptions : Model -> Sub Msg
subscriptions _ =
    portSubscription


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        WindowResized newSize ->
            ( { model | prevWindowSize = model.currWindowSize, currWindowSize = newSize }
            , Cmd.none
            )

        _ ->
            ( model, Cmd.none )



-- VIEW


viewHeaderSV : Model -> Html Msg
viewHeaderSV _ =
    Html.header
        [ HtmlAttr.css [ TwUtil.flex_none, AppStyle.flexRow, TwUtil.justify_between, TwUtil.h_8, TwUtil.text_2xl, TwUtil.text_gray_100, TwUtil.bg_brand_500 ] ]
        [ AppSvg.logoIcon, Html.text "I am a header", AppSvg.menu ]


viewMainSV : Model -> Html Msg
viewMainSV _ =
    Html.main_
        [ HtmlAttr.css [ TwUtil.flex_auto ] ]
        [ Html.text "I am a main" ]


viewBodySV : Model -> List (Html Msg)
viewBodySV model =
    [ Html.div
        [ HtmlAttr.css [ AppStyle.flexCol, TwUtil.h_screen ] ]
        [ viewHeaderSV model, viewMainSV model ]
    ]


viewBody : Model -> List (Html Msg)
viewBody model =
    let
        viewLayout =
            case ( getCurrWindowArea model, getCurrWindowOrientation model ) of
                ( Small, Vertical ) ->
                    viewBodySV

                _ ->
                    viewBodySV
    in
    viewLayout model


view : Model -> Browser.Document Msg
view model =
    { body = viewBody model |> List.map Html.toUnstyled
    , title = "Scriptzzz"
    }
