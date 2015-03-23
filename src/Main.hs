{-# LANGUAGE OverloadedStrings #-}

module Main where

import Web.Scotty

import View.Home
import View.Todo
import Controller.Todo
import Model.Todo

main :: IO ()
main = do
    migrateDb
    scotty 3000 $ do
        get  "/" homeView
        post "/" todoHandler
        get "/all" allTodo
        get "/due" dueTodo
        get "/todo.js" $ do
            setHeader "Content-type" "text/javascript"
            file "src/Client/todo.js"


