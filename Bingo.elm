module Bingo exposing (..)

import Html as H
import Html.Attributes as HA

playerInfo : String -> Int -> String
playerInfo name gameNumber =
    name ++ " - Game #" ++ (toString gameNumber)


viewPlayer : String -> Int -> H.Html msg
viewPlayer name gameNumber =
    let
        playerInfoText =
            playerInfo name gameNumber
                |> String.toUpper
                |> H.text
    in
        H.h2 [ HA.id "info", HA.class "classy" ] [ playerInfoText ]


viewHeader : String -> H.Html msg
viewHeader title =
    H.header []
        [ H.h1 [] [ H.text title ] ]


viewFooter : H.Html msg
viewFooter =
    H.footer []
        [ H.a [ HA.href "https://github.com/zahradeenie" ] [ H.text "Made by Zahra" ] ]

view : H.Html msg
view =
    H.div [ HA.class "content" ]
        [ viewHeader "Buzzword Bingo"
        , viewPlayer "Zahra" 3
        , viewFooter
        ]


main : H.Html msg
main = 
    view
