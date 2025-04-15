# Assets

## Emoji

 💥 🪐 👽 ▶️ ⏸️ 🛸

## Packages

* mdgriffith/elm-ui
* elm/time

## Code

alienStillGoingDown ( y, x ) =
    y < 450 || (y < 600 && (x < 80 || x > 200))

alienExploding ( y, x ) =
    y > 400 && x > 80 && x < 200
    
htmlAttribute <| Html.Attributes.style "transition" "transform 100ms"
    
el [ Font.color <| rgb 1 1 1, Font.size 50 ] <| text <| "FPS " ++ String.fromInt (round (1000 / model.delta))
    
## Alternative

isColliding : ( number, a ) -> Bool
isColliding ( x, y ) =
    x > 100 && x < 200


removeFromTheGame : ( Float, Float ) -> Bool
removeFromTheGame ( x, y ) =
    (isColliding ( x, y ) && y > 430) || (y > 800)
    
## Imports

import Browser
import Browser.Events
import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import Html
import Html.Attributes
import Time

## Functions

Browser.Events.onAnimationFrame

https://package.elm-lang.org/packages/elm/browser/1.0.2/Browser-Events#onAnimationFrame

## Ellie

https://ellie-app.com/vb9hLbdn9Xda1

## FP_HCMUT - Vietnam University Lecture

https://github.com/lucamug/FP_HCMUT

## All

```
module Main exposing (main)

import Browser
import Browser.Events
import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import Html
import Html.Attributes



-- 💥 🪐 👽 ▶️ ⏸️ 🛸


type State
    = Playing
    | Over
    | Paused
    | Won


type Direction
    = Left
    | Right


type alias Model =
    { points : Int
    , positionX : Float
    , positionY : Float
    , direction : Direction
    , state : State
    , aliens : List ( Float, Float )
    }


init : ( Model, Cmd msg )
init =
    ( { points = 10
      , positionX = 0
      , positionY = 0
      , direction = Right
      , state = Playing
      , aliens = []
      }
    , Cmd.none
    )


type Msg
    = Increment
    | Fire
    | OnAnimationFrame Float
    | TogglePause


speedX : Float
speedX =
    5


speedY : Float
speedY =
    10


speedAlien : Float
speedAlien =
    4


update : Msg -> Model -> ( Model, Cmd msg )
update msg model =
    case msg of
        Increment ->
            ( { model | points = model.points + 1 }, Cmd.none )

        Fire ->
            ( { model
                | aliens = ( model.positionX, model.positionY ) :: model.aliens
              }
            , Cmd.none
            )

        OnAnimationFrame delta ->
            let
                newPoints =
                    model.aliens
                        |> List.map
                            (\( alienX, alienY ) -> ( alienX, alienY + speedAlien ))
                        |> List.filter
                            (\( alienX, alienY ) -> hitTargetEnd ( alienX, alienY ))
                        |> List.length
                        |> (\qtyAliensThatHitTarget -> model.points - qtyAliensThatHitTarget)
            in
            ( { model
                | positionX =
                    case model.direction of
                        Left ->
                            model.positionX - speedX

                        Right ->
                            model.positionX + speedX
                , positionY =
                    if model.positionX > 270 || model.positionX < 0 then
                        model.positionY + speedY

                    else
                        model.positionY
                , direction =
                    if model.positionX > 270 then
                        Left

                    else if model.positionX < 0 then
                        Right

                    else
                        model.direction
                , aliens =
                    model.aliens
                        |> List.map
                            (\( alienX, alienY ) -> ( alienX, alienY + speedAlien ))
                        |> List.filter
                            (\( _, alienY ) -> alienY < 500)
                        |> List.filter
                            (\( alienX, alienY ) -> not (hitTargetEnd ( alienX, alienY )))
                , points =
                    newPoints
                , state =
                    if newPoints == 0 then
                        Won

                    else if model.positionY == 330 && model.positionX < 185 then
                        Over

                    else
                        model.state
              }
            , Cmd.none
            )

        TogglePause ->
            ( { model
                | state =
                    case model.state of
                        Playing ->
                            Paused

                        Over ->
                            Over

                        Paused ->
                            Playing

                        Won ->
                            Won
              }
            , Cmd.none
            )


hitTargetStart : ( Float, Float ) -> Bool
hitTargetStart ( alienX, alienY ) =
    alienY > 320 && within { min = 100, max = 200 } ( alienX, alienY )


hitTargetEnd : ( Float, Float ) -> Bool
hitTargetEnd ( alienX, alienY ) =
    alienY > 370 && within { min = 100, max = 200 } ( alienX, alienY )


within : { min : Float, max : Float } -> ( Float, Float ) -> Bool
within { min, max } ( alienX, _ ) =
    min < alienX && alienX < max


attrsButton : List (Attribute msg)
attrsButton =
    [ Border.width 1
    , paddingXY 20 10
    , Border.rounded 100
    , Background.color <| rgb 1 1 1
    , Font.size 40
    ]


view : Model -> Html.Html Msg
view model =
    layout [ padding 20, Background.color <| rgb 0 0.4 0.6 ] <|
        column
            ([ spacing 20
             ]
                ++ [ inFront <|
                        el
                            [ Font.size 150
                            , moveDown 450
                            , moveRight 100
                            ]
                        <|
                            text "🪐"
                   ]
                ++ List.map
                    (\( alienX, alienY ) ->
                        inFront <|
                            el
                                [ Font.size 30
                                , moveRight (alienX + 30)
                                , moveDown (alienY + 120)
                                ]
                            <|
                                text
                                    (if hitTargetStart ( alienX, alienY ) then
                                        "💥"

                                     else
                                        "👽"
                                    )
                    )
                    model.aliens
                ++ (if model.state == Over then
                        [ inFront <|
                            el
                                (attrsButton
                                    ++ [ moveDown 200
                                       , moveRight 50
                                       ]
                                )
                            <|
                                text "Game Over!"
                        ]

                    else if model.state == Won then
                        [ inFront <|
                            el
                                (attrsButton
                                    ++ [ moveDown 200
                                       , moveRight 50
                                       ]
                                )
                            <|
                                text "You Win!"
                        ]

                    else
                        []
                   )
             -- ++ [ inFront <|
             --         paragraph
             --             [ moveDown 100, Font.color <| rgb 1 1 1 ]
             --             [ text <|
             --                 Debug.toString model
             --             ]
             --    ]
            )
            [ row [ spacing 40 ]
                [ Input.button attrsButton
                    { onPress = Just Fire
                    , label = text "👽"
                    }
                , Input.button attrsButton
                    { onPress = Just TogglePause
                    , label =
                        text <|
                            case model.state of
                                Playing ->
                                    "⏸️"

                                Over ->
                                    "-"

                                Paused ->
                                    "▶️"

                                Won ->
                                    "-"
                    }
                , el attrsButton <| text <| String.fromInt model.points
                ]
            , Input.button
                [ moveRight model.positionX
                , moveDown model.positionY
                , Font.size 100
                , case model.direction of
                    Left ->
                        rotate 0

                    Right ->
                        rotate 0.6
                , htmlAttribute <| Html.Attributes.style "transition" "transform 100ms"
                ]
                { onPress = Just Increment
                , label =
                    text
                        (if model.state == Over then
                            "💥"

                         else
                            "🛸"
                        )
                }
            ]


main : Program () Model Msg
main =
    Browser.element
        { init = \_ -> init
        , view = view
        , update = update
        , subscriptions =
            \model ->
                case model.state of
                    Playing ->
                        Browser.Events.onAnimationFrameDelta OnAnimationFrame

                    Over ->
                        Sub.none

                    Paused ->
                        Sub.none

                    Won ->
                        Sub.none
        }
```