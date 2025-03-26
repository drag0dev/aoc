package day17

import com.google.common.collect.Sets
import helpers.readToEnd

fun partOne(sizes: List<Int>) {
    val target = 150
    val indices = sizes.indices.toSet()
    var count = 0
    for (combSize in 1 .. sizes.size) {
        var combinations = Sets.combinations(indices, combSize)
        for (comb in combinations) if (comb.sumOf { sizes[it] } == target) count += 1
    }
    println("Part one: $count")
}

fun partTwo(sizes: List<Int>) {
    val target = 150
    val indices = sizes.indices.toSet()
    var count = 0
    for (combSize in 1 .. sizes.size) {
        count = 0
        var combinations = Sets.combinations(indices, combSize)
        for (comb in combinations) if (comb.sumOf { sizes[it] } == target) count += 1
        if (count > 0) break
    }
    println("Part two: $count")
}

fun main() {
    val input = readToEnd()
    val sizes = input.split("\n").map { it.toInt() }
    partOne(sizes)
    partTwo(sizes)
}
