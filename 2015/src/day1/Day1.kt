package day1

import helpers.readToEnd

fun partOne(input: String) {
    val res = input
        .asIterable()
        .fold(0)  { acc, paren ->
            when (paren) {
                '(' -> acc + 1
                ')' -> acc - 1
                else -> acc
            }
        }
    println("Part one: $res")
}

fun partTwo(input: String) {
    var floor = 0
    var resIndex = -1
    for ((index, paren) in input.withIndex()) {
        floor = when (paren) {
            '(' -> floor + 1
            ')' -> floor - 1
            else -> floor
        }

        if (floor == -1) {
            resIndex = index + 1
            break
        }
    }
    println("Part one: $resIndex")
}

fun main() {
    val input = readToEnd()
    partOne(input)
    partTwo(input)
}