module Scriptzzz.Core.Posix exposing
    ( add
    , decoder
    , diff
    , eq
    , isAfter
    , isBefore
    , isNotAfter
    , isNotBefore
    , sub
    , toString
    )

import Json.Decode as JsonDec exposing (Decoder)
import Scriptzzz.Core.Nat as CoreNat exposing (Nat)
import Time


fromMillis : Nat -> Time.Posix
fromMillis =
    CoreNat.toInt >> Time.millisToPosix


decoder : Decoder Time.Posix
decoder =
    JsonDec.map fromMillis CoreNat.decoder


add : Nat -> Time.Posix -> Time.Posix
add duration time =
    Time.millisToPosix (Time.posixToMillis time + CoreNat.toInt duration)


sub : Nat -> Time.Posix -> Time.Posix
sub duration time =
    Time.millisToPosix (Time.posixToMillis time - CoreNat.toInt duration)


compare2 : (Int -> Int -> Bool) -> Time.Posix -> Time.Posix -> Bool
compare2 comparator left right =
    comparator (Time.posixToMillis left) (Time.posixToMillis right)


eq : Time.Posix -> Time.Posix -> Bool
eq =
    compare2 (==)


isAfter : Time.Posix -> Time.Posix -> Bool
isAfter =
    compare2 (>)


isNotAfter : Time.Posix -> Time.Posix -> Bool
isNotAfter left =
    not << isAfter left


isBefore : Time.Posix -> Time.Posix -> Bool
isBefore =
    compare2 (<)


isNotBefore : Time.Posix -> Time.Posix -> Bool
isNotBefore left =
    not << isBefore left


toString : Time.Posix -> String
toString time =
    String.fromInt (Time.posixToMillis time)


diff : Time.Posix -> Time.Posix -> Maybe Nat
diff left right =
    let
        delta : Int
        delta =
            Time.posixToMillis left - Time.posixToMillis right
    in
    case delta of
        0 ->
            Nothing

        i ->
            CoreNat.fromInt (abs i) |> Result.toMaybe
