module View exposing (..)

import Html exposing (Html, div, p, span, text)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)
import Types exposing (Model, Msg, Pitch)


root : Model -> Html Msg
root model =
    div []
        [ listPitches model ]


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
        [ class
            (if List.member pitch.uuid votes then
                "selected"
             else
                "unselected"
            )
        , onClick (Types.PostVote pitch.uuid)
        ]
        [ span [ class "select-notice" ]
            [ if List.member pitch.uuid votes then
                text "selected"
              else
                text ""
            ]
        , p [] [ text pitch.text ]
        , p [ class "vote-dots" ] [ text (List.foldr (++) "" (List.repeat pitch.votes "⬤")) ]
        ]
