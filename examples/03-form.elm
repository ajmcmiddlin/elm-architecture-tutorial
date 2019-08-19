module Main exposing (Model, Msg(..), init, main, update, view, viewInput, viewValidation)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)



-- MAIN


main =
    Browser.sandbox { init = init, update = update, view = view }



-- MODEL


type SubmitState
    = NotSubmitted
    | Submitted


type alias Model =
    { name : String
    , password : String
    , passwordAgain : String
    , age : String
    , submitted : SubmitState
    }


init : Model
init =
    Model "" "" "" "" NotSubmitted



-- UPDATE


type Msg
    = Name String
    | Password String
    | PasswordAgain String
    | Age String
    | Submit


update : Msg -> Model -> Model
update msg model =
    case msg of
        Name name ->
            { model | name = name }

        Password password ->
            { model | password = password }

        PasswordAgain password ->
            { model | passwordAgain = password }

        Age age ->
            { model | age = age }

        Submit ->
            { model | submitted = Submitted }



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ viewInput "text" "Name" model.name Name
        , viewInput "password" "Password" model.password Password
        , viewInput "password" "Re-enter Password" model.passwordAgain PasswordAgain
        , viewInput "text" "Age" model.age Age
        , viewSubmit
        , viewValidation model
        ]


viewSubmit : Html Msg
viewSubmit =
    let
        submitBtn =
            button [ type_ "button", onClick Submit ] [ text "Submit" ]
    in
    div [] [ submitBtn ]


viewInput : String -> String -> String -> (String -> msg) -> Html msg
viewInput t p v toMsg =
    input [ type_ t, placeholder p, value v, onInput toMsg ] []


viewValidation : Model -> Html msg
viewValidation model =
    let
        ok =
            div [ style "color" "green" ] [ text "OK" ]

        diversityTests =
            [ Char.isLower, Char.isUpper, Char.isDigit ]

        hasCharDiversity =
            List.all (\p -> String.any p model.password) diversityTests

        ageVal =
            maybe ( True, "Age is not a valid number" ) (\a -> ( a < 0, "Age is not a natural number." ))

        bads =
            List.filter Tuple.first
                [ ( model.password /= model.passwordAgain, "Passwords do not match!" )
                , ( String.length model.password < 8, "Password has fewer than 8 characters" )
                , ( not hasCharDiversity, "Password does not contain lower, upper, and digit characters" )
                , ageVal <| String.toInt model.age
                ]

        viewBads bs =
            ul [ style "color" "red" ] (List.map (\b -> li [] [ text (Tuple.second b) ]) bs)

        validate =
            if List.isEmpty bads then
                ok

            else
                viewBads bads
    in
    case model.submitted of
        NotSubmitted ->
            div [] []

        Submitted ->
            validate


maybe : b -> (a -> b) -> Maybe a -> b
maybe b f ma =
    case ma of
        Just a ->
            f a

        Nothing ->
            b
