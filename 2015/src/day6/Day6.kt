package day6

import helpers.readToEnd

enum class ActionType { ON, OFF, TOGGLE }

class Action (val type: ActionType, val x1: Int, val y1: Int, val x2: Int, val y2: Int)

fun partOne(actions: MutableList<Action>) {
    var lights = Array(1000) { BooleanArray(1000) { false } }

    for (action in actions) {
        val apply = when (action.type) {
            ActionType.ON -> {_: Boolean -> true}
            ActionType.OFF -> {_: Boolean -> false}
            ActionType.TOGGLE -> {currentState: Boolean -> !currentState}
        }
        for (x in action.x1..action.x2) for (y in action.y1..action.y2) lights[x][y] = apply(lights[x][y])
    }

    var count = 0
    for (lightRow in lights) count += lightRow.count { it }
    println("Part one: $count")
}

fun partTwo(actions: MutableList<Action>) {
    var lights = Array(1000) { IntArray(1000) { 0 } }

    for (action in actions) {
        val apply = when (action.type) {
            ActionType.ON -> {currentState: Int -> currentState + 1 }
            ActionType.OFF -> {currentState: Int -> if ((currentState - 1) < 0) 0 else currentState - 1 }
            ActionType.TOGGLE -> {currentState: Int -> currentState + 2}
        }
        for (x in action.x1..action.x2) for (y in action.y1..action.y2) lights[x][y] = apply(lights[x][y])
    }

    var count = 0
    for (lightRow in lights) for (light in lightRow) count += light
    println("Part two: $count")
}

fun main() {
    val input = readToEnd()
    var actions = mutableListOf<Action>()
    for (line in input.split("\n")) {
        if (line.startsWith("turn on ")) {
            var (x1, y1, x2, y2) = line
                .replace("turn on ", "")
                .replace(" through ", ",")
                .split(",")
                .map { it.toInt() }
            actions.add(Action(ActionType.ON, x1, y1, x2, y2))
        } else if (line.startsWith("turn off ")) {
            var (x1, y1, x2, y2) = line
                .replace("turn off ", "")
                .replace(" through ", ",")
                .split(",")
                .map { it.toInt() }
            actions.add(Action(ActionType.OFF, x1, y1, x2, y2))
        } else {
            var (x1, y1, x2, y2) = line
                .replace("toggle ", "")
                .replace(" through ", ",")
                .split(",")
                .map { it.toInt() }
            actions.add(Action(ActionType.TOGGLE, x1, y1, x2, y2))
        }
    }

    partOne(actions)
    partTwo(actions)
}