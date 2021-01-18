module Scriptzzz.Core.LoadableTest exposing (suite)

import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer)
import Http
import Json.Decode as JsonDec
import Scriptzzz.Core.Loadable as CoreLoadable
import Scriptzzz.Core.Nat as CoreNat exposing (Nat)
import Scriptzzz.Core.Posix as CorePosix
import Scriptzzz.Test.Expect as TestExpect
import Scriptzzz.Test.Fuzz as TestFuzz
import Test exposing (Test)
import Time


isExpirable : Nat -> Time.Posix -> Expectation
isExpirable timeout startTime =
    let
        expirationTime : Time.Posix
        expirationTime =
            CorePosix.add
                (CoreNat.add CoreNat.n1 timeout)
                startTime

        afterExpirationTime : Time.Posix
        afterExpirationTime =
            CorePosix.add CoreNat.n1 expirationTime

        beforeExpirationTime : Time.Posix
        beforeExpirationTime =
            CorePosix.sub CoreNat.n1 expirationTime

        getState : Time.Posix -> CoreLoadable.ViaHttp a -> CoreLoadable.State Http.Error a
        getState =
            CoreLoadable.getState timeout
    in
    Expect.all
        [ Expect.equal (CoreLoadable.Failed CoreLoadable.Timeout)
            << getState afterExpirationTime
        , Expect.equal CoreLoadable.Started
            << getState beforeExpirationTime
        , Expect.equal
            (CoreLoadable.Failed CoreLoadable.Timeout)
            << getState expirationTime
        ]
    <|
        CoreLoadable.started startTime


suite : Test
suite =
    Test.describe "The Loadable module"
        [ Test.describe "Loadable.getState"
            [ Test.fuzz2
                TestFuzz.nat
                TestFuzz.posix
                "returns a timeout error when loading exceeds the given duration"
              <|
                isExpirable
            ]
        ]
