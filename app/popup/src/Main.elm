port module Main exposing (main)

import Browser
import Css exposing (backgroundColor, color, hex, minWidth, padding, px)
import Html.Styled exposing (Html, div, text, toUnstyled)
import Html.Styled.Attributes exposing (css)
import Json.Decode exposing (Decoder, Value, decodeValue, field, int, map3, string)


port receiveMessage : (Value -> msg) -> Sub msg


type alias PomodoroText =
    { operator : String
    , time : Int
    , content : String
    }


init : PomodoroText -> ( PomodoroText, Cmd Msg )
init flags =
    ( PomodoroText flags.operator flags.time flags.content
    , Cmd.none
    )


type Msg
    = Interval Value


decoder : Decoder PomodoroText
decoder =
    map3 PomodoroText
        (field "operator" string)
        (field "time" int)
        (field "content" string)


update : Msg -> PomodoroText -> ( PomodoroText, Cmd Msg )
update msg _ =
    case msg of
        Interval value ->
            case decodeValue decoder value of
                Ok model ->
                    ( model, Cmd.none )

                Err _ ->
                    ( PomodoroText "" 0 "", Cmd.none )


view : PomodoroText -> Html Msg
view model =
    div
        [ css
            [ padding (px 10)
            , backgroundColor (hex "#000")
            , color (hex "#fff")
            , minWidth (px 80)
            ]
        ]
        [ text model.content ]


subscriptions : PomodoroText -> Sub Msg
subscriptions _ =
    receiveMessage Interval


main : Program PomodoroText PomodoroText Msg
main =
    Browser.element
        { init = init
        , update = update
        , view = view >> toUnstyled
        , subscriptions = subscriptions
        }
