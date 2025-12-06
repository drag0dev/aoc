module Main where

import qualified Data.Text as T

parseOps :: String -> [Char]
parseOps ops = T.unpack (T.replace (T.pack " ") (T.pack "") (T.pack ops))

parseNumRow :: String -> [Int]
parseNumRow row = map read (words row)

applyOp :: [Int] -> Char -> Int -> Int
applyOp [] _ acc = acc
applyOp (n:ns) op acc =
    applyOp ns op acc'
    where
    acc' = if op == '+' then acc + n else acc * n

partOne :: [Char] -> [[Int]] -> Int
partOne ops nums = partOneAux ops nums 0
partOneAux :: [Char] -> [[Int]] -> Int -> Int
partOneAux [] nums acc = acc
partOneAux (o:os) nums acc =
    partOneAux os ttails (acc+res)
    where
        hheads = map head nums
        ttails = map tail nums
        accInit = if o == '+' then 0 else 1
        res = applyOp hheads o accInit

anyLeft :: [String] -> Bool
anyLeft [] = False
anyLeft (x:xs) =
    case x of
        [] -> anyLeft xs
        (s:_) -> s /= ' ' || anyLeft xs

createNum :: [String] -> Int
createNum rows = read (filter (/= ' ') $ map head rows)

constructNumbers :: [String] -> ([Int], [String])
constructNumbers rows = constructNumbersAux rows []
constructNumbersAux :: [String] -> [Int] -> ([Int], [String])
constructNumbersAux rows acc =
    if anyLeft rows
    then
        let num = createNum rows in
        let ttails = map tail rows in
        constructNumbersAux ttails (num:acc)
    else (acc, map tail rows)

partTwo :: [Char] -> [String] -> Int
partTwo ops nums = partTwoAux ops nums 0
partTwoAux :: [Char] -> [String] -> Int -> Int
partTwoAux [] _ acc = acc
partTwoAux (o:op) rows acc =
    partTwoAux op rows' acc'
    where
    (nums, rows') = constructNumbers rows
    accInit = if o == '+' then 0 else 1
    acc' = acc + applyOp nums o accInit


main :: IO ()
main = do
    input <- readFile "input"
    let lines' = lines input
    let (nums, ops) = (init lines', last lines')
    let nums' = map parseNumRow nums
    let ops' = parseOps ops
    putStrLn $ "Part one: " ++ show (partOne ops' nums')
    putStrLn $ "Part two: " ++ show (partTwo ops' nums)
