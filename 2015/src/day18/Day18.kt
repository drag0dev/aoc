package day18

import helpers.readToEnd

fun partOne(grid: List<IntArray>) {
    var grid = grid
    val steps = 100
    for (_step in 0 until steps) {
        var newGrid = grid.map { it.clone() }
        for (i in grid.indices) {
            for (j in grid[i].indices) {
                var count = 0
                for (k in -1 .. 1) {
                    for (l in -1 .. 1) {
                        if (k == 0 && l == 0) continue
                        if (i + k in grid.indices && j + l in grid[i + k].indices && grid[i+k][j+l] == 1) {
                            count += grid[i + k][j + l]
                        }
                    }
                }
                if (grid[i][j] == 1 && count != 2 && count != 3) newGrid[i][j] = 0
                else if (grid[i][j] == 0 && count == 3) newGrid[i][j] = 1
            }
        }
        grid = newGrid
    }
    var res = 0
    for (i in grid.indices) for (j in grid[i].indices) if (grid[i][j] == 1) res += 1
    println("Part one: $res")
}

fun partTwo(grid: List<IntArray>) {
    var grid = grid
    val steps = 100
    var height = grid.size
    var width = grid[0].size
    grid[0][0] = 1
    grid[0][width-1] = 1
    grid[height-1][0] = 1
    grid[height-1][width-1] = 1
    for (_step in 0 until steps) {
        var newGrid = grid.map { it.clone() }
        for (i in grid.indices) {
            for (j in grid[i].indices) {
                var count = 0
                for (k in -1 .. 1) {
                    for (l in -1 .. 1) {
                        if (k == 0 && l == 0) continue
                        if (i + k in grid.indices && j + l in grid[i + k].indices && grid[i+k][j+l] == 1) {
                            count += grid[i + k][j + l]
                        }
                    }
                }
                if (grid[i][j] == 1 && count != 2 && count != 3) newGrid[i][j] = 0
                else if (grid[i][j] == 0 && count == 3) newGrid[i][j] = 1
            }
        }
        grid = newGrid
        grid[0][0] = 1
        grid[0][width-1] = 1
        grid[height-1][0] = 1
        grid[height-1][width-1] = 1
    }
    var res = 0
    for (i in grid.indices) for (j in grid[i].indices) if (grid[i][j] == 1) res += 1
    println("Part one: $res")
}

fun main() {
    val input = readToEnd()
    val grid = input
        .split("\n")
        .map { it.chars().map {
            if (it == '.'.code) 0
            else 1
        }.toArray()}
    partOne(grid)
    partTwo(grid)
}