module Main where

data RotationDirection = RLeft | RRight
data Rotation = Rotation { direction :: RotationDirection, n :: Int }

parseRotation :: String -> Rotation
parseRotation rot =
        Rotation direction n
    where
        (dir:num) = rot
        direction = case dir of
            'R' -> Main.RRight
            'L' -> Main.RLeft
        n = read num

parseRotations :: String -> [Rotation]
parseRotations input = map parseRotation (lines input)

partOne :: [Rotation] -> Int
partOne rotations = partOneAux rotations 50 0

partOneAux :: [Rotation] -> Int -> Int -> Int
partOneAux [] _ count = count
partOneAux (x:xs) curr count =
        partOneAux xs curr'' count'
    where
        delta = case direction x of
            Main.RLeft -> n x * (-1)
            Main.RRight -> n x
        curr' = curr + delta
        curr'' = curr' `mod` 100
        count' = count + case curr'' of
            0 -> 1
            _ -> 0

partTwo :: [Rotation] -> Int
partTwo rotations = partTwoAux rotations 50 0

partTwoAux :: [Rotation] -> Int -> Int -> Int
partTwoAux [] _ count = count
partTwoAux (x:xs) curr count =
        partTwoAux xs curr'' count'
    where
        delta = case direction x of
            Main.RLeft -> n x * (-1)
            Main.RRight -> n x
        curr' = curr + delta
        count' = count + abs (curr' `div` 100)
        curr'' = curr' `mod` 100


main :: IO ()
main = do
    input <- readFile "input"
    let rotations = parseRotations input
    putStrLn $ "Part one: " ++ show (partOne rotations)
    putStrLn $ "Part two: " ++ show (partTwo rotations)
