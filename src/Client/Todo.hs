{-# LANGUAGE OverloadedStrings  #-}
{-# LANGUAGE EmptyDataDecls  #-}

module Todo (
      addEntry
    ) where

import FFI

data Element
data WebSocket
data Event

class Eventable a
instance Eventable WebSocket
instance Eventable Element

addEntry :: a -> Fay ()
addEntry _ = do
    task     <- getElementById "todo"
    due      <- getElementById "duedate"
    todoList <- getElementById "todoList"

    tr <- createElement "tr"
    td1 <- createElement "td"
    td2 <- createElement "td"
    v1 <- createTextNode $ elementValue task
    v2 <- createTextNode $ elementValue due
    createTextNode $ elementValue task
    appendChild td1 v1
    appendChild td2 v2
    appendChild tr td1
    appendChild tr td2
    appendChild todoList tr
    clearValue task

getElementById :: String -> Fay Element
getElementById = ffi "document.getElementById(%1)"

elementValue :: Element -> String
elementValue = ffi "%1.value"

createElement :: String -> Fay Element
createElement = ffi "document.createElement(%1)"

createTextNode :: String -> Fay Element
createTextNode  = ffi "document.createTextNode(%1)"

appendChild :: Element -> Element -> Fay ()
appendChild = ffi "%1.appendChild(%2)"

clearValue :: Element -> Fay ()
clearValue = ffi "%1.value = ''"

newWebSocket :: String -> Fay WebSocket
newWebSocket = ffi "new WebSocket(%1)"

addEventListener :: Eventable a => a -> String -> (Event -> Fay ()) -> Fay ()
addEventListener = ffi "%1[%2] = %3"
