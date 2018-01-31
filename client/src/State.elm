module State exposing (..)

import Commands exposing (castVote, getMode, getPitches, getSchedule, getVotes)
import Types exposing (Mode(..), Model, Msg(..), Pitch)


init : ( Model, Cmd Msg )
init =
    ( { pitches = [], votes = [], schedule = [], mode = Pitching }
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

        UpdateMode time ->
            ( model, getMode )

        GotMode (Ok mode) ->
            let
                newMode =
                    if mode == "Schedule" then
                        Schedule
                    else
                        Pitching
            in
            ( { model | mode = newMode }
            , if newMode == Pitching then
                getPitches
              else
                getSchedule
            )

        GotMode (Err _) ->
            ( model, Cmd.none )

        GotSchedule (Ok schedule) ->
            ( { model | schedule = schedule }, Cmd.none )

        GotSchedule (Err _) ->
            ( model, Cmd.none )
