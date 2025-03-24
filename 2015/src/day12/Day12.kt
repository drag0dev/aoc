package day12

import helpers.readToEnd

fun partOne(input: String) {
    var numbers = StringBuilder()
    var i = 0
    var numberStarted = false
    while (i < input.length) {
        if (input[i] in '0'..'9') {
            if (numberStarted) numbers.append(input[i])
            else {
                numbers.append(" ")
                numbers.append(input[i])
                numberStarted = true
            }
        } else if (input[i] == '-' && i + 1 < input.length && input[i + 1] in '0'..'9') {
            numbers.append(" -")
            numberStarted = true
        } else numberStarted = false
        i += 1
    }

    var res = numbers
        .toString()
        .drop(1)
        .split(" ")
        .map { it.toInt() }
        .sum()

    println("Part one: $res")
}

fun isRedPresent(input: String, startIdx: Int) : Boolean {
    var level = StringBuilder()
    var numberOfSublevels = 0
    var i = startIdx
    while (i < input.length) {
        if (input[i] == '}' || input[i] == ']') {
            numberOfSublevels -= 1;
            if (numberOfSublevels < 0) break
        } else if (input[i] == '{' || input[i] == '[') numberOfSublevels += 1
        else if(numberOfSublevels == 0) level.append(input[i])
        i += 1
    }
    return level.toString().contains("red")
}

fun partTwo(input: String) {
    var numbers = StringBuilder()
    var i = 0
    var numberStarted = false
    var stack = ArrayDeque<Boolean>()
    stack.addLast(false)
    while (i < input.length) {
        if (input[i] == '{') {
            stack.addLast(isRedPresent(input, i+1))
            numberStarted = false
        }
        else if (input[i] == '}') {
            stack.removeLast()
            numberStarted = false
        }
        else if (stack.any( { it })) numberStarted = false
        else if (input[i] in '0'..'9') {
            if (numberStarted) numbers.append(input[i])
            else {
                numbers.append(" ")
                numbers.append(input[i])
                numberStarted = true
            }
        } else if (input[i] == '-' && i + 1 < input.length && input[i + 1] in '0'..'9') {
            numbers.append(" -")
            numberStarted = true
        } else numberStarted = false
        i += 1
    }
    var res = numbers
        .toString()
        .drop(1)
        .split(" ")
        .map { it.toInt() }
        .sum()

    println("Part two: $res")
}

fun main() {
    val input = readToEnd()
    partOne(input)
    partTwo(input)
}