module Main exposing (main)

import Browser
import Element exposing (..)
import Element.Border as Border
import Element.Input as Input
import Html exposing (Html)
import Html.Attributes exposing (..)
import Html.Events exposing (..)


type alias Model =
    { count : Int
    , inputValue : String
    , msg : Msg
    }


init : Model
init =
    { count = 10
    , inputValue = "Initial value"
    , msg = Increment
    }


type Msg
    = Increment
    | Decrement
    | GotNewText String


update : Msg -> Model -> Model
update msg model =
    case msg of
        Increment ->
            { model | count = model.count + 1 }

        Decrement ->
            { model | count = model.count - 1 }

        GotNewText newText ->
            { model | inputValue = newText }



-- onInput : (String -> msg) -> Attribute msg
-- onClick : msg -> Attribute msg


view : Model -> Html Msg
view model =
    layout [ padding 40 ] <|
        column [ spacing 20 ]
            [ Input.button [ padding 20, Border.width 1 ] { label = text "Increment", onPress = Just Increment }
            , text <| String.fromInt model.count
            ]



-- [ button [ onClick Increment ] [ text "Increment" ]
-- , input [ onInput GotNewText, value model.inputValue ] []
-- , p [] [ text <| String.fromInt model.count ]
-- , button [ onClick Decrement ] [ text "Decrement" ]
-- , button [ onClick Increment2 ] [ text "Increment" ]
-- , p [] [ text <| String.fromInt model.count2 ]
-- , button [ onClick Decrement2 ]
--     [ text
--         (if False then
--             "Decrement"
--
--          else
--             ""
--         )
--     ]
-- ]


main : Program () Model Msg
main =
    Browser.sandbox
        { init = init
        , view = view
        , update = update
        }
