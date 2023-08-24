module Main exposing (..)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
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


view : Model -> Html Msg
view model =
    div []
        ([ div []
            [ input
                [ onInput NewText
                , value model.input
                , onEnter AddTodo
                ]
                [ text "-" ]
            , button [ onClick AddTodo ] [ text "Add TODO" ]
            ]
         ]
            ++ viewHelper "TODOs"
                (\todo -> not todo.deleted && not todo.done)
                model.todos
                (\id ->
                    [ button [ onClick (Delete id) ] [ text "Delete" ]
                    , button [ onClick (Done id) ] [ text "Done" ]
                    ]
                )
            ++ viewHelper "Done"
                .done
                model.todos
                (\id ->
                    [ button [ onClick (Undone id) ] [ text "Undone" ] ]
                )
            ++ viewHelper "Deleted"
                .deleted
                model.todos
                (\id ->
                    [ button [ onClick (Undelete id) ] [ text "Undelete" ] ]
                )
        )


viewHelper : String -> (Todo -> Bool) -> List Todo -> (Int -> List (Html msg)) -> List (Html msg)
viewHelper title filter todos elements =
    [ h2 [] [ text title ]
    , div []
        (List.map
            (\todo ->
                div []
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


onEnter : Msg -> Attribute Msg
onEnter msg =
    on "keydown"
        (Json.Decode.andThen
            (\code ->
                if code == 13 then
                    Json.Decode.succeed msg

                else
                    Json.Decode.fail "not ENTER"
            )
            keyCode
        )
