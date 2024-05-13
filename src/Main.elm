module Main exposing (main)

import Browser
import Html exposing (Html, button, div, p, text)
import Html.Attributes exposing (..)
import Html.Events exposing (..)


type alias Model =
    { count : Int }


init : Model
init =
    { count = 0 }


type Msg
    = Increment
    | Decrement


update : Msg -> Model -> Model
update msg model =
    case msg of
        Increment ->
            { model | count = model.count + 1 }

        Decrement ->
            { model | count = model.count - 1 }


view : Model -> Html Msg
view model =
    div [ style "margin" "40px" ]
        [ button [ onClick Increment ] [ text "Increment" ]
        , p [] [ text <| String.fromInt model.count ]
        , button [ onClick Decrement ] [ text "Decrement" ]
        ]


main : Program () Model Msg
main =
    Browser.sandbox
        { init = init
        , view = view
        , update = update
        }
