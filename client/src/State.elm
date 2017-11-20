module State exposing (..)

import Json.Decode exposing (list, string)
import Types exposing (Model, Msg, Pitch)


init : ( Model, Cmd Msg )
init =
    ( { pitches = [], votes = [] }
    , Cmd Msg
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update action model =
    case action of
        OnLoad ->
            ( model, Cmd.none )

        GetPitches ->
            ( model, getPitches )

        GetVotes ->
            ( model, Cmd.none )

        GotPitches ( Ok, List Pitch ) ->
            ( model, Cmd.none )

        GotPitches (Err _) ->
            ( model, Cmd.none )

        GotVotes ( Ok, List String ) ->
            ( model, Cmd.none )

        GotVotes (Err _) ->
            ( model, Cmd.none )

        PostVote ( Ok, List String ) ->
            ( model, Cmd.none )

        PostVote (Err _) ->
            ( model, Cmd.none )


getPitches : Cmd Msg
getPitches =
    let
        url =
            "/pitches/"

        request =
            Http.get url decodePitches
    in
    Http.send GotPitches request


decodePitches : Decode.Decoder List String
decodePitches =
    Decode.at



--bah
