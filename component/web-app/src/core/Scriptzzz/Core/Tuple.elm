module Scriptzzz.Core.Tuple exposing (apply, apply3)


apply : (a -> b -> c) -> ( a, b ) -> c
apply function ( a, b ) =
    function a b


apply3 : (a -> b -> c -> d) -> ( a, b, c ) -> d
apply3 function ( a, b, c ) =
    function a b c
