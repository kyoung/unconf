module Types exposing (..)

import Http


type alias Pitch =
    { text : String
    , uuid : String
    , order : Int
    }


type alias Model =
    { votes : List String
    , pitches : List Pitch
    }


type Msg
    = GotPitches (Result Http.Error (List Pitch))
    | GotVotes (Result Http.Error (List String))
    | PostVote String
    | PostedVote (Result Http.Error (List String))
