module Scriptzzz.Engine.Game.RockPaperScissors exposing (Game, game)

import Scriptzzz.Engine.Api as Api


type Item
    = Paper
    | Rock
    | Scissors


type Draw
    = SameItemChosen


type Victory
    = SuperiorItemChosen


type Model
    = FirstPlayerMoving
    | SecondPlayerMoving Item
    | Done Item Item


type alias ExecutionResult =
    Api.ExecutionResult Draw Never Model () Victory Never


type alias Game =
    Api.Game Draw Never Model Item () () Victory Never


init : () -> ( Model, Api.State Draw () Victory )
init _ =
    ( FirstPlayerMoving, Api.AwaitingMove Api.First () )


beats : Item -> Item -> Bool
beats item otherItem =
    case ( item, otherItem ) of
        ( Paper, Rock ) ->
            True

        ( Paper, _ ) ->
            False

        ( Rock, Scissors ) ->
            True

        ( Rock, _ ) ->
            False

        ( Scissors, Paper ) ->
            True

        ( Scissors, _ ) ->
            False


getOutcome : Item -> Item -> Api.Outcome Draw Victory
getOutcome firstPlayerItem secondPlayerItem =
    if beats firstPlayerItem secondPlayerItem then
        Api.VictoryOf Api.First SuperiorItemChosen

    else if beats secondPlayerItem firstPlayerItem then
        Api.VictoryOf Api.Second SuperiorItemChosen

    else
        Api.Draw SameItemChosen


execute : Api.Player -> Item -> Model -> ExecutionResult
execute player item model =
    case model of
        FirstPlayerMoving ->
            if player == Api.Second then
                Result.Err Api.WrongPlayerMoved

            else
                Result.Ok
                    ( SecondPlayerMoving item
                    , Api.AwaitingMove Api.Second ()
                    )

        SecondPlayerMoving firstPlayerItem ->
            if player == Api.First then
                Result.Err Api.WrongPlayerMoved

            else
                Result.Ok ( Done firstPlayerItem item, Api.Finished <| getOutcome firstPlayerItem item )

        Done _ _ ->
            Result.Err Api.GameOver


game : Game
game =
    { execute = execute
    , init = init
    , name = "Rock Paper Scissors"
    }
