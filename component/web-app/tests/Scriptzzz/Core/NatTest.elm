module Scriptzzz.Core.NatTest exposing (suite)

import Expect exposing (Expectation)
import Scriptzzz.Core.Nat as CoreNat exposing (Nat)
import Scriptzzz.Test.Fuzz as TestFuzz
import Scriptzzz.Test.Laws as TestLaws
import Test exposing (Test)


hasPositiveCodomain : (Nat -> Int) -> Nat -> Expectation
hasPositiveCodomain op n =
    Expect.greaterThan 0 (op n)


suite : Test
suite =
    Test.describe "Scriptzzz.Core.Nat"
        [ Test.describe "Nat"
            [ TestLaws.codability
                CoreNat.encodeValue
                CoreNat.decoder
                TestFuzz.nat
            ]
        , Test.describe "add"
            [ TestLaws.commutativity
                CoreNat.add
                TestFuzz.nat
            ]
        , Test.describe "mul"
            [ TestLaws.commutativity
                CoreNat.add
                TestFuzz.nat
            ]
        , Test.describe "toInt"
            [ Test.fuzz
                TestFuzz.nat
                "natural number is always greater than zero"
              <|
                hasPositiveCodomain CoreNat.toInt
            ]
        ]
