module Main exposing (main, subscriptions)

import Browser exposing (element)
import State
import Time exposing (..)
import Types exposing (Model, Msg(..))
import View


subscriptions : Model -> Sub Msg
subscriptions model =
    Time.every 2000 UpdateMode


main : Program () Model Msg
main =
    element
        { init = State.init
        , update = State.update
        , subscriptions = subscriptions
        , view = View.root
        }
