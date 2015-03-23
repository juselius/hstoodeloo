{-# LANGUAGE OverloadedStrings #-}

module Main where

import Web.Scotty
import Network.WebSockets
import Control.Concurrent
import Control.Monad (void)

import View.Home
import View.Todo
import Controller.Todo
import Controller.WS
import Model.Todo

main :: IO ()
main = do
    migrateDb
    void . forkIO $ runServer "127.0.0.1" 8080 wsHandler
    scotty 3000 $ do
        get  "/" homeView
        post "/" todoHandler
        get "/all" allTodo
        get "/due" dueTodo
        get "/todo.js" $ do
            setHeader "Content-type" "text/javascript"
            file "src/Client/todo.js"


