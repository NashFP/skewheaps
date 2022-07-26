# Haskell Skew Heap

A Skew Heap node is defined as:
```haskell
data SkewHeap a = Empty | SkewNode a (SkewHeap a) (SkewHeap a) deriving (Show)
```

The merge function is defined as an inline function named `+++`.
Note the requirement that the data type stored in the heap must
implement the Ord interface:
```haskell
(+++) :: Ord a => SkewHeap a -> SkewHeap a -> SkewHeap a
heap1@(SkewNode x1 l1 r1) +++ heap2@(SkewNode x2 l2 r2)
  | x1 <= x2    = SkewNode x1 (heap2 +++ r1) l1
  | otherwise = SkewNode x2 (heap1 +++ r2) l2
Empty +++ heap = heap
heap +++ Empty = heap
```

To extract the minimum value, you receive both the minimum value
and the updated heap with the item removed.
```haskell
extractMin Empty = Nothing
extractMin (SkewNode x l r ) = Just (x , l +++ r )
```

The `singleton` function creates a Skew Heap containing only
one value.
```haskell
singleton :: Ord a => a -> SkewHeap a
singleton x = SkewNode x Empty Empty
```

In addition to these functions, there are some utility functions to
convert to and from lists:
```haskell
toList :: Ord a => SkewHeap a -> [a]
toList h = toList' (extractMin h) []

toList' :: Ord a => Maybe (a,SkewHeap a) -> [a] -> [a]
toList' Nothing acc = reverse acc
toList' (Just (v, h2)) acc = toList' (extractMin h2) (v:acc)

fromList :: Ord a => [a] -> SkewHeap a
fromList l = foldl' (+++) Empty $ map singleton l
```

Finally, there are two examples of creating a Skew Heap from a list
of numbers:
```haskell
fooHeap = fromList [1..10]
barHeap = fromList [9,2,5,7,1,10,8,3,6,4]
```

Here is an example session that displays one of the default heaps
and then converts it into a list, which will be sorted:
```shell
$ ghci SkewHeap.hs
GHCi, version 8.10.7: https://www.haskell.org/ghc/  :? for help
[1 of 1] Compiling SkewHeap         ( SkewHeap.hs, interpreted )
Ok, one module loaded.
*SkewHeap> fooHeap
SkewNode 1 (SkewNode 2 (SkewNode 6 (SkewNode 10 Empty Empty) Empty) (SkewNode 4 (SkewNode 8 Empty Empty) Empty)) (SkewNode 3 (SkewNode 5 (SkewNode 9 Empty Empty) Empty) (SkewNode 7 Empty Empty))
*SkewHeap> toList fooHeap
[1,2,3,4,5,6,7,8,9,10]
*SkewHeap> 
```

To demonstrate Haskell type classes, here is another data item that
can be stored in a Skew Heap (this is in `heaptest.hs`):
```haskell
data Thing = Thing String Int
    deriving Show
```

In order to store something of type `Thing` in a Skew Heap, you need
to implement the `Ord` type class for it, as well as `Eq`. Note that
the compare function reverses the arguments, meaning that the Skew
Heap will actually return the maximum value in the heap instead of
the minimum:
```haskell
instance Eq Thing where
  (==) (Thing _ i) (Thing _ j) = i == j

instance Ord Thing where
  compare (Thing _ i) (Thing _ j) = compare j i
```

Here is a list of some example data:
```haskell
things = [ Thing "Curly" 30, Thing "Moe" 100, Thing "Joe" 5,
           Thing "Curly Joe" 15, Thing "Shemp" 50, Thing "Larry" 85 ]

```

Here is an example session that converts this list of things into
a skew heap, and then converts that back into a list:

```shell
$ ghci heaptest.hs
GHCi, version 8.10.7: https://www.haskell.org/ghc/  :? for help
[1 of 2] Compiling SkewHeap         ( SkewHeap.hs, interpreted )
[2 of 2] Compiling Main             ( heaptest.hs, interpreted )
Ok, two modules loaded.
*Main> let sh = fromList things
*Main> sh
SkewNode (Thing "Moe" 100) (SkewNode (Thing "Larry" 85) (SkewNode (Thing "Curly" 30) (SkewNode (Thing "Curly Joe" 15) Empty Empty) Empty) Empty) (SkewNode (Thing "Shemp" 50) (SkewNode (Thing "Joe" 5) Empty Empty) Empty)
*Main> toList sh
[Thing "Moe" 100,Thing "Larry" 85,Thing "Shemp" 50,Thing "Curly" 30,Thing "Curly Joe" 15,Thing "Joe" 5]
*Main> 
```
