module Bingo exposing (..)

import Html as H
import Html.Attributes as HA
import Html.Events exposing (onClick)


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

-- UPDATE

type Msg =
    NewGame
    -- | Mark
    -- | ShareScore


update : Msg -> Model -> Model
update  msg model =
    case msg of
        NewGame ->
            { model | gameNumber = model.gameNumber + 1 }

-- VIEW

playerInfo : String -> Int -> String
playerInfo name gameNumber =
    name ++ " - Game #" ++ (toString gameNumber)


viewPlayer : String -> Int -> H.Html Msg
viewPlayer name gameNumber =
    let
        playerInfoText =
            playerInfo name gameNumber
                |> String.toUpper
                |> H.text
    in
        H.h2 [ HA.id "info", HA.class "classy" ] [ playerInfoText ]


viewHeader : String -> H.Html Msg
viewHeader title =
    H.header []
        [ H.h1 [] [ H.text title ] ]


viewFooter : H.Html Msg
viewFooter =
    H.footer []
        [ H.a [ HA.href "https://github.com/zahradeenie" ] [ H.text "Made by Zahra" ] ]


viewEntryItem : Entry -> H.Html Msg
viewEntryItem entry =
    H.li []
        [ H.span [ HA.class "phrase"] [ H.text entry.phrase ]
        , H.span [ HA.class "points" ] [ H.text (toString entry.points) ]
        ]


viewEntryList : List Entry -> H.Html Msg
viewEntryList entries =
    let
        listOfEntries =
            List.map viewEntryItem entries
    in
        H.ul [] listOfEntries


view : Model -> H.Html Msg
view model =
    H.div [ HA.class "content" ]
        [ viewHeader "Buzzword Bingo"
        , viewPlayer model.name model.gameNumber
        , viewEntryList model.entries
        , H.div [ HA.class "button-group" ]
            [ H.button [ onClick NewGame ] [ H.text "New Game" ] ]
        , H.div [ HA.class "debug" ] [ H.text (toString model) ]
        , viewFooter
        ]


-- main : H.Html Msg
-- main = 
--     view initialModel

main : Program Never Model Msg
main =
    H.beginnerProgram
        { model = initialModel
        , view = view
        , update = update
        }