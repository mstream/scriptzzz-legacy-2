module Scriptzzz.Test.Laws exposing (codability, commutativity)

import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer)
import Json.Decode as JsonDec
import Json.Encode as JsonEnc
import Scriptzzz.Core.Nat as CoreNat exposing (Nat)
import Scriptzzz.Core.Tuple as CoreTuple
import Scriptzzz.Test.Expect as TestExpect
import Test exposing (Test)


options : Nat -> Test.FuzzOptions
options factor =
    { runs = CoreNat.toInt <| CoreNat.mul factor CoreNat.n100 }


test : Nat -> Fuzzer a -> String -> (a -> Expectation) -> Test
test runsFactor fuzzer description toExpectation =
    Test.fuzzWith
        (options runsFactor)
        fuzzer
        description
        toExpectation


test2 : Nat -> Fuzzer a -> Fuzzer b -> String -> (a -> b -> Expectation) -> Test
test2 runsFactor fuzzer1 fuzzer2 description toExpectation =
    Test.fuzzWith
        (options runsFactor)
        (Fuzz.tuple ( fuzzer1, fuzzer2 ))
        description
        (CoreTuple.apply toExpectation)


test3 : Nat -> Fuzzer a -> Fuzzer b -> Fuzzer c -> String -> (a -> b -> c -> Expectation) -> Test
test3 runsFactor fuzzer1 fuzzer2 fuzzer3 description toExpectation =
    Test.fuzzWith
        (options runsFactor)
        (Fuzz.tuple3 ( fuzzer1, fuzzer2, fuzzer3 ))
        description
        (CoreTuple.apply3 toExpectation)


codability : (a -> JsonEnc.Value) -> JsonDec.Decoder a -> Fuzzer a -> Test
codability encodeValue decoder fuzzer =
    test
        CoreNat.n1
        fuzzer
        "coding back and forth does not change the value"
        (TestExpect.codable encodeValue decoder)


commutativity : (a -> a -> a) -> Fuzzer a -> Test
commutativity operation fuzzer =
    test2
        CoreNat.n1
        fuzzer
        fuzzer
        "order of operands does not change the result"
        (TestExpect.commutative operation)


inveribility : (a -> b) -> (b -> Result x a) -> Fuzzer a -> Test
inveribility mapTo mapFrom fuzzer =
    test
        CoreNat.n1
        fuzzer
        "converting back and forth does not change the value"
        (TestExpect.invertible mapTo mapFrom)


reflexivity : (a -> a -> Bool) -> Fuzzer a -> Test
reflexivity operation fuzzer =
    test
        CoreNat.n1
        fuzzer
        "holds when applied to equal values"
        (TestExpect.reflexive operation)


symmetry : (a -> a -> Bool) -> Fuzzer a -> Test
symmetry operation fuzzer =
    test2
        CoreNat.n1
        fuzzer
        fuzzer
        "holds regardless of operands order"
        (TestExpect.symmetrical operation)


transitivity : Nat -> (a -> a -> Bool) -> Fuzzer a -> Test
transitivity runsFactor operation fuzzer =
    test2
        runsFactor
        fuzzer
        fuzzer
        "holds regardless of operands order"
        (TestExpect.symmetrical operation)
