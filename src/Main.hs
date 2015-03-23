{-# LANGUAGE OverloadedStrings #-}

module Main where

import Web.Scotty

import View.Home
import Controller.Todo

main :: IO ()
main = scotty 3000 $ do
    get  "/" homeView
    post "/" todoHandler

