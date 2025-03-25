package day15

import helpers.readToEnd
import kotlin.math.max

data class Ingredient(val name: String, val capacity: Int, val durability: Int, val flavor: Int, val texture: Int, val calories: Int)

fun partOne(ingredients: List<Ingredient>) {
    val res = dfs(ingredients, 0, 0, 0, 0, 0, 100, mutableSetOf())
    println("Part one: $res")
}

fun dfs(ingredients: List<Ingredient>, cap: Int, dur: Int, fla: Int, tex: Int, cal: Int, remaining: Int, usedUp: MutableSet<Ingredient>): Int {
    if (remaining == 0) {
        if (cap < 0 || dur < 0 || fla < 0 || tex < 0) return 0
        return cap * dur * fla * tex
    }
    else {
        var localMax = Int.MIN_VALUE
        for (ingredient in ingredients) {
            if (ingredient in usedUp) continue
            usedUp.add(ingredient)
            for (n in 0 .. remaining)  {
                val localRes = dfs(ingredients, cap + n*ingredient.capacity, dur + n*ingredient.durability,
                    fla + n*ingredient.flavor, tex + n*ingredient.texture, cal + n*ingredient.calories, remaining - n, usedUp)
                localMax = max(localMax, localRes)
            }
            usedUp.remove(ingredient)
        }
        return localMax
    }
}

fun partTwo(ingredients: List<Ingredient>) {
    val res = dfsPartTwo(ingredients, 0, 0, 0, 0, 0, 100, mutableSetOf())
    println("Part two: $res")
}

fun dfsPartTwo(ingredients: List<Ingredient>, cap: Int, dur: Int, fla: Int, tex: Int, cal: Int, remaining: Int, usedUp: MutableSet<Ingredient>): Int {
    if (remaining == 0) {
        if (cap < 0 || dur < 0 || fla < 0 || tex < 0 || cal != 500) return 0
        return cap * dur * fla * tex
    }
    else {
        var localMax = Int.MIN_VALUE
        for (ingredient in ingredients) {
            if (ingredient in usedUp) continue
            usedUp.add(ingredient)
            for (n in 0 .. remaining)  {
                val localRes = dfsPartTwo(ingredients, cap + n*ingredient.capacity, dur + n*ingredient.durability,
                    fla + n*ingredient.flavor, tex + n*ingredient.texture, cal + n*ingredient.calories, remaining - n, usedUp)
                localMax = max(localMax, localRes)
            }
            usedUp.remove(ingredient)
        }
        return localMax
    }
}


fun main() {
    val input = readToEnd()
    val ingredients = ArrayList<Ingredient>()
    for (line in input.split("\n")) {
        val parts = line
            .replace(": capacity", "")
            .replace(", durability", "")
            .replace(", flavor", "")
            .replace(", texture", "")
            .replace(", calories", "")
            .split(" ")
        ingredients.add(Ingredient(parts[0], parts[1].toInt(), parts[2].toInt(), parts[3].toInt(), parts[4].toInt(), parts[5].toInt()))
    }
    partOne(ingredients)
    partTwo(ingredients)
}
