module Types exposing (..)


type alias Pitch =
    { pitch : String
    , vote : Bool
    }


type alias Model =
    { uuid : String
    , votes : List Pitch
    }
