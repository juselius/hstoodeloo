{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE GeneralizedNewtypeDeriving #-}
{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE GADTs #-}

module Model.Todo where
import Data.Time
import Database.Persist
import Database.Persist.Sqlite
import Database.Persist.TH
import Data.Aeson
import Control.Monad
import Control.Applicative
import qualified Data.Text as T

share [mkPersist sqlSettings, mkMigrate "migrateAll"] [persistLowerCase|
Todo
  task T.Text
  due  UTCTime
  deriving Show
|]

instance FromJSON Todo where
    parseJSON (Object v) = Todo <$>
        v .: "task" <*>
        v .: "due"
    parseJSON _ = mzero

dbName :: FilePath
dbName = "todo.db"

db :: T.Text
db = T.pack dbName

migrateDb :: IO ()
migrateDb = runSqlite (T.pack dbName) $ runMigration migrateAll

addTodo :: Todo -> IO ()
addTodo t = runSqlite db . void $ insert t

getAllTodo :: IO [Todo]
getAllTodo = runSqlite db $ do
    t <- selectList [] []
    return $ map (\(Entity _ x) -> x) t

getTodo :: IO [Todo]
getTodo = do
    now <- getCurrentTime
    runSqlite db $ do
        t <- selectList [TodoDue >. now] []
        return $ map (\(Entity _ x) -> x) t
