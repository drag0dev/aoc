package day14

import helpers.readToEnd
import kotlin.math.max
import kotlin.math.min

data class Comet(val name: String, val speed: Int, val flyTime: Int, val timeout: Int)
data class CometState(var flying: Boolean = true, var flyingTime: Int = 0, var restingTime: Int = 0)

fun partOne(comets: ArrayList<Comet>) {
    val seconds = 2503
    var maxDistance = Int.MIN_VALUE
    for (comet in comets) {
        val interval = comet.flyTime + comet.timeout
        var wholeIntervals = seconds / interval
        var currentDistance = wholeIntervals * comet.speed * comet.flyTime
        currentDistance += min(comet.flyTime, seconds - wholeIntervals * interval) * comet.speed
        maxDistance = max(maxDistance, currentDistance)
    }
    println("Part one: $maxDistance")
}

fun partTwo(comets: ArrayList<Comet>) {
    val seconds = 2503
    var distances = IntArray(comets.size) { 0 }
    var points = IntArray(comets.size) { 0 }
    var cometStates = ArrayList<CometState>(comets.size)
    repeat(comets.size) { i -> cometStates.add(CometState(true, 0, 0)) }
    for (second in 0 until seconds) {
        for (cometIdx in comets.withIndex()) {
            val comet = cometIdx.value
            if (!cometStates[cometIdx.index].flying) {
                cometStates[cometIdx.index].restingTime += 1
                if (cometStates[cometIdx.index].restingTime == comet.timeout) {
                    cometStates[cometIdx.index].restingTime = 0
                    cometStates[cometIdx.index].flying = true
                }
            } else {
                cometStates[cometIdx.index].flyingTime += 1
                if (cometStates[cometIdx.index].flyingTime == comet.flyTime) {
                    cometStates[cometIdx.index].flyingTime = 0
                    cometStates[cometIdx.index].flying = false
                }
                distances[cometIdx.index] += comet.speed
            }
        }

        var maxDistance = Int.MIN_VALUE
        for (distance in distances) maxDistance = max(maxDistance, distance)

        var i = 0
        while (i < comets.size) {
            if (distances[i] == maxDistance) points[i] += 1
            i += 1
        }
    }

    var res = points.max()
    println("Part two: $res")
}

fun main() {
    val input = readToEnd()
    var comets = ArrayList<Comet>()
    for (line in input.split("\n")) {
        val (name, speed, fltTime, timeout) = line
            .replace(" can fly ", " ")
            .replace(" km/s for ", " ")
            .replace(" seconds, but then must rest for ", " ")
            .replace(" seconds.", "")
            .split(" ")
        comets.add(Comet(name, speed.toInt(), fltTime.toInt(), timeout.toInt()))
    }
    partOne(comets)
    partTwo(comets)
}