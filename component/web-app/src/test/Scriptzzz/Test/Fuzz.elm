module Scriptzzz.Test.Fuzz exposing (nat, posix)

import Fuzz exposing (Fuzzer)
import Scriptzzz.Core.Nat as CoreNat exposing (Nat)
import Time


nat : Fuzzer Nat
nat =
    let
        intMax : Int
        intMax =
            CoreNat.toInt CoreNat.max

        intMin : Int
        intMin =
            CoreNat.toInt CoreNat.min
    in
    Fuzz.map
        (CoreNat.fromInt >> Result.withDefault CoreNat.n1)
        (Fuzz.intRange intMin intMax)


posix : Fuzzer Time.Posix
posix =
    Fuzz.map Time.millisToPosix Fuzz.int
