module Main exposing (main)

import Browser
import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Input as Input
import Html


type alias Model =
    { count : Int
    , todos : List String
    , newTodo : String
    }


type Msg
    = Increment
    | Decrement
    | Completed String
    | UserChangedTheNewTodo String
    | Add
    | UserChangedTheExistingTodo String


init : Model
init =
    { count = 0
    , todos =
        [ "todo 1"
        , "todo 2"
        , "todo 3"
        , "todo 4"
        , "todo 5"
        ]
    , newTodo = ""
    }


update : Msg -> Model -> Model
update msg model =
    case msg of
        Increment ->
            { model | count = model.count + 1 }

        Decrement ->
            { model | count = model.count - 1 }

        Completed string ->
            { model | todos = List.filter (\todo -> todo /= string) model.todos }

        UserChangedTheNewTodo string ->
            { model | newTodo = string }

        Add ->
            { model
                | todos = model.newTodo :: model.todos
                , newTodo = ""
            }


view : Model -> Html.Html Msg
view model =
    layout [ padding 20 ]
        (column [ Element.spacing 10 ]
            [ text (String.fromInt model.count)
            , Input.button
                [ Border.width 1, padding 10, Border.rounded 10, Background.color <| rgba255 0 0 0 0.1 ]
                { onPress = Just Increment
                , label = text "Increment"
                }
            , Input.button
                [ Border.width 1, padding 10, Border.rounded 10, Background.color <| rgba255 0 0 0 0.1 ]
                { onPress = Just Decrement
                , label = text "Decrement"
                }
            , row [ spacing 10 ]
                [ html <| Html.input [] []
                , Input.text []
                    { onChange = UserChangedTheNewTodo
                    , text = model.newTodo
                    , placeholder = Nothing
                    , label = Input.labelLeft [] (text "New Todo")
                    }
                , Input.button
                    [ Border.width 1, padding 10, Border.rounded 10, Background.color <| rgba255 0 0 0 0.1 ]
                    { onPress = Just Add
                    , label = text "Add"
                    }
                ]
            , column [ spacing 10 ]
                (List.map
                    (\todo ->
                        row [ spacing 20 ]
                            [ Input.text []
                                { onChange = UserChangedTheExistingTodo
                                , text = todo
                                , placeholder = Nothing
                                , label = Input.labelLeft [] (text "Edit")
                                }
                            , Input.button
                                [ Border.width 1, padding 10, Border.rounded 10, Background.color <| rgba255 0 0 0 0.1 ]
                                { onPress = Just (Completed todo)
                                , label = text "Completed"
                                }
                            ]
                    )
                    model.todos
                )
            ]
        )


main : Program () Model Msg
main =
    Browser.sandbox
        { init = init
        , view = view
        , update = update
        }



-- Nested TEA (The Elm Architecture)
