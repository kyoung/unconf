module Types exposing (Mode(..), Model, Msg(..), Pitch, Slot)

import Http
import Time exposing (..)


type Mode
    = Pitching
    | Schedule
    | Unknown


type alias Pitch =
    { text : String
    , uuid : String
    , order : Int
    , votes : Int
    , author : String
    }


type alias Slot =
    { time : String
    , room : String
    , text : String
    , uuid : String
    , author : String
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
    | UpdateMode Time.Posix
    | GotMode (Result Http.Error String)
    | GotSchedule (Result Http.Error (List Slot))
