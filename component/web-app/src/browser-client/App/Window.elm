module App.Window exposing
    ( Area(..)
    , Orientation(..)
    , Size
    , Window
    , fromSize
    )


type Area
    = Small
    | Medium
    | Large


type Orientation
    = Horizontal
    | Vertical


type alias Window =
    { area : Area
    , orientation : Orientation
    }


type alias Size =
    { height : Int
    , width : Int
    }


getArea : Size -> Area
getArea size =
    let
        area =
            toFloat (size.width * size.height) / 1000
    in
    if area < 750 then
        Small

    else if area < 1000 then
        Medium

    else
        Large


getOrientation : Size -> Orientation
getOrientation size =
    if size.width > size.height then
        Horizontal

    else
        Vertical


fromSize : Size -> Window
fromSize size =
    { area = getArea size, orientation = getOrientation size }
