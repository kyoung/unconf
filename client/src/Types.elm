module Types exposing (..)

import Http
import Time exposing (..)


type Mode
    = Pitching
    | Schedule


type alias Pitch =
    { text : String
    , uuid : String
    , order : Int
    , votes : Int
    }


type alias Slot =
    { time : String
    , room : String
    , text : String
    }


type alias Model =
    { votes : List String
    , pitches : List Pitch
    , schedule : List Slot
    , mode : Mode
    }


type Msg
    = GotPitches (Result Http.Error (List Pitch))
    | GotVotes (Result Http.Error (List String))
    | PostVote String
    | PostedVote (Result Http.Error (List String))
      --| UpdatePitches
    | UpdateMode Time
    | GotMode (Result Http.Error String)
    | GotSchedule (Result Http.Error (List Slot))
