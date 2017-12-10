module Commands exposing (..)

import Http
import Json.Decode exposing (Decoder, field, int, list, map4, string)
import Json.Encode exposing (encode, object, string)
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
    map4 Pitch
        (field "text" Json.Decode.string)
        (field "uuid" Json.Decode.string)
        (field "order" int)
        (field "votes" int)


getVotes : Cmd Msg
getVotes =
    Http.get "/pitches/vote/" decodeVotes
        |> Http.send GotVotes


castVote : String -> Cmd Msg
castVote uuid =
    let
        body =
            object [ ( "pitch_uuid", Json.Encode.string uuid ) ]
    in
    Http.post "/pitches/vote/" (Http.jsonBody body) decodeVotes
        |> Http.send PostedVote


decodeVotes : Decoder (List String)
decodeVotes =
    field "votes" (list Json.Decode.string)
