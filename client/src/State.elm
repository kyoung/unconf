module State exposing (..)

import Commands exposing (castVote, getPitches, getVotes)
import Types exposing (Model, Msg(..), Pitch)


init : ( Model, Cmd Msg )
init =
    ( { pitches = [], votes = [] }
    , Cmd.batch [ getPitches, getVotes ]
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update action model =
    case action of
        GotPitches (Ok pitches) ->
            ( { model | pitches = pitches }, Cmd.none )

        GotPitches (Err _) ->
            ( model, Cmd.none )

        GotVotes (Ok votes) ->
            ( { model | votes = votes }, Cmd.none )

        GotVotes (Err _) ->
            ( model, Cmd.none )

        PostVote uuid ->
            ( model, castVote uuid )

        PostedVote (Ok votes) ->
            ( { model | votes = votes }, Cmd.none )

        PostedVote (Err _) ->
            ( model, Cmd.none )

        UpdatePitches time ->
            ( model, getPitches )
