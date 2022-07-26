import SkewHeap

data Thing = Thing String Int
    deriving Show

instance Eq Thing where
  (==) (Thing _ i) (Thing _ j) = i == j

instance Ord Thing where
  compare (Thing _ i) (Thing _ j) = compare j i

things = [ Thing "Curly" 30, Thing "Moe" 100, Thing "Joe" 5,
           Thing "Curly Joe" 15, Thing "Shemp" 50, Thing "Larry" 85 ]


