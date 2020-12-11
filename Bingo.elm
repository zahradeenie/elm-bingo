module Bingo exposing (..)

import Html as H
import Html.Attributes as HA


-- MODEL

type alias Model =
    { name : String
    , gameNumber : Int
    , entries : List Entry
    }


type alias Entry = 
    { id : Int
    , phrase : String
    , points : Int
    , marked : Bool
    }


initialModel : Model
initialModel =
    { name = "Zahra"
    , gameNumber = 1
    , entries = initialEntries
    }


initialEntries : List Entry
initialEntries =
    [ Entry 1 "Future-Proof" 100 False
    , Entry 2 "Doing Agile" 200 False
    , Entry 3 "In The Cloud" 300 False
    , Entry 4 "Rock-Star Ninja" 400 False
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


viewEntryItem : Entry -> H.Html msg
viewEntryItem entry =
    H.li []
        [ H.span [ HA.class "phrase"] [ H.text entry.phrase ]
        , H.span [ HA.class "points" ] [ H.text (toString entry.points) ]
        ]


viewEntryList : List Entry -> H.Html msg
viewEntryList entries =
    let
        listOfEntries =
            List.map viewEntryItem entries
    in
        H.ul [] listOfEntries


view : Model -> H.Html msg
view model =
    H.div [ HA.class "content" ]
        [ viewHeader "Buzzword Bingo"
        , viewPlayer model.name model.gameNumber
        , viewEntryList model.entries
        , H.div [ HA.class "debug" ] [ H.text (toString model) ]
        , viewFooter
        ]


main : H.Html msg
main = 
    view initialModel
