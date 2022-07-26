module SkewHeap where
import Data.Maybe
import Data.List

-- This implementation of a Skew Heap (Sleator & Tarjan) comes from
-- Louis Wasserman's "Playing with Priority Queues" in
-- The Monad Reader #16
-- There may be faster Haskell priority queue implementations,
-- but this one is just so simple

data SkewHeap a = Empty | SkewNode a (SkewHeap a) (SkewHeap a) deriving (Show)

(+++) :: Ord a => SkewHeap a -> SkewHeap a -> SkewHeap a
heap1@(SkewNode x1 l1 r1) +++ heap2@(SkewNode x2 l2 r2) 
  | x1 <= x2    = SkewNode x1 (heap2 +++ r1) l1 
  | otherwise = SkewNode x2 (heap1 +++ r2) l2
Empty +++ heap = heap
heap +++ Empty = heap

extractMin Empty = Nothing
extractMin (SkewNode x l r ) = Just (x , l +++ r )

singleton :: Ord a => a -> SkewHeap a
singleton x = SkewNode x Empty Empty

toList :: Ord a => SkewHeap a -> [a]
toList h = toList' (extractMin h) []

toList' :: Ord a => Maybe (a,SkewHeap a) -> [a] -> [a]
toList' Nothing acc = reverse acc
toList' (Just (v, h2)) acc = toList' (extractMin h2) (v:acc)

fromList :: Ord a => [a] -> SkewHeap a
fromList l = foldl' (+++) Empty $ map singleton l

fooHeap = fromList [1..10]
barHeap = fromList [9,2,5,7,1,10,8,3,6,4]
