package day16

import helpers.readToEnd
fun generateRules(): HashMap<String, Int> {
    val rules = HashMap<String, Int>()
    rules.put("children", 3)
    rules.put("cats", 7)
    rules.put("samoyeds", 2)
    rules.put("pomeranians", 3)
    rules.put("akitas", 0)
    rules.put("vizslas", 0)
    rules.put("goldfish", 5)
    rules.put("trees", 3)
    rules.put("cars", 2)
    return rules
}

fun partOne(sues: ArrayList<HashMap<String, Int>>) {
    val rules = generateRules()
    var i = 0
    while (i < sues.size) {
        var valid = true
        for (pair in sues[i]) {
            if (rules.getOrDefault(pair.key, -1) != pair.value) {
                valid = false
                break
            }
        }
        if (valid) {
            println("Part one: ${i+1}")
            break
        }
        i += 1
    }
}
fun partTwo(sues: ArrayList<HashMap<String, Int>>) {
    val rules = generateRules()
    var i = 0
    while (i < sues.size) {
        var valid = true
        for (pair in sues[i]) {
            if (pair.key == "cats" || pair.key == "trees") {
                if (!rules.containsKey(pair.key) || pair.value <= rules[pair.key]!!) {
                    valid = false
                    break
                }
            } else if (pair.key == "pomeranians" || pair.key == "goldfish") {
                if (!rules.containsKey(pair.key) || pair.value >= rules[pair.key]!!) {
                    valid = false
                    break
                }
            } else if (rules.getOrDefault(pair.key, -1) != pair.value) {
                valid = false
                break
            }
        }
        if (valid) {
            println("Part two: ${i+1}")
            break
        }
        i += 1
    }
}

fun main() {
    val input = readToEnd()
    var sues = ArrayList<HashMap<String, Int>>()
    for (line in input.split("\n")) {
        var sue = HashMap<String, Int>()
        line
            .replace(Regex("Sue [0-9]*: "), "")
            .split(", ")
            .map {
                val (key, value) = it.split(": ")
                sue.put(key, value.toInt())
            }
        sues.add(sue)
    }
    partOne(sues)
    partTwo(sues)
}
