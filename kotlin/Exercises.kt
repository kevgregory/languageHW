import java.io.BufferedReader
import java.io.FileReader
import java.io.IOException

fun change(amount: Long): Map<Int, Long> {
    require(amount >= 0) { "Amount cannot be negative" }
    
    val counts = mutableMapOf<Int, Long>()
    var remaining = amount
    for (denomination in listOf(25, 10, 5, 1)) {
        counts[denomination] = remaining / denomination
        remaining %= denomination
    }
    return counts
}

// first then lower case function
fun firstThenLowerCase(list: List<String>, predicate: (String) -> Boolean): String? {
    return list.firstOrNull(predicate)?.lowercase()
}
// say function 
class Say(private val currentPhrase: String = "") {

    fun and(word: String): Say {
        return Say(this.currentPhrase + " " + word)
    }

    val phrase: String
        get() = currentPhrase
}

fun say(word: String = ""): Say {
    return Say(word)
}

//  meaningfulLineCount function 
fun meaningfulLineCount(filename: String): Long {
    BufferedReader(FileReader(filename)).use { reader ->
        return reader.lineSequence()
            .filter { it.trim().isNotEmpty() }
            .filter { !it.trim().startsWith("#") }
            .count()
            .toLong()
    }
}
//  Quaternion 
data class Quaternion(val a: Double, val b: Double, val c: Double, val d: Double) {

    companion object {
        val ZERO = Quaternion(0.0, 0.0, 0.0, 0.0)
        val I = Quaternion(0.0, 1.0, 0.0, 0.0)
        val J = Quaternion(0.0, 0.0, 1.0, 0.0)
        val K = Quaternion(0.0, 0.0, 0.0, 1.0)
    }

    operator fun plus(other: Quaternion): Quaternion {
        return Quaternion(a + other.a, b + other.b, c + other.c, d + other.d)
    }

    operator fun times(other: Quaternion): Quaternion {
        val newA = a * other.a - b * other.b - c * other.c - d * other.d
        val newB = a * other.b + b * other.a + c * other.d - d * other.c
        val newC = a * other.c - b * other.d + c * other.a + d * other.b
        val newD = a * other.d + b * other.c - c * other.b + d * other.a
        return Quaternion(newA, newB, newC, newD)
    }

    fun coefficients(): List<Double> {
        return listOf(a, b, c, d)
    }

    fun conjugate(): Quaternion {
        return Quaternion(a, -b, -c, -d)
    }

    override fun toString(): String {
        return when {
            a == 0.0 && b == 0.0 && c == 0.0 && d == 0.0 -> "0"
            else -> formatQuaternion(a, b, c, d)
        }
    }

    private fun formatQuaternion(a: Double, b: Double, c: Double, d: Double): String {
        val terms = mutableListOf<String>()

        if (a != 0.0) {
            terms.add(formatTerm(a, "", isFirst = true))
        }
        if (b != 0.0) {
            terms.add(formatTerm(b, "i", isFirst = terms.isEmpty()))
        }
        if (c != 0.0) {
            terms.add(formatTerm(c, "j", isFirst = terms.isEmpty()))
        }
        if (d != 0.0) {
            terms.add(formatTerm(d, "k", isFirst = terms.isEmpty()))
        }

        return terms.joinToString(separator = "")
    }

    private fun formatTerm(value: Double, suffix: String, isFirst: Boolean): String {
        return when {
            value == 0.0 -> ""
            value == 1.0 && suffix.isNotEmpty() -> if (isFirst) suffix else "+$suffix"
            value == -1.0 && suffix.isNotEmpty() -> "-$suffix"
            value > 0 && suffix.isNotEmpty() -> if (isFirst) "$value$suffix" else "+$value$suffix"
            value > 0 -> value.toString()
            suffix.isNotEmpty() -> "$value$suffix"
            else -> value.toString()
        }
    }
}

// Binary Search Tree interface and implementing classes
sealed interface BinarySearchTree {
    fun insert(value: String): BinarySearchTree
    fun contains(value: String): Boolean
    fun size(): Int
    override fun toString(): String

    object Empty : BinarySearchTree {
        override fun insert(value: String): BinarySearchTree {
            return Node(value, Empty, Empty)
        }

        override fun contains(value: String): Boolean = false

        override fun size(): Int = 0

        override fun toString(): String = "()"
    }

    data class Node(val value: String, val left: BinarySearchTree, val right: BinarySearchTree) : BinarySearchTree {
        override fun insert(newValue: String): BinarySearchTree {
            return when {
                newValue < value -> Node(value, left.insert(newValue), right)
                newValue > value -> Node(value, left, right.insert(newValue))
                else -> this
            }
        }

        override fun contains(target: String): Boolean {
            return when {
                target == value -> true
                target < value -> left.contains(target)
                else -> right.contains(target)
            }
        }

        override fun size(): Int = 1 + left.size() + right.size()

        override fun toString(): String {
            val leftStr = if (left == Empty) "" else left.toString()
            val rightStr = if (right == Empty) "" else right.toString()
            return "($leftStr$value$rightStr)"
        }
    }
}

