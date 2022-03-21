package main

import (
	"fmt"
	"io/ioutil"
	"strconv"
	"strings"
)


func main(){
    content, _ := ioutil.ReadFile("input.txt")
    var zero, one [12]int

    for _, line := range strings.Split(string(content), "\n"){
        for index, num := range line{
            if num == '0'{
                zero[index]++
            }else{
                one[index]++
            }
        }
    }

    var gammaStr string
    for i := 0; i<12;i++{
        if zero[i] > one[i]{
            gammaStr += "1"
        }else{
            gammaStr += "0"
        }
    }

    var epsilonStr string
    for i := 0; i<12;i++{
        if zero[i] > one[i]{
            epsilonStr += "0"
        }else{
            epsilonStr += "1"
        }
    }

    gamma, _ := strconv.ParseInt(gammaStr, 2, 64)
    epsilon, _ := strconv.ParseInt(epsilonStr, 2, 64)
    fmt.Println(gamma * epsilon)
}
