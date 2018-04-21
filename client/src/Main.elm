module Main exposing (..)

import Html exposing (program)
import State
import Time exposing (..)
import Types exposing (Model, Msg(..))
import View


subscriptions : Model -> Sub Msg
subscriptions model =
    Time.every (Time.second * 15) UpdateMode


main : Program Never Model Msg
main =
    program
        { init = State.init
        , update = State.update
        , subscriptions = subscriptions
        , view = View.root
        }
