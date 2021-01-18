module Scriptzzz.Core.Stateful exposing (Stateful, getValue, init)


type Stateful a
    = Changed a a
    | Initial a


init : a -> Stateful a
init value =
    Initial value


derive : (a -> a -> b) -> Stateful a -> b
derive toDerivedValue stateful =
    case stateful of
        Initial value ->
            toDerivedValue value value

        Changed previousValue currentValue ->
            toDerivedValue previousValue currentValue


getValue : Stateful a -> a
getValue =
    derive <| \_ currentValue -> currentValue
