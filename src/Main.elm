module Main exposing(..)

import Browser
import Browser.Navigation as Nav
import Html exposing (..)
import Html.Attributes exposing (..)
import Url
import Url.Parser exposing (Parser, (</>), int, map, oneOf, s, string)



-- MAIN


main : Program () Model Msg
main =
  Browser.application
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    , onUrlChange = UrlChanged
    , onUrlRequest = LinkClicked
    }



-- MODEL


type alias Model =
  { key : Nav.Key
  , url : Url.Url
  }


init : () -> Url.Url -> Nav.Key -> ( Model, Cmd Msg )
init flags url key =
  ( Model key url, Cmd.none )



-- UPDATE


type Msg
  = LinkClicked Browser.UrlRequest
  | UrlChanged Url.Url


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of
    LinkClicked urlRequest ->
      case urlRequest of
        Browser.Internal url ->
          ( model, Nav.pushUrl model.key (Url.toString url) )

        Browser.External href ->
          ( model, Nav.load href )

    UrlChanged url ->
      ( { model | url = url }
      , Cmd.none
      )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
  Sub.none



-- VIEW


view : Model -> Browser.Document Msg
view model =
  { title = "きゅあれもねーどの魔導書"
  , body =
      [ h1 [] [ text "きゅあれもねーどの魔導書" ]
      , ul []
          [ viewLink "/home"
          , viewLink "/profile"
          ]
      , case routeFromUrl model.url of
         Just route ->
           case route of
             Home ->
               homePage

             Profile ->
               profilePage
         Nothing ->
           notFountPage
      ]
  }


viewLink : String -> Html msg
viewLink path =
  li [] [ a [ href path ] [ text path ] ]


-- Route
type Route
  = Home
  | Profile

routeFromUrl : Url.Url -> Maybe Route
routeFromUrl url =
  case url.path of
    "/home" ->
      Just Home

    "/profile" ->
      Just Profile

    _ ->
      Nothing

showRoute : Route -> String
showRoute route =
  case route of
    Home ->
      "home"

    Profile ->
      "profile"


-- Page


homePage : Html msg
homePage =
  a [] [ text "Hello World!" ]

profilePage: Html msg
profilePage =
  a [] [ text "わたしはきゅあれもねーどです" ]

notFountPage: Html msg
notFountPage =
  a [] [ text "not found" ]
