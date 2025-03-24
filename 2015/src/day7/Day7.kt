package day7

import helpers.readToEnd

sealed class Action {
    data class AND(val leftOperand: String, val rightOperand: String, val target: String, var retired: Boolean = false) : Action()
    data class OR(val leftOperand: String, val rightOperand: String, val target: String, var retired: Boolean = false) : Action()
    data class LSHIFT(val leftOperand: String, val rightOperand: String, val target: String, var retired: Boolean = false) : Action()
    data class RSHIFT(val leftOperand: String, val rightOperand: String, val target: String, var retired: Boolean = false) : Action()
    data class NOT(val leftOperand: String, val rightOperand: String, val target: String, var retired: Boolean = false) : Action()
    data class LOAD(var leftOperand: String, val rightOperand: String, val target: String, var retired: Boolean = false) : Action()
}

fun applyActions(actions: MutableList<Action>, wires: MutableMap<String, Int>) {
    var retiredCount = 0
    while (true) {
        for (action in actions) {
            when (action) {
                is Action.AND -> {
                    if (action.retired) continue
                    var left = action.leftOperand.toIntOrNull()
                    if (left == null) left = wires[action.leftOperand] ?: continue
                    var right = action.rightOperand.toIntOrNull()
                    if (right == null) right = wires[action.rightOperand] ?: continue
                    wires[action.target] = left and right
                    retiredCount += 1
                    action.retired = true
                }
                is Action.OR -> {
                    if (action.retired) continue
                    var left = action.leftOperand.toIntOrNull()
                    if (left == null) left = wires[action.leftOperand] ?: continue
                    var right = action.rightOperand.toIntOrNull()
                    if (right == null) right = wires[action.rightOperand] ?: continue
                    wires[action.target] = left or right
                    retiredCount += 1
                    action.retired = true
                }
                is Action.LSHIFT -> {
                    if (action.retired) continue
                    var left = action.leftOperand.toIntOrNull()
                    if (left == null) left = wires[action.leftOperand] ?: continue
                    var right = action.rightOperand.toIntOrNull()
                    if (right == null) right = wires[action.rightOperand] ?: continue
                    wires[action.target] = left shl right
                    retiredCount += 1
                    action.retired = true
                }
                is Action.RSHIFT -> {
                    if (action.retired) continue
                    var left = action.leftOperand.toIntOrNull()
                    if (left == null) left = wires[action.leftOperand] ?: continue
                    var right = action.rightOperand.toIntOrNull()
                    if (right == null) right = wires[action.rightOperand] ?: continue
                    wires[action.target] = left shr right
                    retiredCount += 1
                    action.retired = true
                }
                is Action.NOT -> {
                    if (action.retired) continue
                    var left = action.leftOperand.toIntOrNull()
                    if (left == null) left = wires[action.leftOperand] ?: continue
                    wires[action.target] = left.inv()
                    retiredCount += 1
                    action.retired = true
                }
                is Action.LOAD -> {
                    if (action.retired) continue
                    var left = action.leftOperand.toIntOrNull()
                    if (left == null) left = wires[action.leftOperand] ?: continue
                    wires[action.target] = left
                    retiredCount += 1
                    action.retired = true
                }
            }
        }
        if (retiredCount == actions.size) break
    }
    for (action in actions) {
        when (action) {
            is Action.AND -> action.retired = false
            is Action.OR -> action.retired = false
            is Action.LSHIFT -> action.retired = false
            is Action.RSHIFT -> action.retired = false
            is Action.NOT -> action.retired = false
            is Action.LOAD -> action.retired = false
        }
    }
}

fun partOne(actions: MutableList<Action>) {
    var wires = mutableMapOf<String, Int>()
    applyActions(actions, wires)
    val result = wires["a"]
    println("Part one: $result")
}

fun partTwo(actions: MutableList<Action>) {
    var wires = mutableMapOf<String, Int>()
    applyActions(actions, wires)

    var result = wires["a"]
    wires.clear()
    for (action in actions) {
        when (action) {
            is Action.LOAD -> if (action.target == "b") action.leftOperand = result.toString()
            else -> continue
        }
    }
    wires["b"] = result ?: -1
    applyActions(actions, wires)

    result = wires["a"]
    println("Part two: $result")
}

fun main() {
    val input = readToEnd()
    val actions = mutableListOf<Action>()
    for (line in input.split("\n")) {
        val line = line.replace(" -> ", " ")
        if (line.contains("AND")) {
            val (left, right, target) = line
                    .replace(" AND ", " ")
                    .split(" ")
            actions.add(Action.AND(left, right, target))
        } else if (line.contains("OR")) {
            val (left, right, target) = line
                .replace(" OR ", " ")
                .split(" ")
            actions.add(Action.OR(left, right, target))
        } else if (line.contains("LSHIFT")) {
            val (left, right, target) = line
                .replace(" LSHIFT ", " ")
                .split(" ")
            actions.add(Action.LSHIFT(left, right, target))
        } else if (line.contains("RSHIFT")) {
            val (left, right, target) = line
                .replace(" RSHIFT ", " ")
                .split(" ")
            actions.add(Action.RSHIFT(left, right, target))
        } else if (line.contains("NOT")) {
            val (left, target) = line
                .replace("NOT ", "")
                .split(" ")
            actions.add(Action.NOT(left, "", target))
        } else {
            val (left, target) = line
                .split(" ")
            actions.add(Action.LOAD(left, "", target))
        }
    }
    partOne(actions)
    partTwo(actions)
}