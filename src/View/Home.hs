{-# LANGUAGE OverloadedStrings #-}

module View.Home (
      homeView
    ) where

import Prelude hiding (div, head, (!))
import Data.Time
import Data.Monoid
import Control.Monad.IO.Class (liftIO)
import Text.Blaze
import Text.Blaze.Html
import Text.Blaze.Html5
import Text.Blaze.Html.Renderer.Text
import qualified Text.Blaze.Html5.Attributes as A
import qualified Web.Scotty as S


homeView :: S.ActionM ()
homeView = do
    now' <- liftIO $ getCurrentTime
    let now = stringValue . show $ utctDay now'
    S.html . renderHtml $ page $ do
        h1 "toodeloo"
        p "Add todo items below."
        todo now
        hr
        todoList

page :: Html -> Html
page bdy = docTypeHtml $ do
    head $ do
        meta  ! A.charset "utf-8"
        title "toodeloo"
    body bdy
    script ! A.src "/todo.js" $ mempty

todo :: AttributeValue-> Html
todo now = form $
    table $ do
        tr $ do
            td $ input
                ! A.type_ "text"
                ! A.placeholder "Add todo item"
                ! A.name "todo"
                ! A.id "todo"
            td $ input
                ! A.type_ "date"
                ! A.value now
                ! A.name "duedate"
                ! A.id "duedate"
        tr . td $ button
            ! A.type_ "button"
            ! A.onclick "Strict.Todo.addEntry(true)" $ "Add"

todoList ::  Html
todoList = table ! A.id "todoList" $ do
    tr $ do
        td $ mempty
        td $ mempty

todo' :: AttributeValue-> Html
todo' now = form ! A.method "POST" $
    table $ do
        tr $ do
            td $ input
                ! A.type_ "text"
                ! A.placeholder "Add todo item"
                ! A.name "todo"
                ! A.id "todo"
            td $ input
                ! A.type_ "date"
                ! A.value now
                ! A.name "duedate"
                ! A.id "duedate"
        tr . td $ button ! A.type_ "submit" $ "Add"
