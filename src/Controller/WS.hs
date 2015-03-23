{-# LANGUAGE OverloadedStrings #-}

module Controller.WS (
    wsHandler
    ) where

import Network.WebSockets
import Data.Aeson
import qualified Data.Text as T

import Model.Todo

wsHandler :: ServerApp
wsHandler client = do
    conn <- acceptRequest client
    Text msg <- receiveDataMessage conn
    case decode msg :: Maybe Todo of
        Just x -> do
            addTodo x
            sendTextData conn ("ok" :: T.Text)
        Nothing -> do
            print msg
            sendTextData conn ("error" :: T.Text)


