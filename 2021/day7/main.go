package main

import (
	"fmt"
	"io/ioutil"
	"math"
	"strconv"
	"strings"
)

func sumOfN(n int64)(int64){
    if n == 0 {
        return 0
    }
    var res int64
    var i int64
    for i =1 ; i <= n; i++{
        res += i
    }
    return  res
}

func main(){
    contents, _ := ioutil.ReadFile("input.txt")
    contents = []byte(strings.ReplaceAll(string(contents), "\n", ""))
    var positions []int64
    for _, number := range strings.Split(string(contents), ","){
        num, _ := strconv.ParseInt(number, 10, 64)
        positions = append(positions, num)
    }

    var amountOfFuel int64

    for i := 0; i < 2000; i++{
        var temp int64
        for _, innerPos := range positions{
            t := sumOfN(int64(math.Abs(float64(i) - float64(innerPos))))
            temp += t
        }
        if temp < amountOfFuel || amountOfFuel == 0{
            amountOfFuel = temp
        }
    }


    fmt.Println(amountOfFuel)
}
