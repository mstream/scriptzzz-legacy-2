module Scriptzzz.Engine.Api exposing
    ( ExecutionError(..)
    , ExecutionResult
    , Game
    , Outcome(..)
    , Player(..)
    , State(..)
    )

import Scriptzzz.Core as Core


type Player
    = First
    | Second


type ExecutionError invalidity violation
    = GameOver
    | InvalidMove violation
    | InvalidState invalidity
    | WrongPlayerMoved


type Outcome draw victory
    = Draw draw
    | VictoryOf Player victory


type State draw projection victory
    = AwaitingMove Player projection
    | Finished (Outcome draw victory)


type alias ExecutionResult draw invalidity model projection victory violation =
    Result
        (ExecutionError invalidity violation)
        ( model, State draw projection victory )


type alias Logic draw invalidity model move params projection victory violation =
    { execute :
        Player
        -> move
        -> model
        -> ExecutionResult draw invalidity model projection victory violation
    , init : params -> ( model, State draw projection victory )
    }


type alias Game draw invalidity model move params projection victory violation =
    Core.Named (Logic draw invalidity model move params projection victory violation)
