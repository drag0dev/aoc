package day3

import helpers.readToEnd

fun partOne(input: String) {
    var x = 0
    var y = 0
    var visited = mutableSetOf<Pair<Int, Int>>()
    visited.add(Pair(x, y))

    for (c in input) {
        when (c) {
            '^' -> y += 1
            '>' -> x += 1
            'v' -> y -= 1
            '<' -> x -= 1
        }
        visited.add(Pair(x, y))
    }
    var total_visited = visited.size
    println("Part one: $total_visited")
}

fun partTwo(input: String) {
    var xSanta = 0
    var ySanta = 0
    var xRobot = 0
    var yRobot = 0
    var visited = mutableSetOf<Pair<Int, Int>>()
    visited.add(Pair(0, 0))

    input.chunked(2).forEach {
        var santa = it[0]
        var robot = it[1]
        when (santa) {
            '^' -> ySanta += 1
            '>' -> xSanta += 1
            'v' -> ySanta -= 1
            '<' -> xSanta -= 1
        }
        visited.add(Pair(xSanta, ySanta))
        when (robot) {
            '^' -> yRobot += 1
            '>' -> xRobot += 1
            'v' -> yRobot -= 1
            '<' -> xRobot -= 1
        }
        visited.add(Pair(xRobot, yRobot))
    }
    var total_visited = visited.size
    println("Part one: $total_visited")
}

fun main() {
    val input = readToEnd()
    partOne(input)
    partTwo(input)
}