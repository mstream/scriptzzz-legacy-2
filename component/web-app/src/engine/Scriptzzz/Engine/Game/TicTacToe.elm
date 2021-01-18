module Scriptzzz.Engine.Game.TicTacToe exposing (Game, game)

import Dict exposing (Dict)
import Scriptzzz.Engine.Api as Api


type Cell
    = Bottom
    | BottomLeft
    | BottomRight
    | Center
    | Left
    | Right
    | Top
    | TopLeft
    | TopRight


type Row
    = BottomHorizontal
    | DiagonalDownward
    | DiagonalUpward
    | MiddleHorizontal
    | MiddleVertical
    | LeftVertical
    | RightVertical
    | TopHorizontal


type Invalidity
    = TooManyMarks Api.Player


type Violation
    = CellTaken


type Victory
    = RowCompletd Row


type Draw
    = NoRowCompleted


type alias Model =
    Dict Cell Api.Player


type alias ExecutionResult =
    Api.ExecutionResult Draw Invalidity Model Model Victory Violation


type alias Game =
    Api.Game Draw Invalidity Model Cell () Model Victory Violation


getOwner : List (Maybe Api.Player) -> Maybe Api.Player
getOwner marks =
    case marks of
        [] ->
            Nothing

        [ mark ] ->
            mark

        mark :: otherMarks ->
            case mark of
                Nothing ->
                    Nothing

                Just _ ->
                    getOwner otherMarks


init : () -> ( Model, Api.State Draw Model Victory )
init _ =
    ( Dict.empty, Api.AwaitingMove Api.First Dict.empty )


execute : Api.Player -> Cell -> Model -> ExecutionResult
execute player cell model =
    Result.Ok ( model, Api.AwaitingMove Api.First model )


game : Game
game =
    { execute = execute
    , init = init
    , name = "Tic Tac Toe"
    }
