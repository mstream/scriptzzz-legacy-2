module Scriptzzz.Core.Nat exposing
    ( Nat
    , add
    , decoder
    , encodeValue
    , eq
    , fromInt
    , gt
    , inc
    , lt
    , max
    , min
    , mul
    , n1
    , n10
    , n100
    , n1000
    , n2
    , n3
    , n4
    , n5
    , n6
    , n7
    , n8
    , n9
    , pow
    , sub
    , toInt
    )

import Json.Decode as JsonDec
import Json.Encode as JsonEnc


type Nat
    = Nat Int


n1 : Nat
n1 =
    Nat 1


n2 : Nat
n2 =
    Nat 2


n3 : Nat
n3 =
    Nat 3


n4 : Nat
n4 =
    Nat 4


n5 : Nat
n5 =
    Nat 5


n6 : Nat
n6 =
    Nat 6


n7 : Nat
n7 =
    Nat 7


n8 : Nat
n8 =
    Nat 8


n9 : Nat
n9 =
    Nat 9


n10 : Nat
n10 =
    Nat 10


n100 : Nat
n100 =
    Nat 100


n1000 : Nat
n1000 =
    Nat 1000


min : Nat
min =
    n1


max : Nat
max =
    Nat (2 ^ 31 - 1)


fromInt : Int -> Result String Nat
fromInt i =
    if i > 0 then
        Result.Ok (Nat i)

    else
        Result.Err "Natural number should be greater than zero."


toInt : Nat -> Int
toInt (Nat i) =
    i


encodeValue : Nat -> JsonEnc.Value
encodeValue (Nat i) =
    JsonEnc.int i


decoder : JsonDec.Decoder Nat
decoder =
    let
        intToNatDecoder : Int -> JsonDec.Decoder Nat
        intToNatDecoder i =
            case fromInt i of
                Result.Err description ->
                    JsonDec.fail description

                Result.Ok n ->
                    JsonDec.succeed n
    in
    JsonDec.int |> JsonDec.andThen intToNatDecoder


add : Nat -> Nat -> Nat
add (Nat i) (Nat j) =
    Nat (i + j)


mul : Nat -> Nat -> Nat
mul (Nat i) (Nat j) =
    Nat (i * j)


pow : Nat -> Nat -> Nat
pow (Nat i) (Nat j) =
    Nat (i ^ j)


sub : Nat -> Nat -> Int
sub (Nat i) (Nat j) =
    i - j


inc : Nat -> Nat
inc =
    add n1


eq : Nat -> Nat -> Bool
eq (Nat i) (Nat j) =
    i == j


lt : Nat -> Nat -> Bool
lt (Nat i) (Nat j) =
    i < j


gt : Nat -> Nat -> Bool
gt (Nat i) (Nat j) =
    i > j
