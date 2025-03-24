package day11

import helpers.readToEnd

fun incrementPassword(password: String): String {
    var newString = StringBuilder()
    var carry = 1
    for (c in password.reversed()) {
        if (carry > 0) {
            if (c == 'z') newString.append('a')
            else {
                carry = 0
                newString.append(c + 1)
            }
        } else newString.append(c)
    }
    return newString.toString().reversed()
}

fun generatePasswords(password: String) {
    var password = password
    var morePasswords = 2
    while (morePasswords > 0) {
        password = incrementPassword(password)
        var containsForbidden = password.any { it in "iol" }
        var containsStraight = password
                .windowed(3)
                .any { it[0] + 1 == it[1] && it[1] + 1 == it[2] }
        var doubleCount = 0
        var i = 1
        while (i < password.length) {
            if (password[i] == password[i-1]) {
                doubleCount += 1
                i += 1
            }
            i += 1
        }

        if (!containsForbidden && containsStraight && doubleCount > 1) {
            println(password)
            morePasswords -= 1
        }
    }
}

fun main() {
    val input = readToEnd()
    generatePasswords(input)
}