package main

import (
	"fmt"
	"io/ioutil"
	"strconv"
	"strings"
)

func caclulateRes(ticket string)(int){
    var res int = 0

    ticket = strings.ReplaceAll(ticket, "\n", " ")

    for _, number := range strings.Split(ticket, " "){
        if !strings.Contains(number, "F"){
            num, _ := strconv.Atoi(number)
            res += num
        }
    }
    return res
}

// garbage slow solution
func main(){
    content, _ := ioutil.ReadFile("input.txt")
    formatedData := strings.Split(string(content), "\n\n")

    tickets := strings.Replace(string(content), formatedData[0]+"\n", "", 1)
    var drawnNumbersStr []string = strings.Split(formatedData[0], ",")
    var drawnNumbers []int
    var sum int

    for _, ker := range drawnNumbersStr{
        number, _ := strconv.Atoi(ker)
        drawnNumbers = append(drawnNumbers, number)
    }

    for _, drawnNumber := range drawnNumbers{
        if drawnNumber < 10 {
            fmt.Print("manji")
            tickets = strings.Replace(tickets, fmt.Sprintf("\n %d ", drawnNumber), fmt.Sprintf("\n%dF ", drawnNumber), 1)
            tickets = strings.Replace(tickets, fmt.Sprintf("  %d ", drawnNumber), fmt.Sprintf(" %dF ", drawnNumber), 1)
            tickets = strings.Replace(tickets, fmt.Sprintf("  %d\n", drawnNumber), fmt.Sprintf(" %dF\n", drawnNumber), 1)
        } else{
            tickets = strings.Replace(tickets, fmt.Sprintf("\n%d", drawnNumber), fmt.Sprintf("\n%dF", drawnNumber), 1)
            tickets = strings.Replace(tickets, fmt.Sprintf(" %d ", drawnNumber), fmt.Sprintf(" %dF ", drawnNumber), 1)
            tickets = strings.Replace(tickets, fmt.Sprintf(" %d\n", drawnNumber), fmt.Sprintf(" %dF\n", drawnNumber), 1)
        }

        //check if there is a winning ticket
        for _, ticket := range strings.Split(tickets, "\n\n"){
            var ticketLines []string = strings.Split(ticket, "\n")

            // rows
            for _, ticketLine := range ticketLines{
                if(strings.Count(ticketLine, "F") == 5){
                    fmt.Println("Winning number:", drawnNumber)
                    sum = caclulateRes(ticket) * drawnNumber
                    break
                }
            }

            // columns
            var numOfFs [6]int
            for _, line := range ticketLines{
                for index, number := range strings.Split(strings.ReplaceAll(line, "  ", " "), " "){
                    if strings.Contains(number, "F"){
                        numOfFs[index] = numOfFs[index]+1
                    }
                }

                // check if there is a winning ticket
                for _, line := range numOfFs{
                    if line == 5 {
                        sum = caclulateRes(ticket)
                        break
                    }
                }

            }

            if sum != 0{
                break
            }

        }
        if sum != 0{
            break
        }
    }

    fmt.Println(tickets)

    fmt.Println(sum)
}
