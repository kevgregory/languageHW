from dataclasses import dataclass
from collections.abc import Callable
from typing import List, Optional, Generator

def change(amount: int) -> dict[int, int]:
    if not isinstance(amount, int):
        raise TypeError('Amount must be an integer')
    if amount < 0:
        raise ValueError('Amount cannot be negative')
    counts, remaining = {}, amount
    for denomination in (25, 10, 5, 1):
        counts[denomination], remaining = divmod(remaining, denomination)
    return counts
    
# Write your first then lower case function here
def first_then_lower_case(a: List[str], p: Callable[[str], bool]) -> Optional[str]:
    for item in a:
        if p(item):
            return item.lower()
    return None

# Write your powers generator here
def powers_generator(*, base: int, limit: int) -> Generator[int, None, None]:
    value = 1
    while value <= limit:
        yield value
        value *= base

# Write your say function here
def say(word: str = None) -> Callable[[str], str] | str:
    words = []
    def inner(next_word: str = None) -> Callable[[str], str] | str:
        nonlocal words
        if next_word is None:
            return " ".join(words)
        words.append(next_word)
        return inner

    if word is not None:
        words.append(word)

    if word == "" and len(words) == 1:
        return inner

    return inner() if word is None else inner

# Write your line count function here
def meaningful_line_count(filename: str) -> int:
    try:
        with open(filename, 'r') as file:
            count = 0
            for line in file:
                stripped_line = line.strip()
                if stripped_line and not stripped_line.startswith("#"):
                    count += 1
            return count
    except FileNotFoundError as e:
        raise FileNotFoundError(f"No such file: {filename}") from e

# Write your Quaternion class here
@dataclass(frozen=True)
class Quaternion:
    a: float
    b: float
    c: float
    d: float

    @property
    def coefficients(self):
        return (self.a, self.b, self.c, self.d)

    @property
    def conjugate(self):
        return Quaternion(self.a, -self.b, -self.c, -self.d)

    def __add__(self, other):
        return Quaternion(
            self.a + other.a,
            self.b + other.b,
            self.c + other.c,
            self.d + other.d
        )

    def __mul__(self, other):
        a = self.a * other.a - self.b * other.b - self.c * other.c - self.d * other.d
        b = self.a * other.b + self.b * other.a + self.c * other.d - self.d * other.c
        c = self.a * other.c - self.b * other.d + self.c * other.a + self.d * other.b
        d = self.a * other.d + self.b * other.c - self.c * other.b + self.d * other.a
        return Quaternion(a, b, c, d)

    def __eq__(self, other):
        return (self.a, self.b, self.c, self.d) == (other.a, other.b, other.c, other.d)

    def __str__(self):
        components = []

        if self.a != 0:
            components.append(f"{self.a}")

        if self.b != 0:
            if self.b == 1:
                components.append("+i" if components else "i")
            elif self.b == -1:
                components.append("-i")
            else:
                components.append(f"{'+' if self.b > 0 and components else ''}{self.b}i")

        if self.c != 0:
            if self.c == 1:
                components.append("+j" if components else "j")
            elif self.c == -1:
                components.append("-j")
            else:
                components.append(f"{'+' if self.c > 0 and components else ''}{self.c}j")

        if self.d != 0:
            if self.d == 1:
                components.append("+k" if components else "k")
            elif self.d == -1:
                components.append("-k")
            else:
                components.append(f"{'+' if self.d > 0 and components else ''}{self.d}k")

        return "".join(components) or "0"