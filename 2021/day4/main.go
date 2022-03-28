package main

import (
	"fmt"
	"io/ioutil"
	"strconv"
	"strings"
)

func checkIfBingoWinning(bingo *string)string{
    bingoSplit := strings.Split(*bingo, "\n\n")
    // by rows
    // split into bingos
    for index, bingo := range bingoSplit{
        // split each bingo into lines
        lineSplit := strings.Split(bingo, "\n")
        for _, line := range lineSplit{
            if strings.Count(line, "F") == 5{
                fmt.Printf("(%d) ", index)
                return bingoSplit[index]
            }
        }
    }

    //by columns
    var foundNumsColumn [5]int
    for outterIndex, bingo := range bingoSplit{
        for _, line := range strings.Split(bingo, "\n"){
            if len(line) == 0 {
                continue
            }
            line = strings.ReplaceAll(line, "  ", " ")
            if line[0] == ' '{
                line = strings.Replace(line, " ", "", 1)
            }
            lineSplit := strings.Split(line, " ")
            for index, num := range lineSplit{
                if strings.Index(num, "F") != -1 {
                    foundNumsColumn[index]++
                }
            }

            for index, found := range foundNumsColumn{
                if found == 6 {
                    fmt.Printf("(%d) ", outterIndex)
                    return bingoSplit[outterIndex]
                }else{
                    foundNumsColumn[index] = 0
                }
            }
        }
    }

    return ""
}

func calculateWinningBingo(bingo string, drawnNumber int)(int){
    var sum int

    for _, line := range strings.Split(bingo, "\n"){
        if len(line) == 0 {
            continue
        }
        line = strings.ReplaceAll(line, "  ", " ")
        if line[0] == ' '{
            line = strings.Replace(line, " ", "", 1)
        }

        for _, num := range strings.Split(line, " "){
            if strings.Index(num, "F") == -1{
                parseNum, _ := strconv.ParseInt(num, 10, 64)
                sum += int(parseNum)
            }
        }
    }

    return sum * drawnNumber
}

func markBingos(bingos *string, number string){
    if len(number) == 1{
        *bingos = strings.ReplaceAll(*bingos, fmt.Sprintf(" %s ", number), fmt.Sprintf("F%s ", number))
        *bingos = strings.ReplaceAll(*bingos, fmt.Sprintf(" %s\n", number), fmt.Sprintf("F%s\n", number))
        *bingos = strings.ReplaceAll(*bingos, fmt.Sprintf(" %s ", number), fmt.Sprintf("F%s ", number))
    }else {
        *bingos = strings.ReplaceAll(*bingos, fmt.Sprintf("%s ", number), fmt.Sprintf("F%s ", number))
        *bingos = strings.ReplaceAll(*bingos, fmt.Sprintf(" %s\n", number), fmt.Sprintf(" F%s\n", number))
    }
}

func main(){
    contents, _ := ioutil.ReadFile("input.txt")
    bingos := strings.Split(string(contents), "\n")

    var drawnNumbers []string = strings.Split(bingos[0], ",")
    var bingoNo int
    bingos = bingos[1:]
    joinedBingos := strings.Join(bingos, "\n")

    for _, drawnNumber := range drawnNumbers{
        markBingos(&joinedBingos, drawnNumber)
        drawnNumberInt, _ := strconv.ParseInt(drawnNumber, 10, 64)
        var found bool
        for{
            winningBingo := checkIfBingoWinning(&joinedBingos)
            if winningBingo == ""{
                fmt.Println("no winning")
                if found{
                    return
                }
                break
            }else if winningBingo != ""{
                fmt.Printf("(%s) %d. bingo winning: %d\n",drawnNumber,bingoNo+1, calculateWinningBingo(winningBingo, int(drawnNumberInt)))
                fmt.Println(winningBingo)
                joinedBingos = strings.ReplaceAll(joinedBingos, winningBingo, "")
                joinedBingos = strings.ReplaceAll(joinedBingos, "\n\n\n", "\n\n")
                bingoNo++
                found = true
            }
        }
    }
}
