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


type Direction
    = Left
    | Right


type alias Model =
    { count : Int
    , posix : Time.Posix
    , objectX : Float
    , objectMoving : Direction
    , projectiles : List ( Float, Float )
    , pause : Bool
    }


init : ( Model, Cmd msg )
init =
    ( { count = startingPoint
      , posix = Time.millisToPosix 0
      , objectX = 0
      , objectMoving = Right
      , projectiles = []
      , pause = True
      }
    , Cmd.none
    )


type Msg
    = Increment
    | Fire
    | Tick Time.Posix
    | TogglePause


startingPoint : number
startingPoint =
    20


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
                , projectiles = ( 0, model.objectX ) :: model.projectiles
              }
            , Cmd.none
            )

        Tick posix ->
            ( { model
                | posix = posix
                , objectX =
                    case model.objectMoving of
                        Left ->
                            model.objectX - speedSaucer

                        Right ->
                            model.objectX + speedSaucer
                , objectMoving =
                    if model.objectX > 280 then
                        Left

                    else if model.objectX < 0 then
                        Right

                    else
                        model.objectMoving
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
                , moveRight model.objectX
                , htmlAttribute <| Html.Attributes.style "transition" "transform 100ms"
                , case model.objectMoving of
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
            , if model.pause || model.count > 100 || model.count < 0 then
                column [ width fill, spacing 20 ]
                    [ el
                        [ Font.color <| rgb 1 0.4 0.3
                        , Font.size 40
                        , centerX
                        ]
                      <|
                        text <|
                            if model.count > 100 then
                                "YOU WIN!"

                            else if model.count < 0 then
                                "GAME OVER"

                            else
                                ""
                    , Input.button
                        (buttonAttrs ++ [ centerX, paddingXY 30 10 ])
                        { label = text "PLAY"
                        , onPress = Just TogglePause
                        }
                    ]

              else
                none
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
