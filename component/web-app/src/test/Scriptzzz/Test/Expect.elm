module Scriptzzz.Test.Expect exposing
    ( codable
    , commutative
    , invertible
    , reflexive
    , symmetrical
    )

import Expect exposing (Expectation)
import Json.Decode as JsonDec
import Json.Encode as JsonEnc


codable : (a -> JsonEnc.Value) -> JsonDec.Decoder a -> a -> Expectation
codable encodeValue decoder =
    invertible encodeValue (JsonDec.decodeValue decoder)


commutative : (a -> a -> a) -> a -> a -> Expectation
commutative operation value1 value2 =
    Expect.equal
        (operation value1 value2)
        (operation value2 value1)


invertible : (a -> b) -> (b -> Result x a) -> a -> Expectation
invertible mapTo mapFrom value =
    Expect.equal
        (Result.Ok value)
        (mapTo value |> mapFrom)


reflexive : (a -> a -> Bool) -> a -> Expectation
reflexive operation value =
    Expect.equal
        True
        (operation value value)


symmetrical : (a -> a -> Bool) -> a -> a -> Expectation
symmetrical operation value1 value2 =
    Expect.equal
        (operation value1 value2)
        (operation value2 value1)


transitive : (a -> a -> Bool) -> a -> a -> a -> Expectation
transitive operation value1 value2 value3 =
    if operation value1 value2 && operation value2 value3 then
        Expect.equal
            True
            (operation value1 value3)

    else
        Expect.pass
