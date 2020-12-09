module Bingo exposing (..)

import Html as H
import Html.Attributes as HA


playerInfo name gameNumber =
    name ++ " - Game #" ++ (toString gameNumber)

viewPlayer name gameNumber =
    let
        playerInfoText =
            playerInfo name gameNumber
                |> String.toUpper
                |> H.text
    in
        H.h2 [ HA.id "info", HA.class "classy" ] [ playerInfoText ]

viewHeader title =
    H.header []
        [ H.h1 [] [ H.text title ] ]

viewFooter =
    H.footer []
        [ H.a [ HA.href "https://github.com/zahradeenie" ] [ H.text "Made by Zahra" ] ]


view =
    H.div [ HA.class "content" ]
        [ viewHeader "Buzzword Bingo"
        , viewPlayer "Zahra" 3
        , viewFooter
        ]

main =
    view
