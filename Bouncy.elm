module Bouncy exposing (..)

import Svg exposing (..)
import Svg.Attributes as SA
import Time exposing (Time)


ballRestRadius =
    1.0


elasticCoefficient =
    30.0


groundY =
    1.0


maxLinearDeformation =
    3.0


minLinearDeformation =
    1.0 / maxLinearDeformation


type alias Model =
    -- Y is the Y coordinate
    -- Yt is dY/dt, ie the speed
    { centerY : Float
    , centerYt : Float

    -- multiplies the Y coordinate, 1.0 means no deformation
    , linearDeformationY : Float
    }


init : Model
init =
    { centerY = 3.0
    , centerYt = 0.0
    , linearDeformationY = 1.0
    }


update : Time -> Model -> Model
update dt model =
    let
        -- position update
        maxCenterY =
            50

        minCenterY =
            groundY + ballRestRadius * minLinearDeformation

        centerY =
            clamp minCenterY maxCenterY <| model.centerY + model.centerYt * dt

        -- deformation update
        restBottomY =
            centerY - ballRestRadius

        -- arbitrarily preventing the ball to expand beyond rest position
        maxLinearDeformationY =
            1.0

        linearDeformationY =
            clamp minLinearDeformation maxLinearDeformationY <| ballRestRadius - (groundY - restBottomY) / ballRestRadius

        springOffsetY =
            ballRestRadius * (1.0 - linearDeformationY)

        -- forces
        gravityForce =
            -1

        upwardExpansionForce =
            max 0 <| elasticCoefficient * springOffsetY

        -- mass
        m =
            500000

        -- acceleration
        a =
            (gravityForce + upwardExpansionForce) / m

        -- update speed
        centerYt =
            model.centerYt + a * dt
    in
        { centerY = centerY
        , centerYt = centerYt
        , linearDeformationY = linearDeformationY
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
