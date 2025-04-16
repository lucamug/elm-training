module Main exposing (main)

import Browser
import Element
import Html exposing (Html, button, div, p, text)
import Html.Attributes exposing (..)
import Html.Events exposing (..)


type alias Model =
    { count : Int
    }


type Msg
    = Increment
    | Decrement


init : Model
init =
    { count = 10 }


update msg model =
    case msg of
        Increment ->
            { model | count = model.count + 1 }

        Decrement ->
            { model | count = model.count - 1 }


sum a b =
    a + b + 0.1


view model =
    let
        _ =
            Debug.log "xxx" model
    in
    div [ style "margin" "40px" ]
        -- div : List (Attribute msg) -> List (Html msg) -> Html msg
        -- button : List (Attribute msg) -> List (Html msg) -> Html msg
        -- onClick : msg -> Attribute msg
        -- text : String -> Html msg
        [ button [ onClick Increment ] [ text "Increment" ]
        , p [] [ text (String.fromInt model.count) ]
        , button [ onClick Decrement ] [ text "Decrement" ]
        , Element.layout []
            (Element.row [ Element.spacing 10 ]
                [ Element.text "Hi"
                , Element.text "Hi"
                ]
            )
        ]


main : Program () Model Msg
main =
    Browser.sandbox
        { init = init
        , view = view
        , update = update
        }
