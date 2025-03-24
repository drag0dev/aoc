package day8

import helpers.readToEnd

fun partOne(input: String) {
    var res = 0

    for (line in input.split("\n")) {
        res += line.length -
            line
                .drop(1)
                .dropLast(1)
                .replace("\\\"", "A")
                .replace("\\\\", "B")
                .replace(Regex("\\\\x[0-9a-f]{2}"), "C")
                .length
    }

    println("Part one: $res")
}

fun partTwo(input: String) {
    var res = 0
    for (line in input.split("\n")) {
        res += 2 + line.count { it == '"' } + line.count { it == '\\' }
    }
    println("Part two: $res")
}

fun main() {
    val input = readToEnd()
    partOne(input)
    partTwo(input)
}