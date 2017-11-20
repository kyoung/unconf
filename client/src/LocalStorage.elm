port module LocalStorage exposing (..)


port setModel : String -> Cmd msg


port getModel : (String -> msg) -> Sub msg
