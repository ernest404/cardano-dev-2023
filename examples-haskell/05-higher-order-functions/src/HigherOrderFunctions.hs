{-# LANGUAGE InstanceSigs #-}

module HigherOrderFunctions where

import           Prelude hiding (all, any, filter, foldr, length, (++), (.))

data Chain txs =
      GenesisBlock
    | Block (Chain txs) txs

instance Eq txs => Eq (Chain txs) where

    (==) :: Chain txs -> Chain txs -> Bool
    GenesisBlock == GenesisBlock = True
    Block xs x   == Block ys y   = xs == ys && x == y
    _            == _            = False

isPrefixOf :: Eq txs => Chain txs -> Chain txs -> Bool
isPrefixOf GenesisBlock GenesisBlock   = True
isPrefixOf (Block _ _)  GenesisBlock   = False
isPrefixOf c            d@(Block xs _) =
    c `isPrefixOf` xs || c == d

allEquals :: Eq a => [a] -> Bool
allEquals []               = True
allEquals [_]              = True
allEquals (x : xs@(y : _)) = x == y && allEquals xs

(.) :: (b -> c) -> (a -> b) -> (a -> c)
(f . g) x = f (g x)

example1 :: [Integer]
example1 =
    (take 100 . filter odd . map (\x -> x * x)) [1 ..]

foreach :: [a] -> (a -> b) -> [b]
foreach = flip map

example2 :: [Int]
example2 = foreach [1 .. 10] (2 *)
--       = map (2 *) [1 .. 10]

-- f :: a -> b
-- \a -> f a
-- those are the same! ("eta reduction")

foldr :: (a -> r -> r) -> r -> [a] -> r
foldr cons nil = go
  where
    --go :: [a] -> r
    go []       = nil
    go (y : ys) = cons y $ go ys

length :: [a] -> Int
length = foldr (const (+ 1)) 0

filter :: (a -> Bool) -> [a] -> [a]
filter p =
    foldr (\x ys -> if p x then x : ys else ys) []

(++) :: [a] -> [a] -> [a]
xs ++ ys = foldr (:) ys xs

all, any :: [Bool] -> Bool
all = foldr (&&) True
any = foldr (||) False

idList :: [a] -> [a]
idList = foldr (:) []
