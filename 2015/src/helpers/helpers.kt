package helpers

import java.io.File

fun readToEnd() : String {
    val file = File("input")
    return file.readText().trimEnd();
}
