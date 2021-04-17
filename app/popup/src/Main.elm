port module Main exposing (main)

import Browser
import Css exposing (backgroundColor, color, hex, minWidth, px)
import Html.Styled exposing (Html, div, text, toUnstyled)
import Html.Styled.Attributes exposing (css)
import Json.Decode exposing (Decoder, Value, decodeValue, field, int, map4, string)
import Svg.Styled exposing (Svg, g, svg, toUnstyled)
import Svg.Styled.Attributes exposing (cx, cy, fill, r, stroke, transform, viewBox)


port receiveMessage : (Value -> msg) -> Sub msg


type alias PomodoroText =
    { operator : String
    , time : Int
    , remaining : Int
    , content : String
    }


init : PomodoroText -> ( PomodoroText, Cmd Msg )
init flags =
    ( PomodoroText flags.operator flags.time flags.remaining flags.content
    , Cmd.none
    )


type Msg
    = Interval Value


decoder : Decoder PomodoroText
decoder =
    map4 PomodoroText
        (field "operator" string)
        (field "time" int)
        (field "remaining" int)
        (field "content" string)


update : Msg -> PomodoroText -> ( PomodoroText, Cmd Msg )
update msg _ =
    case msg of
        Interval value ->
            case decodeValue decoder value of
                Ok model ->
                    ( model, Cmd.none )

                Err _ ->
                    ( PomodoroText "" 0 0 "", Cmd.none )


view : PomodoroText -> Html Msg
view model =
    let
        time =
            if model.remaining == 0 then
                ""

            else
                (model.remaining // 60 |> String.fromInt) ++ ":" ++ String.padLeft 2 '0' (modBy 60 model.remaining |> String.fromInt)

        percent =
            toFloat model.remaining / toFloat model.time

        progressWidth =
            200
    in
    div
        [ css
            [ Css.paddingTop (px 10)
            , Css.paddingBottom (px 10)
            , Css.paddingLeft (px 20)
            , Css.paddingRight (px 20)
            , Css.width (px progressWidth)
            , backgroundColor (hex "#3b3b3b")
            , color (hex "#fff")
            , Css.fontSize (Css.em 1.3)
            ]
        ]
        [ text model.content
        , div
            [ css
                [ Css.position Css.absolute
                , Css.width (px progressWidth)
                , Css.height (px progressWidth)
                , Css.lineHeight (px progressWidth)
                , Css.textAlign Css.center
                , color (hex "#fff")
                , Css.fontSize (Css.em 2.3)
                ]
            ]
            [ text time
            ]
        , svg [ viewBox ("0 0 " ++ String.fromInt progressWidth ++ " " ++ String.fromInt progressWidth) ]
            [ viewProgress progressWidth percent
            ]
        ]


viewProgress : Int -> Float -> Svg msg
viewProgress width percent =
    let
        center =
            toFloat width / 2

        radius =
            toFloat width / toFloat 2 - 10

        strokeWidth =
            6

        dash =
            2 * pi * radius

        makeSlice =
            [ Svg.Styled.circle
                [ cx <| String.fromFloat center
                , cy <| String.fromFloat center
                , r <| String.fromFloat radius
                , fill "transparent"
                , Svg.Styled.Attributes.strokeWidth <| String.fromInt strokeWidth
                , stroke "#000"
                ]
                []
            , Svg.Styled.circle
                [ cx <| String.fromFloat center
                , cy <| String.fromFloat center
                , r <| String.fromFloat radius
                , fill "transparent"
                , Svg.Styled.Attributes.strokeWidth <| String.fromInt strokeWidth
                , stroke "#0f0"
                , Svg.Styled.Attributes.strokeDasharray <| String.fromFloat dash
                , Svg.Styled.Attributes.strokeDashoffset <| String.fromFloat (dash * (1 - percent))
                , Svg.Styled.Attributes.strokeLinecap "round"
                ]
                []
            ]
    in
    g [ transform ("rotate(-90 " ++ String.fromFloat center ++ " " ++ String.fromFloat center ++ ")") ] <| makeSlice


subscriptions : PomodoroText -> Sub Msg
subscriptions _ =
    receiveMessage Interval


main : Program PomodoroText PomodoroText Msg
main =
    Browser.element
        { init = init
        , update = update
        , view = view >> Html.Styled.toUnstyled
        , subscriptions = subscriptions
        }
