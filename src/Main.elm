module Main exposing (main)

import Browser
import Browser.Events
import Element exposing (..)
import Element.Border as Border
import Element.Input as Input
import Html exposing (Html)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Time


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
    2


speed : number
speed =
    2


update : Msg -> Model -> ( Model, Cmd msg )
update msg model =
    case msg of
        Increment ->
            ( { model | count = model.count + 1 }, Cmd.none )

        Fire ->
            ( { model
                | count = model.count - 1
                , projectiles = ( 40, model.obj1x + 60 ) :: model.projectiles
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
                            model.obj1x - speed

                        Right ->
                            model.obj1x + speed
                , obj1Moving =
                    if model.obj1x > 200 then
                        Left

                    else if model.obj1x < 0 then
                        Right

                    else
                        model.obj1Moving
                , projectiles =
                    model.projectiles
                        |> List.map (\( y, x ) -> ( y + speedFire, x ))
                        |> List.filter (\( y, _ ) -> y < 300)

                -- , obj1y = model.obj1y + 0
              }
            , Cmd.none
            )


view : Model -> Html Msg
view model =
    layout [ padding 40 ] <|
        column [ spacing 20 ]
            -- [ text <| String.fromInt <| Time.posixToMillis model.posix
            [ column
                ([ spacing 20 ]
                    ++ List.map
                        (\( y, x ) ->
                            inFront <| el [ moveDown y, moveRight x ] <| text <| "☂️"
                        )
                        model.projectiles
                )
                [ Input.button
                    [ padding 20
                    , Border.width 1
                    , moveRight model.obj1x
                    ]
                    { label = text "Increment", onPress = Just Increment }
                , Input.button
                    [ padding 20
                    , Border.width 1
                    ]
                    { label = text "Fire", onPress = Just Fire }
                , text <| String.fromInt model.count
                ]
            ]


main : Program () Model Msg
main =
    Browser.element
        { init = \() -> init
        , view = view
        , update = update
        , subscriptions = \_ -> Browser.Events.onAnimationFrame Tick
        }
