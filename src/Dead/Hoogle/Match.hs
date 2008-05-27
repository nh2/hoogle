{- |
    The main driver module, all the associated interfaces call into this
-}

module Hoogle.Match(matchUnordered, matchOrdered, matchRange) where

import Hoogle.Result
import Hoogle.Database
import Hoogle.Search

import Hoogle.MatchName
import Hoogle.MatchType

import Data.List


---------------------------------------------------------------------
-- DRIVER



-- | The main drivers for hoogle
matchUnordered
    :: FilePath -- ^ The full path to the hoogle file, if null then a default is used
    -> SearchMode -- ^ The string to search for, unparsed
    -> IO [Result] -- ^ A list of Results, from best to worst
matchUnordered path find =
    do 
        let file = if null path then "hoogle.txt" else path
        database <- loadDatabase file
        return $ case find of
            SearchName x -> lookupName (names database) x
            SearchType x -> lookupType (classes database) (types database) x


-- | 
matchOrdered :: FilePath -> SearchMode -> IO [Result]
matchOrdered path find =
    do res <- matchUnordered path find
       return $ sort res



matchRange :: FilePath -> SearchMode -> Int -> Int -> IO [Result]
matchRange path find 0 count =
    do res <- matchOrdered path find
       return $ take count res


matchRange path find from count = 
    do res <- matchRange path find 0 (from+count)
       return $ drop from res