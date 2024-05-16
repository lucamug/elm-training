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

https://ellie-app.com/r8KRwr5sQw9a1