package main

import(
    "fmt"
    "io/ioutil"
    "strings"
    "strconv"
)

func main(){
    content, _ := ioutil.ReadFile("input.txt")
    var input []string = strings.Split(string(content), "\n")

    var position, depth, aim int

    for _, command := range input{
        temp := strings.Split(command, " ")
        if temp[0] == "forward"{
            temp, _ := strconv.Atoi(temp[1])
            depth += aim * temp
            position += temp
        }else if temp[0] == "down"{
            temp, _ := strconv.Atoi(temp[1])
            aim += temp
        }else if temp[0] == "up"{
            temp, _ := strconv.Atoi(temp[1])
            aim -= temp
        }
    }

    fmt.Println(position * depth )
}
