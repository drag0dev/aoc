package day5

import helpers.readToEnd

fun partOne(input: String) {
    var count = 0
    for (line in input.split("\n")) {
        val containsForbidden =
            line.contains("ab") ||
            line.contains("cd") ||
            line.contains("pq") ||
            line.contains("xy")
        val vowelCount = line.count { it in "aeiou" }
        val containsDouble = line.windowed(2).any { it[0] == it[1] }
        if (!containsForbidden && vowelCount >= 3 && containsDouble) count += 1
    }
    println("Part one: $count")
}

fun partTwo(input: String) {
    var count = 0
    for (line in input.split("\n")) {
        val containsRepeat = line.windowed(3).any { it[0] == it[2] }
        val repeatDouble = line.windowed(2).any { double ->
            line.replace(double, "$double~")
                .windowed(2).count { it[0] == double[0] && it[1] == double[1] } >= 2
        }
        if (containsRepeat && repeatDouble) count += 1
    }
    println("Part two: $count")
}

fun main() {
    val input = readToEnd()
    partOne(input)
    partTwo(input)
}