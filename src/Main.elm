module Main exposing (..)

-- Press buttons to increment and decrement a counter.
--
-- Read how it works:
--   https://guide.elm-lang.org/architecture/buttons.html
--
-- import Html.Events exposing (..)

import Browser
import Element exposing (..)
import Html



-- MAIN


main : Program () Model Msg
main =
    Browser.sandbox
        { init = init
        , update = update
        , view = view
        }


type alias Model =
    { counter : Int
    , input : String
    }



-- MODEL


init : Model
init =
    { counter = 0
    , input = ""
    }



-- UPDATE


type Msg
    = Increment
    | Decrement
    | NewText String


update : Msg -> Model -> Model
update msg model =
    case msg of
        Increment ->
            { model | counter = model.counter + 1 }

        Decrement ->
            { model | counter = model.counter - 1 }

        NewText input ->
            { model | input = input }


view : Model -> Html.Html Msg
view model =
    layout [ padding 10 ] <|
        row [ spacing 10 ]
            [ text "Hi"
            , text "Hi"
            , text "Hi"
            , text <| Debug.toString a
            ]


a =
    1 + b


b =
    3



-- div []
--     [ button [ onClick Decrement ] [ text "-" ]
--     , input [ onInput NewText ] [ text "-" ]
--     , div [] [ text (Debug.toString model) ]
--     , button [ onClick Increment ] [ text "+" ]
--     ]
