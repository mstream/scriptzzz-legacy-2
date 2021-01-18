module Scriptzzz.Engine.Game exposing
    ( Game(..)
    , fromString
    , getName
    , rockPaperScissors
    , ticTacToe
    , toString
    )

import Scriptzzz.Engine.Game.RockPaperScissors as GameRockPaperScissors
import Scriptzzz.Engine.Game.TicTacToe as GameTicTacToe
import Url.Parser as UrlParser


type Game
    = RockPaperScissors GameRockPaperScissors.Game
    | TicTacToe GameTicTacToe.Game


rockPaperScissors : GameRockPaperScissors.Game
rockPaperScissors =
    GameRockPaperScissors.game


ticTacToe : GameTicTacToe.Game
ticTacToe =
    GameTicTacToe.game


getName : Game -> String
getName game =
    case game of
        RockPaperScissors _ ->
            "rps"

        TicTacToe _ ->
            "ttt"


fromString : String -> Maybe Game
fromString string =
    case string of
        "rock-paper-scissors" ->
            Just <| RockPaperScissors GameRockPaperScissors.game

        "tic-tac-toe" ->
            Just <| TicTacToe GameTicTacToe.game

        _ ->
            Nothing


toString : Game -> String
toString game =
    case game of
        RockPaperScissors _ ->
            "rock-paper-scissors"

        TicTacToe _ ->
            "tic-tac-toe"
