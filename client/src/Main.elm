module Main exposing (..)

import Html exposing (program)
import State
import Types exposing (Model, Msg(..))
import View


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


main : Program Never Model Msg
main =
    program
        { init = State.init
        , update = State.update
        , subscriptions = subscriptions
        , view = View.root
        }
