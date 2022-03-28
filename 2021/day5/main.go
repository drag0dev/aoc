package main

import (
	"fmt"
	"io/ioutil"
	"strconv"
	"strings"
)

func printMatrix(matrix *[1000][1000]int){
    for i := 0; i< 1000 ; i++{
        for j := 0; j < 1000; j++{
            fmt.Printf("%d ", (*matrix)[i][j])
        }
        fmt.Println()
    }
    fmt.Println()
}

func main(){
    contents, _ := ioutil.ReadFile("input.txt")
    fileContentsStr := strings.Split(string(contents), "\n")
    var field [1000][1000]int

    for _, line := range fileContentsStr{
        if len(line) == 0 {
            continue
        }
        coordinates := strings.Split(line, " -> ")

        startStr := strings.Split(coordinates[0], ",")
        startX, _ := strconv.ParseInt(startStr[0], 10, 64)
        startY, _ := strconv.ParseInt(startStr[1], 10, 64)

        endStr := strings.Split(coordinates[1], ",")
        endX, _ := strconv.ParseInt(endStr[0], 10, 64)
        endY, _ := strconv.ParseInt(endStr[1], 10, 64)

        fmt.Println(startX, startY, endX, endY)

        // moving on x axis
        if startX == endX{
            if startY > endY{
                temp := startY
                startY = endY
                endY = temp
            }
            for{
                field[startY][startX]++
                startY++
                if startY > endY{
                    break
                }
            }
        // moving on y axis
        }else if startY == endY{
            if startX > endX {
                temp := startX
                startX = endX
                endX = temp
            }
            for{
                field[startY][startX]++
                startX++
                if startX > endX{
                    break
                }
            }
        // part two
        }else{
            var xAdd int64 = 1
            var yAdd int64 = 1

            if startX > endX{
                xAdd = -1
            }
            if startY > endY{
                yAdd = -1
            }

            tempXStart, tempYStart := startX, startY
            for{
                field[tempYStart][tempXStart]++
                tempXStart += xAdd
                tempYStart += yAdd
                if xAdd == -1 && tempXStart < endX{
                    break
                }else if xAdd == 1 && tempXStart > endX{
                    break
                }
            }
        }
    }

    // check how many entries in the field are above 1
    var overlaps int
    for i := 0; i<1000;i++{
        for j := 0; j < 1000; j++{
            if field[i][j] > 1 {
                overlaps++
            }
        }
    }

    fmt.Println(overlaps)
}
