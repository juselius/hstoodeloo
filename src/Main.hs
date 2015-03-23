{-# LANGUAGE OverloadedStrings #-}

module Main where

import Web.Scotty

import View.Home

main :: IO ()
main = scotty 3000 $ do
    get "/" homeView

