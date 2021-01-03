module App.Page.NotFound exposing (view)

import Html.Styled as Html exposing (Html)


view : Html msg
view =
    Html.main_ [] [ Html.text "Requested page not found." ]
