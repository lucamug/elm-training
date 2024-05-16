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
    , pause : Bool
    }


init : ( Model, Cmd msg )
init =
    ( { count = startingPoint
      , inputValue = "Initial value"
      , posix = Time.millisToPosix 0
      , obj1x = 0
      , obj1Moving = Right
      , projectiles = []
      , pause = False
      }
    , Cmd.none
    )


type Msg
    = Increment
    | Fire
    | GotNewText String
    | Tick Time.Posix
    | TogglePause


startingPoint =
    10


speedAliens : number
speedAliens =
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
                | count = model.count - 5
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
                    if model.obj1x > 280 then
                        Left

                    else if model.obj1x < 0 then
                        Right

                    else
                        model.obj1Moving
                , projectiles =
                    model.projectiles
                        |> List.map (\( y, x ) -> ( y + speedAliens, x ))
                        |> List.filter alienStillGoingDown
                , count =
                    model.projectiles
                        |> List.filter alienExploding
                        |> (\list -> model.count + List.length list)
              }
            , Cmd.none
            )

        TogglePause ->
            if model.count > 100 || model.count < 0 then
                ( { model
                    | pause = False
                    , count = startingPoint
                    , projectiles = []
                  }
                , Cmd.none
                )

            else
                ( { model | pause = not model.pause }, Cmd.none )


alienStillGoingDown : ( number, number1 ) -> Bool
alienStillGoingDown ( y, x ) =
    y < 450 || (y < 600 && (x < 80 || x > 200))


alienExploding : ( number, number1 ) -> Bool
alienExploding ( y, x ) =
    y > 400 && x > 80 && x < 200


buttonAttrs : List (Attribute msg)
buttonAttrs =
    [ padding 15
    , Background.color <| rgb 1 1 1
    , Border.rounded 100
    , Font.size 50
    ]


view : Model -> Html Msg
view model =
    layout
        [ padding 0
        , Background.color <| rgb 0.1 0.2 0.4
        ]
    <|
        column
            ([ spacing 20
             , centerX
             , inFront <|
                el
                    [ Font.size 160
                    , moveDown 600
                    , moveRight 120
                    ]
                <|
                    text <|
                        if model.count > 100 then
                            "💥"

                        else
                            "🪐"
             ]
                ++ List.map
                    (\( y, x ) ->
                        inFront <|
                            el
                                [ moveDown <| y + 210
                                , moveRight <| x + 40
                                , Font.size <|
                                    if alienExploding ( y, x ) then
                                        60

                                    else
                                        30
                                ]
                            <|
                                text <|
                                    if alienExploding ( y, x ) then
                                        "💥"

                                    else
                                        "👽"
                    )
                    model.projectiles
            )
            [ row [ padding 30, spacing 30 ]
                [ Input.button
                    buttonAttrs
                    { label = text "👽", onPress = Just Fire }
                , Input.button
                    buttonAttrs
                    { label =
                        text <|
                            case model.pause || model.count > 100 || model.count < 0 of
                                True ->
                                    "▶️"

                                False ->
                                    "⏸️"
                    , onPress = Just TogglePause
                    }
                , el
                    (buttonAttrs ++ [ width <| px 120 ])
                  <|
                    el [ centerX ] <|
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
                { label =
                    text <|
                        if model.count < 0 then
                            "💥"

                        else
                            "🛸"
                , onPress = Just Increment
                }
            ]


main : Program () Model Msg
main =
    Browser.element
        { init = \() -> init
        , view = view
        , update = update
        , subscriptions =
            \model ->
                if model.pause || model.count > 100 || model.count < 0 then
                    Sub.none

                else
                    Browser.Events.onAnimationFrame Tick
        }
