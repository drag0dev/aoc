module Main where

import Data.List.Split (splitOn)

parseRange :: String -> (Int, Int)
parseRange s =
    let [a, b] = map read $ splitOn "-" s
    in (a, b)

isInvalidPart1 :: String -> Bool
isInvalidPart1 s = left == right
    where
        mid = length s `div` 2
        (left, right) = splitAt mid s

isInvalidPart2 :: String -> Bool
isInvalidPart2 s =
    or [ let block = take k s
             repeats = length s `div` k
         in length s `mod` k == 0 && repeats >= 2 && concat (replicate repeats block) == s
       | k <- [1 .. length s `div` 2]
       ]

sumInvalidInRange :: (String -> Bool) -> (Int, Int) -> Int
sumInvalidInRange validator (start, end) =
    sum [n | n <- [start..end], validator (show n)]

solve :: (String -> Bool) -> [(Int, Int)] -> Int
solve validator ranges = sum $ map (sumInvalidInRange validator) ranges

main :: IO ()
main = do
    input <- readFile "input"
    let ranges = map parseRange $ splitOn "," input
    putStrLn $ "Part 1: " ++ show (solve isInvalidPart1 ranges)
    putStrLn $ "Part 2: " ++ show (solve isInvalidPart2 ranges)
