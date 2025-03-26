package day19

import helpers.readToEnd

class SubstringReplacer(private val original: String, private val oldValue: String, private val newValue: String) {
    private var currentIndex = 0

    fun replaceNext(uniqueMolecules: MutableSet<String>): Boolean {
        val index = original.indexOf(oldValue, currentIndex)
        if (index == -1) return false

        val result = original.substring(0, index) +
                    newValue +
                    original.substring(index + oldValue.length)

        currentIndex = index + oldValue.length
        uniqueMolecules.add(result)
        return true
    }
}

fun partOne(rules: List<Pair<String, String>>, molecule: String) {
    var uniqueMolecules = mutableSetOf<String>()
    for (rule in rules) {
       var replacer = SubstringReplacer(molecule, rule.first, rule.second)
       while (replacer.replaceNext(uniqueMolecules)) {}
    }
    println("Part one: ${uniqueMolecules.size}")
}

fun main() {
    val input = readToEnd()
    val (rulesStr, molecule) = input.split("\n\n")
    val rules = rulesStr.split("\n").map {
         val (from, to) = it.split(" => ")
         Pair(from, to)
    }
    partOne(rules, molecule)
}