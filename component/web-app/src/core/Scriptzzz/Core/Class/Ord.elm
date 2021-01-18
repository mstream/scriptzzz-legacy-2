module Scriptzzz.Core.Class.Ord exposing (Ord, Ordering(..))

import Scriptzzz.Core.Class.Eq exposing (Eq)


type Ordering
    = Equal
    | GreaterThan
    | LessThan


type alias Ord a =
    Eq
        { a
            | compare : a -> a -> Ordering
        }


lt : Ord a -> a -> a -> Bool
lt ordInstance left right =
    case ordInstance.compare left right of
        LessThan ->
            True

        _ ->
            False


gt : Ord a -> a -> a -> Bool
gt ordInstance left right =
    case ordInstance.compare left right of
        GreaterThan ->
            True

        _ ->
            False
