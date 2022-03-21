package main

import (
	"fmt"
	"io/ioutil"
	"strconv"
	"strings"
)

func main(){
    fileContent, _ := ioutil.ReadFile("input.txt")
    var input []string = strings.Split(string(fileContent), "\n")
    var zero, one int
    var prefixOxygen, prefixScrubber string
    var oxygenStr, scrubberStr string
    var oxygenArray, scrubberArray []string

    for currentIndex := 0; currentIndex < 12; currentIndex++{
        zero = 0
        one = 0

        // count zeroes and ones
        for _, line := range input{
            if len(line) == 0{
                continue
            }
            if line[currentIndex] == '1'{
                one++
            }else if line[currentIndex] == '0'{
                zero++
            }
        }

        // update prefix
        if one > zero{
            prefixOxygen += "1"
            prefixScrubber += "0"
        }else if zero > one{
            prefixOxygen += "0"
            prefixScrubber += "1"
        }else {
            prefixOxygen += "1"
            prefixScrubber += "0"
        }

        oxygenArray = nil
        scrubberArray = nil
        // check how many strings have given prefix
        for _, line := range input{
            if strings.HasPrefix(line, prefixOxygen){
                oxygenArray = append(oxygenArray, line)
            }else if strings.HasPrefix(line, prefixScrubber){
                scrubberArray = append(scrubberArray, line)
            }
        }

        // check if ther is only one string
        if len(oxygenArray) == 1{
            oxygenStr = oxygenArray[0]
        }
        if len(scrubberArray) == 1{
            scrubberStr = scrubberArray[0]
        }
        if len(scrubberArray) == 4{
            for _, num := range scrubberArray{
                number, _ := strconv.ParseInt(num, 2, 64)
                fmt.Println(number)
            }
        }
    }

    scrubber, _ := strconv.ParseInt(scrubberStr, 2, 64)
    oxygen, _ := strconv.ParseInt(oxygenStr, 2, 64)
    fmt.Println(scrubber, oxygen)
}
