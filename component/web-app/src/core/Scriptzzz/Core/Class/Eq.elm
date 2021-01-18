module Scriptzzz.Core.Class.Eq exposing (Eq)


type alias Eq a =
    { a
        | equals : a -> a -> Bool
    }


eq : Eq a -> a -> a -> Bool
eq eqInstance =
    eqInstance.equals
