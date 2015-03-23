{-# LANGUAGE OverloadedStrings #-}

module Controller.Todo (
      todoHandler
    ) where

import Prelude hiding (div, head, (!))
import Data.Time.Clock
import Control.Monad.IO.Class (liftIO)
import Text.Blaze
import Text.Blaze.Html
import Text.Blaze.Html5
import Text.Blaze.Html.Renderer.Text
import qualified Text.Blaze.Html5.Attributes as A
import qualified Web.Scotty as S
import qualified Data.Text as T

import Model.Todo

todoHandler :: S.ActionM ()
todoHandler = do
    t <- S.param "todo"
    d <- S.param "duedate"
    liftIO $ addTodo $ Todo (T.pack t) (dateToTime d)
    S.html . renderHtml $ page t d
    where
        dateToTime :: String -> UTCTime
        dateToTime x = read $ x ++ " 00:00:00 CET"

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


