{-# LANGUAGE OverloadedStrings #-}

module View.Home (
      homeView
    ) where

import Prelude hiding (div, head, (!))
import Text.Blaze
import Text.Blaze.Html
import Text.Blaze.Html5
import Text.Blaze.Html.Renderer.Text
import qualified Text.Blaze.Html5.Attributes as A
import qualified Web.Scotty as S

homeView :: S.ActionM ()
homeView = S.html . renderHtml $ page $ do
    h1 "toodeloo"
    p "Add todo items below."
    todo

page :: Html -> Html
page bdy = docTypeHtml $ do
    head $ do
        meta  ! A.charset "utf-8"
        title "toodeloo"
    body bdy

todo :: Html
todo = form ! A.method "POST" $
    table $ do
        tr $ do
            td $ input
                ! A.type_ "text"
                ! A.placeholder "Add todo item"
                ! A.name "todo"
                ! A.id "todo"
            td $ button ! A.type_ "submit" $ "Add"

