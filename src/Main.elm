module Main exposing (main)

import Browser
import Html exposing (Html, button, div, input, p, text)
import Html.Attributes exposing (..)
import Html.Events exposing (..)


type alias Model =
    { count : Int
    , count2 : Int
    , inputValue : String
    , msg : Msg
    }


init : Model
init =
    { count = 10
    , count2 = 20
    , inputValue = "Initial value"
    , msg = Increment
    }


type Msg
    = Increment
    | Decrement
    | Increment2
    | Decrement2
    | GotNewText String


update : Msg -> Model -> Model
update msg model =
    case msg of
        Increment ->
            { model | count = model.count + 1 }

        Decrement ->
            { model | count = model.count - 1 }

        Increment2 ->
            { model | count2 = model.count2 + 1 }

        Decrement2 ->
            { model | count2 = model.count2 - 1 }

        GotNewText newText ->
            { model | inputValue = newText }


f : Msg
f =
    Increment


g : String -> Msg
g =
    GotNewText



-- onInput : (String -> msg) -> Attribute msg
-- onClick : msg -> Attribute msg


view : Model -> Html Msg
view model =
    div [ style "margin" "40px" ]
        [ button [ onClick Increment ] [ text "Increment" ]
        , input [ onInput GotNewText, value model.inputValue ] []
        , p [] [ text <| String.fromInt model.count ]
        , button [ onClick Decrement ] [ text "Decrement" ]
        , button [ onClick Increment2 ] [ text "Increment" ]
        , p [] [ text <| String.fromInt model.count2 ]
        , button [ onClick Decrement2 ]
            [ text
                (if False then
                    "Decrement"

                 else
                    ""
                )
            ]
        ]


main : Program () Model Msg
main =
    Browser.sandbox
        { init = init
        , view = view
        , update = update
        }
