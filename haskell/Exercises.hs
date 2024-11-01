module Exercises
    ( change,
    firstThenApply,
    lower,
    lengthOverThree,
    powers,
    volume,
    surfaceArea,
    Shape(..),
    is_approx,
    meaningfulLineCount,
    BST(Empty),
    insert,
    contains,
    size,
    inorder,
    treeToString,
    fromList
    ) where

import qualified Data.Map as Map
import Data.Text (pack, unpack, replace)
import Data.List(isPrefixOf, find)
import Data.Char(isSpace)

change :: Integer -> Either String (Map.Map Integer Integer)
change amount
    | amount < 0 = Left "amount cannot be negative"
    | otherwise = Right $ changeHelper [25, 10, 5, 1] amount Map.empty
        where
          changeHelper [] remaining counts = counts
          changeHelper (d:ds) remaining counts =
            changeHelper ds newRemaining newCounts
              where
                (count, newRemaining) = remaining `divMod` d
                newCounts = Map.insert d count counts

firstThenApply :: [a] -> (a -> Bool) -> (a -> b) -> Maybe b
firstThenApply xs p f = f <$> find p xs

lower :: String -> String
lower = map convertToLower
  where
    convertToLower c
      | 'A' <= c && c <= 'Z' = toEnum (fromEnum c + 32)
      | otherwise = c

lengthOverThree :: String -> Bool
lengthOverThree s = length s > 3

powers :: Integral a => a -> [a]
powers base = map (base ^) [0..]

meaningfulLineCount :: FilePath -> IO Int
meaningfulLineCount path = do
    content <- readFile path
    let linesList = lines content
    return $ length $ filter isValidLine linesList

isValidLine :: String -> Bool
isValidLine line = not (null line) && not (all isSpace line) && not (isComment line)

isComment :: String -> Bool
isComment line = case dropWhile isSpace line of
                    ('#':_) -> True
                    _       -> False

data Shape = Box Double Double Double | Sphere Double deriving (Eq, Show)

volume :: Shape -> Double
volume (Box w h d) = w * h * d
volume (Sphere r) = (4 / 3) * pi * r^3

surfaceArea :: Shape -> Double
surfaceArea (Box w h d) = 2 * (w * h + h * d + d * w)
surfaceArea (Sphere r) = 4 * pi * r^2

is_approx :: Double -> Double -> Bool
is_approx a b = abs (a - b) < 1e-9

data BST a = Empty | Node a (BST a) (BST a) deriving Eq

insert :: (Ord a) => a -> BST a -> BST a
insert x Empty = Node x Empty Empty
insert x (Node y left right)
    | x < y     = Node y (insert x left) right
    | x > y     = Node y left (insert x right)
    | otherwise = Node y left right

contains :: (Ord a) => a -> BST a -> Bool
contains _ Empty = False
contains x (Node y left right)
    | x < y     = contains x left
    | x > y     = contains x right
    | otherwise = True

size :: BST a -> Int
size Empty = 0
size (Node _ left right) = 1 + size left + size right

inorder :: BST a -> [a]
inorder Empty = []
inorder (Node x left right) = inorder left ++ [x] ++ inorder right

instance (Show a) => Show (BST a) where
    show = treeToString

treeToString :: (Show a) => BST a -> String
treeToString Empty = "()"
treeToString (Node x Empty Empty) = "(" ++ show x ++ ")"
treeToString (Node x left Empty) = "(" ++ treeToString left ++ show x ++ ")"
treeToString (Node x Empty right) = "(" ++ show x ++ treeToString right ++ ")"
treeToString (Node x left right) = "(" ++ treeToString left ++ show x ++ treeToString right ++ ")"

fromList :: (Ord a) => [a] -> BST a
fromList = foldr insert Empty