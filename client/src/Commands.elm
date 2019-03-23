module Commands exposing (castVote, decodeMode, decodePitch, decodePitches, decodeSchedule, decodeSlot, decodeVotes, getMode, getPitches, getSchedule, getVotes)

import Http
import Json.Decode exposing (Decoder, field, int, list, map3, map4, map5, string)
import Json.Encode exposing (encode, object, string)
import Types exposing (Mode(..), Model, Msg(..), Pitch, Slot)


getSchedule : Cmd Msg
getSchedule =
    Http.get "/pitches/schedule/" decodeSchedule
        |> Http.send GotSchedule


decodeSchedule : Decoder (List Slot)
decodeSchedule =
    field "slots" (list decodeSlot)


decodeSlot : Decoder Slot
decodeSlot =
    map5 Slot
        (field "time" Json.Decode.string)
        (field "room" Json.Decode.string)
        (field "text" Json.Decode.string)
        (field "uuid" Json.Decode.string)
        (field "author" Json.Decode.string)


getPitches : Cmd Msg
getPitches =
    Http.get "/pitches/" decodePitches
        |> Http.send GotPitches


decodePitches : Decoder (List Pitch)
decodePitches =
    field "pitches" (list decodePitch)


decodePitch : Decoder Pitch
decodePitch =
    map5 Pitch
        (field "text" Json.Decode.string)
        (field "uuid" Json.Decode.string)
        (field "order" int)
        (field "votes" int)
        (field "author" Json.Decode.string)


getMode : Cmd Msg
getMode =
    Http.get "/pitches/mode/" decodeMode
        |> Http.send GotMode


decodeMode : Decoder String
decodeMode =
    field "mode" Json.Decode.string


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
