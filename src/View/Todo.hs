{-# LANGUAGE OverloadedStrings #-}

module View.Todo (
      allTodo
    , dueTodo
    ) where

import Prelude hiding (div, head, (!))
import Control.Monad.IO.Class (liftIO)
import Data.Time.Clock
import Data.Monoid
import Text.Blaze
import Text.Blaze.Html
import Text.Blaze.Html5
import Text.Blaze.Html.Renderer.Text
import qualified Text.Blaze.Html5.Attributes as A
import qualified Web.Scotty as S

import Model.Todo

allTodo :: S.ActionM ()
allTodo = do
    todo <- liftIO $ getAllTodo
    S.html . renderHtml $ page $ do
        h1 "All todo"
        todoTable todo



dueTodo :: S.ActionM ()
dueTodo = do
    todo <- liftIO $ getTodo
    S.html . renderHtml $ page $ do
        h1 "Due todo"
        todoTable todo

page :: Html -> Html
page bdy = docTypeHtml $ do
    head $ do
        meta  ! A.charset "utf-8"
        title "toodeloo"
    body bdy

todoTable :: [Todo] -> Html
todoTable todo = table $
    foldl (\acc (Todo t d) -> acc `mappend` row t d) mempty todo
    where
        row t d = tr $ do
            td (toHtml t)
            td (toHtml . show $ utctDay d)
