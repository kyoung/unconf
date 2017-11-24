module Commands exposing (..)

import Http
import Json.Decode exposing (Decoder, field, int, list, map3, string)
import Types exposing (Model, Msg(..), Pitch)


getPitches : Cmd Msg
getPitches =
    Http.get "/pitches/" decodePitches
        |> Http.send GotPitches


decodePitches : Decoder (List Pitch)
decodePitches =
    field "pitches" (list decodePitch)


decodePitch : Decoder Pitch
decodePitch =
    map3 Pitch
        (field "text" string)
        (field "uuid" string)
        (field "order" int)


getVotes : Cmd Msg
getVotes =
    Http.get "/pitches/vote/" decodeVotes
        |> Http.send GotVotes


decodeVotes : Decoder (List String)
decodeVotes =
    field "votes" (list string)
