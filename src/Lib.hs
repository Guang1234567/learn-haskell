{-# LANGUAGE FlexibleInstances #-}

module Lib where

import Codec.Compression.GZip (compress)
import Control.Concurrent (MVar, forkIO, newEmptyMVar, newMVar, putMVar, takeMVar)
import Control.Exception (SomeException, handle)
import qualified Data.ByteString.Lazy as L
import qualified Data.ByteString.Lazy.Char8 as BLC
import System.Console.Haskeline (defaultSettings, getInputLine, runInputT)
import System.Directory
import Text.Regex.Posix

import Foreign.C (CString, newCString)

someFunc :: IO ()
someFunc = do
    dirs <- getDirectoryContents "/" >>= return . filter (`notElem` [".", ".."])
    putStrLn (dirs !! 0)

readline :: String -> IO (Maybe String)
readline = runInputT defaultSettings . getInputLine

compressDemo :: IO ()
compressDemo = do
    maybeLine <- readline "Enter a file to compress> "
    case maybeLine of
        Nothing -> return () -- 用户输入了 EOF
        Just "" -> return () -- 不输入名字按 “想要退出” 处理
        Just name -> do
            handle (print :: (SomeException -> IO ())) $ do
                content <- L.readFile name
                forkIO (compressFile name content)
                return ()
            compressDemo
  where
    compressFile path = L.writeFile (path ++ ".gz") . compress

threadCommunicationByMVarDemo :: IO ()
threadCommunicationByMVarDemo
    -- m <- newMVar "consumed by worker thread"
 = do
    m <- newEmptyMVar
    workerTid <-
        forkIO $ do
            putStrLn ("before product money")
            putMVar m "$700"
            putStrLn ("after product money")
    putStrLn "sending"
    money <- takeMVar m
    putStrLn ("Get " ++ money ++ " from workerThread( " ++ show workerTid ++ " )")

readPrice :: BLC.ByteString -> Maybe Int
readPrice str =
    case BLC.readInt str of
        Nothing -> Nothing
        Just (dollars, rest) ->
            case BLC.readInt (BLC.tail rest) of
                Nothing -> Nothing
                Just (cents, more) -> Just (dollars * 100 + cents)

-- | export haskell function @chello@ as @hello@.
foreign export ccall "hello" chello :: IO CString

-- | Tiny wrapper to return a CString
-- chello = newCString $ show $ readPrice $ BLC.pack "199.25"
chello = newCString $ show ("foobar" =~ "bar" :: Bool)

-- | Pristine haskell function.
hello = "Hello from Haskell, ghc-v8.6.5 minSupportAPI=16 static cabal project"