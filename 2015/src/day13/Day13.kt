package day13

import helpers.readToEnd
import kotlin.math.max

fun partOne(happinessChange: MutableMap<String, Int>, guests: MutableSet<String>) {
    var maxHappiness = Int.MIN_VALUE
    for (guest in guests) {
        var seatedGuests = ArrayList<String>()
        seatedGuests.add(guest)
        maxHappiness = max(maxHappiness, dfs(happinessChange, guests, seatedGuests))
    }
    println("Part one: $maxHappiness")
}

fun partTwo(happinessChange: MutableMap<String, Int>, guests: MutableSet<String>) {
    for (guest in guests) {
        happinessChange["Me$guest"] = 0
        happinessChange[guest + "Me"] = 0
    }
    guests.add("Me")
    var maxHappiness = Int.MIN_VALUE
    for (guest in guests) {
        var seatedGuests = ArrayList<String>()
        seatedGuests.add(guest)
        maxHappiness = max(maxHappiness, dfs(happinessChange, guests, seatedGuests))
    }
    println("Part two: $maxHappiness")
}

fun dfs(happinessChange: MutableMap<String, Int>, guests: MutableSet<String>, seatedGuests: ArrayList<String>) : Int {
    if (seatedGuests.size == guests.size) {
        var localHappiness = 0
        var i = 0
        while (i < seatedGuests.size) {
            if (i + 1 < seatedGuests.size) localHappiness += happinessChange["${seatedGuests[i]}${seatedGuests[i+1]}"]!!
            if (i - 1 >= 0) localHappiness += happinessChange["${seatedGuests[i]}${seatedGuests[i-1]}"]!!
            i += 1
        }
        val firstGuest = seatedGuests.first()
        val lastGuest = seatedGuests.last()
        localHappiness += happinessChange["$firstGuest$lastGuest"]!!
        localHappiness += happinessChange["$lastGuest$firstGuest"]!!
        return localHappiness
    } else {
        var maxHappiness = Int.MIN_VALUE
        for (guest in guests) {
            if (guest !in seatedGuests) {
                seatedGuests.add(guest)
                maxHappiness = max(maxHappiness, dfs(happinessChange, guests, seatedGuests))
                seatedGuests.remove(guest)
            }
        }
        return maxHappiness
    }
}

fun main() {
    val input = readToEnd()
    val happinessChange = mutableMapOf<String, Int>()
    val guests = mutableSetOf<String>()
    for (line in input.split("\n")) {
        val (guest, gainLose, happinessStr, guestTarget) = line
            .replace(" would ", " ")
            .replace(" happiness units by sitting next to ", " ")
            .dropLast(1)
            .split(" ")
        var happiness = happinessStr.toInt()
        if (gainLose == "lose") happiness = -happiness
        happinessChange["$guest$guestTarget"] = happiness
        guests.add(guest)
    }
    partOne(happinessChange, guests)
    partTwo(happinessChange, guests)
}