module View exposing (displaySlot, displayTimes, listPitches, listSchedule, pitchElement, root, voteDot)

import Html exposing (Html, div, img, p, span, text)
import Html.Attributes exposing (class, src)
import Html.Events exposing (onClick)
import Set
import Types exposing (Mode(..), Model, Msg, Pitch, Slot)


root : Model -> Html Msg
root model =
    case model.mode of
        Pitching ->
            div [] [ listPitches model ]

        Schedule ->
            div [] [ listSchedule model ]

        Unknown ->
            div [] []


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
                (displayTimes model.votes model.schedule)
                times
            , [ div [ class "schedule-map" ] [ img [ src "/static/map.png" ] [] ] ]
            ]
        )


displayTimes : List String -> List Slot -> String -> Html Msg
displayTimes votes slots time =
    div [ class "slot-time-block" ]
        (List.append
            [ div [ class "slot-time" ] [ text time ] ]
            (List.map
                (displaySlot votes)
                (List.filter (\c -> c.time == time) slots)
            )
        )


displaySlot : List String -> Slot -> Html Msg
displaySlot votes slot =
    div [ class "slot" ]
        [ div [ class "slot-room" ] [ text slot.room ]
        , div [ class "slot-text" ] [ text slot.text ]
        , div [ class "slot-speaker" ] [ text ("Pitched by: " ++ slot.author) ]
        , if List.member slot.uuid votes then
            div [ class "voted-slot" ] [ text "voted" ]

          else
            div [] []
        ]


listPitches : Model -> Html Msg
listPitches model =
    if List.length model.pitches > 0 then
        div [ class "pitches" ]
            (List.map (pitchElement model.votes) (List.sortBy .order model.pitches))

    else
        div [ class "pitches" ]
            [ p [ class "no-pitches" ] [ text "No pitches yet." ]
            , p [] [ text "Maybe talk about that time you fixed that thing" ]
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
        , p [ class "pitch-author" ] [ text ("Pitched by: " ++ pitch.author) ]
        , div [ class "voting-dots" ] (List.map voteDot (List.repeat pitch.votes ""))
        ]


voteDot : String -> Html Msg
voteDot vote =
    span [ class "vote-dots" ] [ text "⬤" ]
