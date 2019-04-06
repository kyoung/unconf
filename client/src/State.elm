module State exposing (init, update)

import Commands exposing (castVote, getMode, getPitches, getSchedule, getVotes)
import Types exposing (Mode(..), Model, Msg(..), Pitch)


init : () -> ( Model, Cmd Msg )
init _ =
    ( { pitches = [], votes = [], schedule = [], mode = Unknown }
    , Cmd.batch [ getMode, getPitches, getVotes ]
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update action model =
    case action of
        GotPitches (Ok pitches) ->
            ( { model | pitches = pitches }, getVotes )

        GotPitches (Err _) ->
            ( model, Cmd.none )

        GotVotes (Ok votes) ->
            ( { model | votes = votes }, Cmd.none )

        GotVotes (Err _) ->
            ( model, Cmd.none )

        PostVote uuid ->
            ( model, castVote uuid )

        PostedVote (Ok votes) ->
            ( { model | votes = votes }, getVotes )

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
