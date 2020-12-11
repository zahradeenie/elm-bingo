module Bingo exposing (..)

import Html as H
import Html.Attributes as HA


-- MODEL

initialModel =
    { name = "Zahra"
    , gameNumber = 1
    , entries = initialEntries
    }

initialEntries =
    [ { id = 1, phrase= "Future-Proof", points = 100, marked = False }
    , { id = 1, phrase= "Doing Agile", points = 200, marked = False }
    ]

-- VIEW

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


-- view : H.Html msg
view model =
    H.div [ HA.class "content" ]
        [ viewHeader "Buzzword Bingo"
        , viewPlayer model.name model.gameNumber
        , H.div [ HA.class "debug" ] [ H.text (toString model) ]
        , viewFooter
        ]


main : H.Html msg
main = 
    view initialModel
