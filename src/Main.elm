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
      [ header
      , navbar
      , section [ class "section" ] [
          div [ class "container" ] [
              case routeFromUrl model.url of
                Just route ->
                  case route of
                    Home ->
                      homePage

                    Profile ->
                      profilePage
                Nothing ->
                  notFountPage
          ]
        ]
    --   , footer1
      ]

  }


viewLink : String -> Html msg
viewLink path =  a [ class "navbar-item", href path ] [ text path ]


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

header: Html msg
header =
  section [ class "hero is-dark" ] [
      div [ class "hero-body" ] [
        h1 [ class "title" ] [
            text "きゅあれもねーどの魔導書"
        ]
      ]
  ]

navbar: Html msg
navbar =
  nav [
    class "navbar is-light"
    , attribute "role" "navigation"
    , attribute "aria-label" "main navigation"
  ]
  [
    div [ class "navbar-brand" ]
    [ viewLink "home"
    , viewLink "profile"
    ]
  ]

footer1 : Html msg
footer1 = footer [class "fotter"]
  [ div [ class "content has-text-centered"] [
      p [] [ text "fotter" ]
  ]

  ]


homePage : Html msg
homePage =
  div []
    [ nav [class "panel"]
      [ p [class "panel-heading"] [text "Home"]
      , p [class "panel-block"] [ text "Hello World!" ]]
    , nav [class "panel"]
      [ p [class "panel-heading"] [ text "use technology"]
      , a [class "panel-block"] [
        span [class "panel-icon"] [
            i [class "fas fa-book", attribute "aria-hidden" "true"] []
            , text "elm"
          ]
        ]
       , a [class "panel-block"] [
        span [class "panel-icon"] [
            i [class "fas fa-book", attribute "aria-hidden" "true"] []
            , text "bulma"
          ]
        ]
      , a [class "panel-block"] [
        span [class "panel-icon"] [
            i [class "fas fa-book", attribute "aria-hidden" "true"] []
            , text "parcel"
          ]
        ]
      , a [class "panel-block"] [
        span [class "panel-icon"] [
            i [class "fas fa-book", attribute "aria-hidden" "true"] []
            , text "yarn"
          ]
        ]
      ]
    ]


profilePage: Html msg
profilePage =
  div []
    [ nav [class "panel"]
      [ p [class "panel-heading"] [ text "Profile"]
      , p [class "panel-block"] [ text "きゅあれもねーど" ]
      , p [class "panel-block"] [ text "世のダークコーディングを倒すよ！" ]
      ]
    , nav [class "panel"]
      [ p [class "panel-heading"] [ text "SNS"]
      , a [class "panel-block", href "https://twitter.com/curelemonade2", target "_blank" ] [text "Twitter"]
      , a [class "panel-block", href "https://github.com/YuMuuu", target "_blank" ] [text "Github"]
      , a [class "panel-block", href "https://curelemonade2.hatenablog.com/", target "_blank" ] [text "はてなブログ"]
      , a [class "panel-block", href "https://scrapbox.io/curelemonade15-07937665/", target "_blank" ] [text "ScrapBox"]
      ]
    , nav [class "panel"]
      [ p [class "panel-heading"] [ text "欲しい物リスト"]
      , a [class "panel-block" , href "https://www.amazon.jp/hz/wishlist/ls/28TVSSAVIAWDM?ref_=wl_share", target "_blank" ] [text "技術書"]
      , a [class "panel-block" , href "https://www.amazon.jp/hz/wishlist/ls/21D4MW86YISQO?ref_=wl_share", target "_blank" ] [text "技術書以外"]
      ]
  ]

notFountPage: Html msg
notFountPage = p [] [ text "not found" ]
