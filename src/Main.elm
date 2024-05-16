module Main exposing (main)

import Browser
import Browser.Events
import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import Html exposing (Html)
import Html.Attributes
import Html.Events exposing (..)
import Time



-- https://emojipedia.org/search?q=ufo


type Direction
    = Left
    | Right


type alias Model =
    { count : Int
    , inputValue : String
    , posix : Time.Posix
    , obj1x : Float
    , obj1Moving : Direction
    , projectiles : List ( Float, Float )
    }


init : ( Model, Cmd msg )
init =
    ( { count = 10
      , inputValue = "Initial value"
      , posix = Time.millisToPosix 0
      , obj1x = 0
      , obj1Moving = Right
      , projectiles = []
      }
    , Cmd.none
    )


type Msg
    = Increment
    | Fire
    | GotNewText String
    | Tick Time.Posix


speedFire : number
speedFire =
    4


speedSaucer : number
speedSaucer =
    5


update : Msg -> Model -> ( Model, Cmd msg )
update msg model =
    case msg of
        Increment ->
            ( { model | count = model.count + 1 }, Cmd.none )

        Fire ->
            ( { model
                | count = model.count - 1
                , projectiles = ( 0, model.obj1x ) :: model.projectiles
              }
            , Cmd.none
            )

        GotNewText newText ->
            ( { model | inputValue = newText }, Cmd.none )

        Tick posix ->
            ( { model
                | posix = posix
                , obj1x =
                    case model.obj1Moving of
                        Left ->
                            model.obj1x - speedSaucer

                        Right ->
                            model.obj1x + speedSaucer
                , obj1Moving =
                    if model.obj1x > 250 then
                        Left

                    else if model.obj1x < 0 then
                        Right

                    else
                        model.obj1Moving
                , projectiles =
                    model.projectiles
                        |> List.map (\( y, x ) -> ( y + speedFire, x ))
                        |> List.filter (\( y, _ ) -> y < 500)
              }
            , Cmd.none
            )


view : Model -> Html Msg
view model =
    layout [ padding 40, Background.color <| rgb 0.1 0.2 0.4 ] <|
        column
            ([ spacing 20
             , inFront <|
                el
                    [ Font.size 500
                    , moveDown 450
                    , moveLeft 60
                    ]
                <|
                    text "🪐"
             ]
                ++ List.map
                    (\( y, x ) ->
                        inFront <|
                            el
                                [ moveDown <| y + 140
                                , moveRight <| x + 40
                                , Font.size <|
                                    if y > 490 then
                                        60

                                    else
                                        30
                                ]
                            <|
                                text <|
                                    if y > 490 then
                                        "💥"

                                    else
                                        "👽"
                    )
                    model.projectiles
            )
            [ row [ width <| px 300 ]
                [ Input.button
                    [ padding 10
                    , Background.color <| rgb 1 1 1
                    , Border.rounded 100
                    , Font.size 50
                    ]
                    { label = text "👽", onPress = Just Fire }
                , el
                    [ paddingXY 20 10
                    , Background.color <| rgb 1 1 1
                    , Border.rounded 100
                    , Font.size 50
                    , alignRight
                    ]
                  <|
                    text <|
                        String.fromInt model.count
                ]
            , Input.button
                [ Font.size 100
                , moveRight model.obj1x
                , htmlAttribute <| Html.Attributes.style "transition" "transform 100ms"
                , case model.obj1Moving of
                    Left ->
                        rotate 0

                    Right ->
                        rotate 0.6
                ]
                { label = text "🛸", onPress = Just Increment }
            ]


main : Program () Model Msg
main =
    Browser.element
        { init = \() -> init
        , view = view
        , update = update
        , subscriptions = \_ -> Browser.Events.onAnimationFrame Tick
        }
