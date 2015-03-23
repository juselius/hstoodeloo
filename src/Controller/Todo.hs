{-# LANGUAGE OverloadedStrings #-}

module Controller.Todo (
      todoHandler
    ) where

import Prelude hiding (div, head, (!))
import Text.Blaze
import Text.Blaze.Html
import Text.Blaze.Html5
import Text.Blaze.Html.Renderer.Text
import qualified Text.Blaze.Html5.Attributes as A
import qualified Web.Scotty as S

todoHandler :: S.ActionM ()
todoHandler = do
    t <- S.param "todo"
    d <- S.param "duedate"
    S.html . renderHtml $ page t d

page :: String -> String -> Html
page t d = docTypeHtml $ do
    head $ do
        meta  ! A.charset "utf-8"
        title "toodeloo"
    h1 "New toodeloo"
    p $ do
      b $ "Task: "
      toHtml t
      b $ " Due: "
      toHtml d


