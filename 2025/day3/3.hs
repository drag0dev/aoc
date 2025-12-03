module Main where

parseLine :: String -> [Int]
parseLine = map (read . (:[]))

parseInput :: [String] -> [[Int]]
parseInput = map parseLine

greedyJoltage :: [Int] -> Int -> Int -> Int
greedyJoltage _ 0 res = res
greedyJoltage digits digitsLeft res =
        greedyJoltage digits' (digitsLeft-1) (res * 10 + digit)
    where
        (digit, maxIdx) = findNextDigit digits (length digits - (digitsLeft - 1)) 0 0 (-1)
        digits' = drop (maxIdx+1) digits

findNextDigit :: [Int] -> Int -> Int -> Int -> Int -> (Int, Int)
findNextDigit _ 0 _ maxIdx maxx = (maxx, maxIdx)
findNextDigit (p:ps) digitsLeft currIdx maxIdx maxx =
        findNextDigit ps (digitsLeft - 1) (currIdx+1) maxIdx' maxx'
    where
        maxx' = max maxx p
        maxIdx' = if maxx' == maxx then maxIdx else currIdx

solve :: [[Int]] -> Int -> Int
solve lines digits = solveAux lines digits 0
solveAux :: [[Int]] -> Int -> Int -> Int
solveAux [] digits sum = sum
solveAux (x:xs) digits sum =
        solveAux xs digits (sum + joltage)
    where
        joltage = greedyJoltage x digits 0

main :: IO ()
main = do
    input <- readFile "input"
    let parsedLines = parseInput (lines input)
    putStrLn $ "Part one: " ++ show (solve parsedLines 2)
    putStrLn $ "Part two: " ++ show (solve parsedLines 12)
