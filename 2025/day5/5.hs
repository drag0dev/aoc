module Main where

import Data.List.Split (splitOn)
import Data.List (sortOn)

parseRange :: String -> (Int, Int)
parseRange line =
    let [a, b] = map read (splitOn "-" line)
    in (a, b)

partOne :: [(Int, Int)] -> [Int] -> Int
partOne ranges ids = sum (map (isNumberInAnyRange ranges) ids)
isNumberInAnyRange :: [(Int, Int)] -> Int -> Int
isNumberInAnyRange [] number = 0
isNumberInAnyRange (r:rs) number =
    let (rStart, rEnd) = r in
    if number >= rStart && number <= rEnd
        then 1
        else isNumberInAnyRange rs number

partTwo :: [(Int, Int)] -> Int
partTwo ranges = partTwoAux (sortOn fst ranges) 0 (-1)
partTwoAux :: [(Int, Int)] -> Int -> Int -> Int
partTwoAux [] count _ = count
partTwoAux (r:rs) count maxx =
        partTwoAux rs count' maxx'
    where
        (rStart, rEnd) = r
        currCount = if rStart > maxx
            then rEnd - rStart + 1
            else max (rEnd - maxx) 0
        count' = count + currCount
        maxx' = max maxx rEnd

main :: IO ()
main = do
    input <- readFile "input"
    let [ranges, ids] = splitOn "\n\n" input
    let parsedRanges = map parseRange (lines ranges)
    let parsedIds = map read (lines ids)
    putStrLn $ "Part one: " ++ show (partOne parsedRanges parsedIds)
    putStrLn $ "Part two: " ++ show (partTwo parsedRanges)
