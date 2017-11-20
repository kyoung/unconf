module Types exposing (..)

import Time exposing (Time)


type alias Pitch =
    { pitch : String
    , id : String
    , created_at : Time
    }


type alias Model =
    { votes : List String
    , pitches : List Pitch
    }


type Msg
    = OnLoad
    | GetPitches
    | GetVotes
    | GotPitches (Result Http.Error String)
    | GotVotes (Result Http.Error String)
    | PostVote (Result Http.Error String)
