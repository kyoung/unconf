module View exposing (..)

import Html exposing (Html, div, text)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)
import Types exposing (Model, Msg, Pitch)


root : Model -> Html Msg
root model =
    div []
        [ text "Unconf Pitches"
        , listPitches model
        ]


listPitches : Model -> Html Msg
listPitches model =
    div []
        (List.map (pitchElement model.votes) (List.sortBy .order model.pitches))


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
        [ text pitch.text ]
