package day10

import helpers.readToEnd

fun partOne(input: Int, n: Int) {
    var current = input.toString()
    var next = StringBuilder()
    for (i in 1..n) {
        var currentDigit = current.first()
        var currentCount = 1
        current = current.drop(1)

        while (current.isNotEmpty()) {
            var top = current.first()
            if (top == currentDigit) {
                currentCount += 1
            } else {
                next.append("$currentCount$currentDigit")
                currentDigit = top
                currentCount = 1
            }
            current = current.drop(1)
        }

        next.append("$currentCount$currentDigit")
        current = next.toString()
        next = StringBuilder()
    }
    var res = current.length
    println(res)
}

fun main() {
    val input = readToEnd().toInt()
    print("Part one: ")
    partOne(input, 40)
    print("Part two: ")
    partOne(input, 50)
}