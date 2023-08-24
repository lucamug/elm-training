module Main exposing (..)

import Browser
import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import Html
import Html.Events
import Json.Decode



-- MAIN


main : Program () Model Msg
main =
    Browser.sandbox
        { init = init
        , update = update
        , view = view
        }


type alias Todo =
    { deleted : Bool
    , done : Bool
    , descr : String
    , id : Int
    }


type alias Model =
    { input : String
    , todos : List Todo
    , latestId : Int
    }



-- MODEL


init : Model
init =
    { input = ""
    , todos = []
    , latestId = 0
    }



-- UPDATE


type Msg
    = NewText String
    | AddTodo
    | Delete Int
    | Undelete Int
    | Done Int
    | Undone Int


update : Msg -> Model -> Model
update msg model =
    case msg of
        NewText input ->
            { model | input = input }

        AddTodo ->
            { model
                | todos =
                    { deleted = False
                    , done = False
                    , descr = model.input
                    , id = model.latestId + 1
                    }
                        :: model.todos
                , input = ""
                , latestId = model.latestId + 1
            }

        Delete id ->
            updateTodo (\todo -> { todo | deleted = True }) id model

        Done id ->
            updateTodo (\todo -> { todo | done = True }) id model

        Undelete id ->
            updateTodo (\todo -> { todo | deleted = False }) id model

        Undone id ->
            updateTodo (\todo -> { todo | done = False }) id model


updateTodo : (Todo -> Todo) -> Int -> Model -> Model
updateTodo mapTodo id model =
    { model
        | todos =
            List.map
                (\todo ->
                    if id == todo.id then
                        mapTodo todo

                    else
                        todo
                )
                model.todos
    }


view : Model -> Html.Html Msg
view model =
    layout [ padding 10 ] <|
        column
            [ spacing 20
            , centerX
            , Background.color <| rgb 0.9 0.8 0.8
            , padding 20
            , Border.rounded 10
            ]
            ([ Input.text [ htmlAttribute <| onEnter AddTodo ]
                { label = Input.labelHidden ""
                , onChange = NewText
                , placeholder = Just <| Input.placeholder [] <| text "New TODO"
                , text = model.input
                }
             ]
                ++ viewHelper "TODOs"
                    (\todo -> not todo.deleted && not todo.done)
                    model.todos
                    (\id ->
                        [ Input.button buttonAttrs { label = text "Delete", onPress = Just <| Delete id }
                        , Input.button buttonAttrs { label = text "Done", onPress = Just <| Done id }
                        ]
                    )
                ++ viewHelper "Done"
                    .done
                    model.todos
                    (\id ->
                        [ Input.button buttonAttrs { label = text "Undone", onPress = Just <| Undone id }
                        ]
                    )
                ++ viewHelper "Deleted"
                    .deleted
                    model.todos
                    (\id ->
                        [ Input.button buttonAttrs { label = text "Undelete", onPress = Just <| Undelete id }
                        ]
                    )
            )


buttonAttrs : List (Attribute msg)
buttonAttrs =
    [ Border.width 1
    , Background.color <| rgb 0.8 0.8 0.8
    , Border.color <| rgb 0.5 0.5 0.5
    , padding 6
    , Border.rounded 5
    ]


viewHelper : String -> (Todo -> Bool) -> List Todo -> (Int -> List (Element msg)) -> List (Element msg)
viewHelper title filter todos elements =
    [ el [ Font.size 20 ] <| text title
    , column [ spacing 10 ]
        (List.map
            (\todo ->
                row [ spacing 10 ]
                    (elements todo.id
                        ++ [ text (String.fromInt todo.id)
                           , text " - "
                           , text todo.descr
                           ]
                    )
            )
            (List.filter filter todos)
        )
    ]


onEnter : Msg -> Html.Attribute Msg
onEnter msg =
    Html.Events.on "keydown"
        (Json.Decode.andThen
            (\code ->
                if code == 13 then
                    Json.Decode.succeed msg

                else
                    Json.Decode.fail "not ENTER"
            )
            Html.Events.keyCode
        )
