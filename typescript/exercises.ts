import { open } from "node:fs/promises"

export function change(amount: bigint): Map<bigint, bigint> {
  if (amount < 0) {
    throw new RangeError("Amount cannot be negative")
  }
  let counts: Map<bigint, bigint> = new Map()
  let remaining = amount
  for (const denomination of [25n, 10n, 5n, 1n]) {
    counts.set(denomination, remaining / denomination)
    remaining %= denomination
  }
  return counts
}

export function firstThenApply<T, U>(
  arr: T[],
  predicate: (value: T) => boolean,
  fn: (value: T) => U
): U | undefined {
  const found = arr.find(predicate);
  return found !== undefined ? fn(found) : undefined;
}

export function* powersGenerator(base: bigint): Generator<bigint> {
  let power = 0n;
  while (true) {
    yield base ** power;
    power += 1n;
  }
}

export async function meaningfulLineCount(filePath: string): Promise<number> {
  const fileHandle = await open(filePath, 'r');
  let count = 0;

  try {
    for await (const line of fileHandle.readLines()) {
      if (line.trim() !== '' && !line.trim().startsWith('#')) {
        count++;
      }
    }
  } finally {
    await fileHandle.close();
  }

  return count;
}

export type Shape =
  | { kind: "Box"; width: number; length: number; depth: number }
  | { kind: "Sphere"; radius: number };

export function volume(shape: Shape): number {
  switch (shape.kind) {
    case "Box":
      return shape.width * shape.length * shape.depth;
    case "Sphere":
      return (4 / 3) * Math.PI * shape.radius ** 3;
  }
}

export function surfaceArea(shape: Shape): number {
  switch (shape.kind) {
    case "Box":
      return 2 * (shape.width * shape.length + shape.width * shape.depth + shape.length * shape.depth);
    case "Sphere":
      return 4 * Math.PI * shape.radius ** 2;
  }
}

class Node<T> {
  constructor(
    public value: T,
    public left: BinarySearchTree<T> = new Empty(),
    public right: BinarySearchTree<T> = new Empty()
  ) {}
}

export abstract class BinarySearchTree<T> {
  abstract insert(value: T): BinarySearchTree<T>;
  abstract contains(value: T): boolean;
  abstract size(): number;
  abstract inorder(): IterableIterator<T>;
  abstract toString(): string;
}

export class Empty<T> extends BinarySearchTree<T> {
  insert(value: T): BinarySearchTree<T> {
    return new NonEmpty(value);
  }

  contains(): boolean {
    return false;
  }

  size(): number {
    return 0;
  }

  *inorder(): IterableIterator<T> {
  }

  toString(): string {
    return "()";
  }
}

export class NonEmpty<T> extends BinarySearchTree<T> {
  constructor(
    private value: T,
    private left: BinarySearchTree<T> = new Empty(),
    private right: BinarySearchTree<T> = new Empty()
  ) {
    super();
  }

  insert(value: T): BinarySearchTree<T> {
    if (value < this.value) {
      return new NonEmpty(this.value, this.left.insert(value), this.right);
    } else if (value > this.value) {
      return new NonEmpty(this.value, this.left, this.right.insert(value));
    } else {
      return this; 
    }
  }

  contains(value: T): boolean {
    if (value < this.value) {
      return this.left.contains(value);
    } else if (value > this.value) {
      return this.right.contains(value);
    } else {
      return true;
    }
  }

  size(): number {
    return 1 + this.left.size() + this.right.size();
  }

  *inorder(): IterableIterator<T> {
    yield* this.left.inorder();
    yield this.value;
    yield* this.right.inorder();
  }

  toString(): string {
    const leftStr = this.left.toString();
    const rightStr = this.right.toString();
    return `(${leftStr === "()" ? "" : leftStr}${this.value}${rightStr === "()" ? "" : rightStr})`;
  }
}
