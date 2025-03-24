package day9

import helpers.readToEnd
import kotlin.math.max
import kotlin.math.min

fun partOne(destinations: MutableSet<String>, paths: MutableMap<Pair<String, String>, Int>) {
    var res = Int.MAX_VALUE
    for (destination in destinations) {
        var visited = mutableSetOf<String>()
        visited.add(destination)
        res = min(dfs_min(destinations, paths, visited, destination, 0), res)
    }
    println("Part one: $res")
}

fun dfs_min(destinations: MutableSet<String>, paths: MutableMap<Pair<String, String>, Int>, visited: MutableSet<String>, current: String, distanceCovered: Int) : Int {
    if (destinations.size == visited.size) return distanceCovered
    var minDistance = Int.MAX_VALUE
    for (destination in destinations) {
    if (!visited.contains(destination) && Pair(current, destination) in paths.keys) {
            visited.add(destination)
            minDistance = min(dfs_min(destinations, paths, visited, destination, distanceCovered + paths[Pair(current, destination)]!!), minDistance)
            visited.remove(destination)
        }
    }
    return minDistance
}

fun partTwo(destinations: MutableSet<String>, paths: MutableMap<Pair<String, String>, Int>) {
    var res = Int.MIN_VALUE
    for (destination in destinations) {
        var visited = mutableSetOf<String>()
        visited.add(destination)
        res = max(dfs_max(destinations, paths, visited, destination, 0), res)
    }
    println("Part two: $res")
}
fun dfs_max(destinations: MutableSet<String>, paths: MutableMap<Pair<String, String>, Int>, visited: MutableSet<String>, current: String, distanceCovered: Int) : Int {
    if (destinations.size == visited.size) return distanceCovered
    var maxDistance = Int.MIN_VALUE
    for (destination in destinations) {
        if (!visited.contains(destination) && Pair(current, destination) in paths.keys) {
            visited.add(destination)
            maxDistance = max(dfs_max(destinations, paths, visited, destination, distanceCovered + paths[Pair(current, destination)]!!), maxDistance)
            visited.remove(destination)
        }
    }
    return maxDistance
}

fun main() {
    val input = readToEnd()
    var destinations = mutableSetOf<String>()
    var paths = mutableMapOf<Pair<String, String>, Int>()
    for (line in input.split("\n")) {
        val (src, dst, distStr) =
            line
                .replace(" to ", " ")
                .replace(" = ", " ")
                .split(" ")

        val dist = distStr.toInt()
        destinations.add(dst)
        destinations.add(src)
        paths[Pair(src, dst)] = dist
        paths[Pair(dst, src)] = dist
    }
    partOne(destinations, paths)
    partTwo(destinations, paths)
}