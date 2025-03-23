package day4

import helpers.readToEnd
import java.security.MessageDigest

fun partOne(input: String) {
    var md = MessageDigest.getInstance("MD5")
    var i = 0;
    while (true) {
        var input = "$input$i"
        val digest = md.digest(input.toByteArray())
        var res = digest.joinToString("") { "%02x".format(it) }
        if (res.startsWith("00000")) {
            println("Part one: $i")
            break
        }
        i += 1
    }
}

fun partTwo(input: String) {
    var md = MessageDigest.getInstance("MD5")
    var i = 0;
    while (true) {
        var input = "$input$i"
        val digest = md.digest(input.toByteArray())
        var res = digest.joinToString("") { "%02x".format(it) }
        if (res.startsWith("000000")) {
            println("Part two: $i")
            break
        }
        i += 1
    }
}

fun main() {
    val input = readToEnd()
    partOne(input)
    partTwo(input)
}