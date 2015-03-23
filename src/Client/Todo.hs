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

data Todo = Todo {
      task :: String
    , due :: String
    } deriving (Show)

addEntry :: a -> Fay ()
addEntry _ = do
    task     <- getElementById "todo"
    due      <- getElementById "duedate"
    let due' = (elementValue due) ++ " 23:59:59 CET"
    let todo = Todo (elementValue task) due'
    storeEntry todo
    viewEntry todo

storeEntry :: Todo -> Fay ()
storeEntry todo = do
    infoBox <- getElementById "infoBox"
    conn <- newWebSocket "ws://localhost:8080"
    addEventListener conn "onopen" $ \_ ->
        conn `send` show todo
    addEventListener conn "onmessage" $ \e ->
        setInnerHTML infoBox (messageData e)

viewEntry :: Todo -> Fay ()
viewEntry (Todo task due)  = do
    taskBox  <- getElementById "todo"
    todoList <- getElementById "todoList"
    tr <- createElement "tr"
    td1 <- createElement "td"
    td2 <- createElement "td"
    v1 <- createTextNode $ task
    v2 <- createTextNode $ due
    appendChild td1 v1
    appendChild td2 v2
    appendChild tr td1
    appendChild tr td2
    appendChild todoList tr
    clearValue taskBox

setInnerHTML :: Element -> String -> Fay ()
setInnerHTML = ffi "%1['innerHTML'] = %2"

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

messageData :: Event -> String
messageData = ffi "%1.data"

send :: WebSocket -> String -> Fay ()
send = ffi "%1.send(%2)"
