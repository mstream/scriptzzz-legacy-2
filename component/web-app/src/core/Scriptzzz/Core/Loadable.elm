module Scriptzzz.Core.Loadable exposing
    ( Failure(..)
    , State(..)
    , ViaHttp
    , getState
    , notStarted
    , started
    , succeeded
    )

import Http
import Scriptzzz.Core.Nat as CoreNat exposing (Nat)
import Scriptzzz.Core.Posix as CorePosix
import Time


type Loadable x a
    = LoadingFailed x
    | LoadingNotStarted
    | LoadingStarted Time.Posix
    | LoadingSucceeded a


type alias ViaHttp a =
    Loadable Http.Error a


type Failure x
    = Error x
    | Timeout


type State x a
    = Failed (Failure x)
    | NotStarted
    | Started
    | Succeeded a


notStarted : Loadable x a
notStarted =
    LoadingNotStarted


started : Time.Posix -> Loadable x a
started startTime =
    LoadingStarted startTime


succeeded : a -> Loadable x a
succeeded value =
    LoadingSucceeded value


failed : x -> Loadable x a
failed error =
    LoadingFailed error


isExpired : Nat -> Time.Posix -> Time.Posix -> Bool
isExpired timeout now startTime =
    case CorePosix.diff now startTime of
        Nothing ->
            False

        Just diff ->
            CoreNat.gt diff timeout


getState : Nat -> Time.Posix -> Loadable x a -> State x a
getState timeout now loadable =
    case loadable of
        LoadingFailed error ->
            Failed (Error error)

        LoadingNotStarted ->
            NotStarted

        LoadingStarted startTime ->
            if isExpired timeout now startTime then
                Failed Timeout

            else
                Started

        LoadingSucceeded value ->
            Succeeded value
