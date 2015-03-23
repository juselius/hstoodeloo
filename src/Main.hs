{-# LANGUAGE OverloadedStrings #-}

module Main where

import Web.Scotty

import View.Home
import Controller.Todo
import Model.Todo

main :: IO ()
main = do
    migrateDb
    scotty 3000 $ do
        get  "/" homeView
        post "/" todoHandler

