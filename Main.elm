module Main exposing (..)

import AnimationFrame
import Bouncy
import Html exposing (Html)
import Time exposing (Time)


type alias Model =
    { bouncy : Bouncy.Model }


type Msg
    = OnAnimationFrame Time


init : Model
init =
    { bouncy = Bouncy.init
    }


update : Msg -> Model -> Model
update msg model =
    case msg of
        OnAnimationFrame dt ->
            { model | bouncy = Bouncy.update dt model.bouncy }


view : Model -> Html Msg
view model =
    Bouncy.view model.bouncy


main =
    Html.program
        { init = ( init, Cmd.none )
        , update = \msg model -> ( update msg model, Cmd.none )
        , view = view
        , subscriptions = \model -> AnimationFrame.diffs OnAnimationFrame
        }
