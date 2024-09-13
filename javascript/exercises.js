import { open } from "node:fs/promises"

export function change(amount) {
  if (!Number.isInteger(amount)) {
    throw new TypeError("Amount must be an integer")
  }
  if (amount < 0) {
    throw new RangeError("Amount cannot be negative")
  }
  let [counts, remaining] = [{}, amount]
  for (const denomination of [25, 10, 5, 1]) {
    counts[denomination] = Math.floor(remaining / denomination)
    remaining %= denomination
  }
  return counts
}

// Write your first then lower case function here
export function firstThenLowerCase(arr, predicate) {
  const result = arr.find(predicate) // this is to find the element which satisfies the predicate

  return result?.toLowerCase()
}
// Write your powers generator here
export function* powersGenerator({ ofBase, upTo }) {
  let value = 1 // to start with base value 1

  while (value <= upTo) {
    yield value
    value *= ofBase
  }
}
// Write your say function here

export function say(word) {
  let words = word !== undefined ? [word] : []
  function innerSay(nextWord) {
    if (nextWord === undefined) {
      return words.join(" ")
    }
    words.push(nextWord)
    return innerSay
  }
  return word === undefined ? "" : innerSay
}

// Write your line count function here
export async function meaningfulLineCount(filename) {
  try {
    const file = await open(filename, "r")
    let meaningfulLines = 0

    for await (const line of file.readLines()) {
      // to read each line of the file
      const trimmed = line.trim()
      if (trimmed.length > 0 && !trimmed.startsWith("#")) {
        meaningfulLines++
      }
    }
    await file.close()
    return meaningfulLines
  } catch (error) {
    throw new Error("no file") // if file is not found it will output an error
  }
}
// Write your Quaternion class here
export class Quaternion {
  constructor(a, b, c, d) {
    this.a = a
    this.b = b
    this.c = c
    this.d = d
    Object.freeze(this)
  }

  get conjugate() {
    return new Quaternion(this.a, -this.b, -this.c, -this.d)
  }

  get coefficients() {
    return [this.a, this.b, this.c, this.d]
  }

  plus(q) {
    return new Quaternion(
      this.a + q.a,
      this.b + q.b,
      this.c + q.c,
      this.d + q.d
    )
  }

  times(q) {
    return new Quaternion(
      this.a * q.a - this.b * q.b - this.c * q.c - this.d * q.d,
      this.a * q.b + this.b * q.a + this.c * q.d - this.d * q.c,
      this.a * q.c - this.b * q.d + this.c * q.a + this.d * q.b,
      this.a * q.d + this.b * q.c - this.c * q.b + this.d * q.a
    )
  }

  equals(q) {
    return this.a === q.a && this.b === q.b && this.c === q.c && this.d === q.d
  }

  toString() {
    const terms = []

    if (this.a !== 0) terms.push(`${this.a}`)
    if (this.b !== 0)
      terms.push(this.b === 1 ? "i" : this.b === -1 ? "-i" : `${this.b}i`)
    if (this.c !== 0)
      terms.push(this.c === 1 ? "j" : this.c === -1 ? "-j" : `${this.c}j`)
    if (this.d !== 0)
      terms.push(this.d === 1 ? "k" : this.d === -1 ? "-k" : `${this.d}k`)

    return terms.length === 0 ? "0" : terms.join("+").replace(/\+\-/g, "-")
  }
}
