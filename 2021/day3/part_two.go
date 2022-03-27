package main

import (
	"fmt"
	"io/ioutil"
	"strconv"
	"strings"
)

func oneMostCommon(arr []string, index int)(int, int){
    var zero, one int
    for _, line := range arr{
        if line[index] == '0'{
            zero++
        }else{
            one++
        }
    }

    return zero, one
}

func newArray(arr []string, index int, number string)(*[]string){
    var newArr []string
    for _, line := range arr{
        if string(line[index]) == number{
            newArr = append(newArr, line)
        }
    }
    return &newArr
}

func main(){
    contents, _ := ioutil.ReadFile("input.txt")

    var inputLines []string = strings.Split(string(contents), "\n")
    if len(inputLines[len(inputLines)-1])==0{
            inputLines = inputLines[:len(inputLines)-1]
    }

    var oxygenArr *[]string = &inputLines
    var scrubberArr *[]string = &inputLines
    var oxygen, scrubber string

    for index :=0; index < 12; index++{
        // oxygen
        if oxygen == ""{
            zero, one := oneMostCommon(*oxygenArr, index)
            if one > zero || one == zero {
                oxygenArr = newArray(*oxygenArr, index, "1")
            }else{
                oxygenArr = newArray(*oxygenArr, index, "0")
            }
            if len(*oxygenArr) == 1 {
                oxygen = (*oxygenArr)[0]
            }
        }

        // scrubber
        if scrubber == ""{
            zero, one := oneMostCommon(*scrubberArr, index)
            if one > zero || zero == one{
                scrubberArr = newArray(*scrubberArr, index, "0")
            }else{
                scrubberArr = newArray(*scrubberArr, index, "1")
            }
            if len(*scrubberArr) == 1 {
                scrubber = (*scrubberArr)[0]
            }
        }


        if scrubber != "" && oxygen != ""{
            break
        }
    }

    scrubberNum, _ := strconv.ParseInt(scrubber, 2, 64)
    oxygenNum, _ := strconv.ParseInt(oxygen, 2, 64)

    fmt.Println(scrubberNum * oxygenNum)
}
