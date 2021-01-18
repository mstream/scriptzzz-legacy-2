module Scriptzzz.Core.PosixTest exposing (suite)

import Expect exposing (Expectation)
import Scriptzzz.Core.Nat as CoreNat
import Scriptzzz.Core.Posix as CorePosix
import Scriptzzz.Test.Expect as TestExpect
import Scriptzzz.Test.Fuzz as TestFuzz
import Test exposing (Test)
import Time


isMonotonic : Time.Posix -> Expectation
isMonotonic time =
    Expect.all
        [ Expect.true "equal itself"
            << CorePosix.eq time
        , Expect.true "after past"
            << CorePosix.isBefore (CorePosix.sub CoreNat.n1 time)
        , Expect.true "before future"
            << CorePosix.isAfter (CorePosix.add CoreNat.n1 time)
        ]
        time


suite : Test
suite =
    Test.fuzz
        TestFuzz.posix
        "The Scriptzzz.Core.Posix module"
        isMonotonic
