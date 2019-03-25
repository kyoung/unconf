module View exposing (displaySlot, displayTimes, listPitches, listSchedule, pitchElement, root, voteDot)

import Html exposing (Html, div, h1, h3, img, li, p, strong, text, ul)
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
            [ [ h1 [ class "schedule__title" ] [ text "Schedule" ] ]
            , List.map
                (displayTimes model.votes model.schedule)
                times
            , [ div [ class "schedule__map" ]
                    [ h1 [ class "schedule__title" ] [ text "Map" ]
                    , img [ src "/static/map.png" ] []
                    ]
              ]
            ]
        )


displayTimes : List String -> List Slot -> String -> Html Msg
displayTimes votes slots time =
    div [ class "schedule__time" ]
        (List.append
            [ div [ class "schedule__time-banner" ] [ text time ] ]
            (List.map
                (displaySlot votes)
                (List.filter (\c -> c.time == time) slots)
            )
        )


displaySlot : List String -> Slot -> Html Msg
displaySlot votes slot =
    let
        votedMeta =
            if List.member slot.uuid votes then
                li [ class "slot__voted" ] [ text "" ]

            else
                text ""
    in
    div [ class "slot" ]
        [ div
            [ class
                (if List.member slot.uuid votes then
                    "slot__selected"

                 else
                    "slot__unselected"
                )
            ]
            []
        , div [ class "slot__title" ] [ text slot.text ]
        , ul [ class "slot__meta" ]
            [ votedMeta
            , li [ class "slot__room" ] [ text slot.room ]
            , li [ class "slot__author" ] [ text ("Pitched by " ++ slot.author) ]
            ]
        ]


listPitches : Model -> Html Msg
listPitches model =
    if List.length model.pitches > 0 then
        div [ class "pitches" ]
            (List.map (pitchElement model.votes) (List.sortBy .order model.pitches))

    else
        div [ class "no-pitches" ]
            [ h1 [ class "no-pitches__title" ] [ text "No pitches yet." ]
            , p [ class "no-pitches__text" ] [ text "Maybe talk about that time you fixed that thing?" ]
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
                    "pitch__selected"

                 else
                    "pitch__unselected"
                )
            ]
            []
        , h3 [ class "pitch__title" ] [ text pitch.text ]
        , p [ class "pitch__author" ] [ text ("Pitched by " ++ pitch.author) ]
        , ul [ class "votes" ] (List.map voteDot (List.repeat pitch.votes ""))
        ]


voteDot : String -> Html Msg
voteDot vote =
    li [ class "votes__dots" ] []
