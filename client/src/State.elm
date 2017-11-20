module State exposing (..)

import Types exposing (Model, Pitch)


init : ( Model, Cmd Msg )
init =
    ( { uuid = "0", votes = [] }
    , Cmd Msg
    )
