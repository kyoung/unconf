module View exposing (..)

import Html exposing (Html, div, img, p, span, text)
import Html.Attributes exposing (class, src)
import Html.Events exposing (onClick)
import Set
import Types exposing (Mode(..), Model, Msg, Pitch, Slot)


root : Model -> Html Msg
root model =
    if model.mode == Pitching then
        div []
            [ listPitches model ]
    else
        div [] [ listSchedule model ]


listSchedule : Model -> Html Msg
listSchedule model =
    let
        times =
            List.map (\s -> s.time) model.schedule
                |> Set.fromList
                |> Set.toList
    in
    div [ class "schedule" ]
        (List.concat
            [ [ div [ class "schedule-header" ] [ text "Schedule" ] ]
            , List.map
                (displayTimes model.schedule)
                times
            , [ div [ class "schedule-map" ] [ img [ src "/static/map.png" ] [] ] ]
            ]
        )


displayTimes : List Slot -> String -> Html Msg
displayTimes slots time =
    div [ class "slot-time-block" ]
        (List.append
            [ div [ class "slot-time" ] [ text time ] ]
            (List.map
                displaySlot
                (List.filter (\c -> c.time == time) slots)
            )
        )


displaySlot : Slot -> Html Msg
displaySlot slot =
    div [ class "slot" ]
        [ div [ class "slot-room" ] [ text slot.room ]
        , div [ class "slot-text" ] [ text slot.text ]
        ]


listPitches : Model -> Html Msg
listPitches model =
    if List.length model.pitches > 0 then
        div [ class "pitches" ]
            (List.map (pitchElement model.votes) (List.sortBy .order model.pitches))
    else
        div [ class "pitches" ]
            [ p [ class "no-pitches" ] [ text "No pitches yet." ]
            , p [] [ text "Maybe talk about that time you fixed that thing?" ]
            ]


pitchElement : List String -> Pitch -> Html Msg
pitchElement votes pitch =
    div
        [ class "pitch"
        , onClick (Types.PostVote pitch.uuid)
        ]
        [ div
            [ class
                (if List.member pitch.uuid votes then
                    "selected"
                 else
                    "unselected"
                )
            ]
            []
        , span [ class "select-notice" ]
            [ if List.member pitch.uuid votes then
                text "selected"
              else
                text ""
            ]
        , p [] [ text pitch.text ]
        , div [ class "voting-dots" ] (List.map voteDot (List.repeat pitch.votes ""))
        ]


voteDot : String -> Html Msg
voteDot vote =
    span [ class "vote-dots" ] [ text "⬤" ]
