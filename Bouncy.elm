module Bouncy exposing (..)

import Svg exposing (..)
import Svg.Attributes as SA
import Time exposing (Time)


ballRestRadius =
    1.0


relativeAmplitude =
    0.3


phaseSpeed =
    0.008


groundY =
    1.0


type alias Model =
    -- Y is the Y coordinate
    { centerY : Float

    -- multiplies the Y coordinate, 1.0 means no deformation
    , linearDeformationY : Float
    , time : Float
    }


init : Model
init =
    { centerY = 3.0
    , linearDeformationY = 1.0
    , time = 0.0
    }


update : Time -> Model -> Model
update dt model =
    let
        time =
            model.time + dt

        linearDeformationY =
            1.0 + relativeAmplitude * sin (time * phaseSpeed)

        centerY =
            groundY + ballRestRadius * linearDeformationY
    in
        { centerY = centerY
        , linearDeformationY = linearDeformationY
        , time = time
        }


view : Model -> Svg a
view model =
    let
        ry =
            ballRestRadius * model.linearDeformationY

        rx =
            ballRestRadius / model.linearDeformationY
    in
        svg
            [ SA.width "800px"
            , SA.height "600px"
            , SA.viewBox "0 0 12 9"
            , SA.transform "scale(1 -1)"
            ]
            [ ellipse
                [ SA.fill "red"
                , SA.cx "6"
                , SA.cy <| toString model.centerY
                , SA.rx <| toString rx
                , SA.ry <| toString ry
                ]
                []
            , rect
                [ SA.fill "grey"
                , SA.width "12"
                , SA.height <| toString groundY
                ]
                []
            ]
