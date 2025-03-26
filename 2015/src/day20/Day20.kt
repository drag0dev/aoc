package day20

import helpers.readToEnd
import kotlin.math.sqrt

fun getDivisorSum(n: Int): List<Int> {
    return (1..sqrt(n.toDouble()).toInt())
        .filter { n % it == 0 }
        .flatMap { listOf(it, (n / it)) }
        .distinct()
}

fun partOne(target: Int) {
    var i = 1
    while(true) {
        var sum = getDivisorSum(i).sum() *10
        if (sum >= target) break
        i += 1
    }
    println("Part one: $i")
}

fun partTwo(target: Int) {
    var i = 1
    while(true) {
        var divisors = getDivisorSum(i).filter { i / it <= 50 }
        var sum = divisors.sum() * 11
        if (sum >= target) break
        i += 1
    }
    println("Part two: $i")
}

fun main () {
    val input = readToEnd()
    val target = input.toInt()
    partOne(target)
    partTwo(target)
}