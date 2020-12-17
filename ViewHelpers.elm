module ViewHelpers exposing (..)

import Html as H
import Html.Attributes as HA
import Html.Events exposing (onClick, onInput)


primaryButton : msg -> String -> H.Html msg
primaryButton msg name =
    H.button [ HA.class "primary", onClick msg ] [ H.text name ]


alert : msg -> Maybe String -> H.Html msg
alert msg alertMessage  =
    case alertMessage of
        Just message ->
            H.div [ HA.class "alert" ]
                [ H.span [ HA.class "close", onClick msg ] [ H.text "x"]
                , H.text message
                ]
        Nothing ->
            H.text ""
