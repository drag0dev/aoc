package day2

import helpers.readToEnd

class Dimensions (val l: Int, val w: Int, val h: Int)

fun partOne(input: MutableList<Dimensions>) {
    var total = 0
    for (gift in input) {
        val a = 2 * gift.l * gift.w
        val b = 2 * gift.l * gift.h
        val c = 2 * gift.w * gift.h
        total += a + b + c + gift.l * gift.w
    }
    println("Part one: $total")
}

fun partTwo(input: MutableList<Dimensions>) {
    var total = 0
    for (gift in input){
        total += (2*gift.l + 2*gift.w) + gift.l * gift.w * gift.h
    }
    println("Part two: $total")
}

fun main() {
    val input = readToEnd()
    val dimensions = mutableListOf<Dimensions>()
    for (line in input.split("\n")) {
        val (l, w, h) = line.split("x").map { it.toInt() } .sorted()
        dimensions.add(Dimensions(l, w, h))
    }
    partOne(dimensions)
    partTwo(dimensions)
}