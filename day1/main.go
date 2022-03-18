package main

import (
	"fmt"
	"io/ioutil"
	"strings"
    "strconv"
)

func main(){
    // part two
    content, err := ioutil.ReadFile("input.txt")
    if err != nil{
        fmt.Print("Error!")
        return
    }

    var input []string = strings.Split(string(content), "\n")

    var increases int = 0
    for i := 0; i < len(input)-3;i++{
        var sum1, sum2 int
        for j := 0; j < 3; j++{
            temp, _ := strconv.Atoi(input[i+j])
            sum1 += temp
        }
        for j := 0; j < 3; j++{
            temp, _ := strconv.Atoi(input[i+j+1])
            sum2 += temp
        }

        if sum1 < sum2{
            increases++
        }
    }

    fmt.Print(increases)
}
