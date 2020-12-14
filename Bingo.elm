module Bingo exposing (..)

import Html as H
import Html.Attributes as HA
import Html.Events exposing (onClick)
import Random
import Http
import Json.Decode as Decode exposing (Decoder, field, succeed)


-- MODEL

type alias Model =
    { name : String
    , gameNumber : Int
    , entries : List Entry
    , alertMessage : Maybe String
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
    , entries = []
    , alertMessage = Nothing
    }


-- UPDATE

type Msg
    = NewGame
    | Mark Int
    | Sort
    | NewEntries (Result Http.Error (List Entry))
    | CloseAlert
    -- | ShareScore


update : Msg -> Model -> ( Model, Cmd Msg )
update  msg model =
    case msg of
        NewGame ->
            ( { model | gameNumber = model.gameNumber + 1 }, getEntries )

        Mark id ->
            let
                markEntry e =
                    if e.id == id then
                        { e | marked = (not e.marked) }
                    else
                        e
            in
                ( { model | entries = List.map markEntry model.entries }, Cmd.none )

        Sort ->
            ( { model | entries = List.sortBy .points model.entries}, Cmd.none )

        NewEntries (Ok randomEntries) ->
            ( { model | entries = randomEntries }, Cmd.none)

        NewEntries (Err error) ->
            let
                errorMessage =
                    case error of
                        Http.NetworkError ->
                            "Server is not running"

                        Http.BadStatus response ->
                            (toString response.status)

                        Http.BadPayload message _ ->
                            "Decoding failed: " ++ message

                        _ ->
                            (toString error)
            in
            ( { model | alertMessage = Just errorMessage }, Cmd.none)
        
        CloseAlert -> 
            ( { model | alertMessage = Nothing }, Cmd.none)


-- DECODERS

entryDecoder : Decoder Entry
entryDecoder =
    Decode.map4 Entry
        (field "id" Decode.int)
        (field "phrase" Decode.string)
        (field "points" Decode.int)
        (succeed False)


-- COMMANDS

entriesUrl : String
entriesUrl =
    "http://localhost:3000/random-entries"


getEntries : Cmd Msg
getEntries =
    (Decode.list entryDecoder)
    |> Http.get entriesUrl
    |> Http.send NewEntries


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
    H.li [ HA.classList [ ("marked", entry.marked) ], onClick (Mark entry.id) ]
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


sumMarkedPoints : List Entry -> Int
sumMarkedPoints entries =
    entries
        |> List.filter .marked
        |> List.map .points
        |> List.sum


viewScore : Int -> H.Html Msg
viewScore sum =
    H.div [ HA.class "score" ]
        [ H.span [ HA.class "label" ] [ H.text "Score" ]
        , H.span [ HA.class "value" ] [ H.text (toString sum) ]
        ]


viewAlertMessage : Maybe String -> H.Html Msg
viewAlertMessage alertMessage =
    case alertMessage of
        Just message ->
            H.div [ HA.class "alert" ]
                [ H.span [ HA.class "close", onClick CloseAlert ] [ H.text "x"]
                , H.text message
                ]
        Nothing ->
            H.text ""


view : Model -> H.Html Msg
view model =
    H.div [ HA.class "content" ]
        [ viewHeader "Buzzword Bingo"
        , viewPlayer model.name model.gameNumber
        , viewAlertMessage model.alertMessage
        , viewEntryList model.entries
        , viewScore (sumMarkedPoints model.entries)
        , H.div [ HA.class "button-group" ]
            [ H.button [ onClick NewGame ] [ H.text "New Game" ]
            , H.button [ onClick Sort ] [ H.text "Sort" ] ]
        , H.div [ HA.class "debug" ] [ H.text (toString model) ]
        , viewFooter
        ]


-- main : H.Html Msg
-- main = 
--     view initialModel

main : Program Never Model Msg
main =
    H.program
        { init = ( initialModel, getEntries)
        , view = view
        , update = update
        , subscriptions = (\_ -> Sub.none )
        }