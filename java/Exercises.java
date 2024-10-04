import java.util.List;
import java.util.Map;
import java.util.HashMap;
import java.util.Optional;
import java.util.function.Predicate;
import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;

public class Exercises {
    static Map<Integer, Long> change(long amount) {
        if (amount < 0) {
            throw new IllegalArgumentException("Amount cannot be negative");
        }
        var counts = new HashMap<Integer, Long>();
        for (var denomination : List.of(25, 10, 5, 1)) {
            counts.put(denomination, amount / denomination);
            amount %= denomination;
        }
        return counts;
    }

    // Write your first then lower case function here
    public static Optional<String> firstThenLowerCase(List<String> strings, Predicate<String> predicate) {
        return strings.stream()
                .filter(predicate)  // Filter elements based on the given predicate
                .findFirst()        // Find the first matching element
                .map(String::toLowerCase);  // Convert the result to lowercase if present
    }
    // Write your say function here
    public static Say say() {
        return new Say("");
    }

    // say method with a single argument
    public static Say say(String word) {
        return new Say(word);
    }

    public static class Say {
        private final String phrase;

        public Say(String word) {
            this.phrase = word;
        }

        public Say and(String word) {
            return new Say(this.phrase + " " + word);
        }

        public String phrase() {
            return phrase;
        }
    }

    // Write your line count function here
    public static long meaningfulLineCount(String filename) throws IOException {
        try (BufferedReader reader = new BufferedReader(new FileReader(filename))) {
            return reader.lines()
                    .filter(line -> !line.trim().isEmpty() && !line.trim().startsWith("#"))
                    .count();
        }
    }
}

// Write your Quaternion record class here
record Quaternion(double a, double b, double c, double d) {
    
    public static final Quaternion ZERO = new Quaternion(0, 0, 0, 0);
    public static final Quaternion I = new Quaternion(0, 1, 0, 0);
    public static final Quaternion J = new Quaternion(0, 0, 1, 0);
    public static final Quaternion K = new Quaternion(0, 0, 0, 1);

    public Quaternion {
        if(Double.isNaN(a) || Double.isNaN(b) || Double.isNaN(c) || Double.isNaN(d)) {
            throw new IllegalArgumentException("Coefficients cannot be NaN");
        }
    }

    public Quaternion times(Quaternion other) {
        return new Quaternion(
            (this.a*other.a() - this.b*other.b() - this.c*other.c() - this.d*other.d()),
            (this.a*other.b() + this.b*other.a() + this.c*other.d() - this.d*other.c()),
            (this.a*other.c() - this.b*other.d() + this.c*other.a() + this.d*other.b()),
            (this.a*other.d() + this.b*other.c() - this.c*other.b() + this.d*other.a())
        );
    }

    public Quaternion plus(Quaternion other) {
        return new Quaternion(
            a + other.a(),
            b + other.b(),
            c + other.c(),
            d + other.d()
        );
    }


    public List<Double> coefficients() {
        return List.copyOf(List.of(this.a, this.b, this.c, this.d));
    }

    public Quaternion conjugate() {
        return new Quaternion(
            a, -1*b, -1*c, -1*d
        );
    }

    public String toString() {
        String ret = "";
        if (a==0 && b==0 && c==0 && d==0) {
            return "0";
        } 

        if (a != 0) {
            ret += Double.toString(a);
        }

        if (b != 0) {
            if(ret.equals("")) {
                if(b == 1) {
                    ret += "i";
                } else if (b == -1) {
                    ret += "-i";
                } else {
                    ret += Double.toString(b) + "i";
                }
            } else {
                if (b > 0) {
                    ret += "+";
                }

                if(Math.abs(b) != 1) {
                    ret += Double.toString(b) + "i";
                } else {
                    ret += "i";
                }
            }
        }

        if (c != 0) {
            if(ret.equals("")) {
                if(c == 1) {
                    ret += "j";
                } else if (c == -1) {
                    ret += "-j";
                } else {
                    ret += Double.toString(c) + "j";
                }
            } else {
                if (c > 0) {
                    ret += "+";
                }

                if(Math.abs(c) != 1) {
                    ret += Double.toString(c) + "j";
                } else {
                    ret += "j";
                }
            }
        }

        if (d != 0) {
            if(ret.equals("")) {
                if(d == 1) {
                    ret += "k";
                } else if (d == -1) {
                    ret += "-k";
                } else {
                    ret += Double.toString(d) + "k";
                }
            } else {
                if (d > 0) {
                    ret += "+";
                }

                if(Math.abs(d) != 1) {
                    ret += Double.toString(d) + "k";
                } else {
                    ret += "k";
                }
            }
        }
        return ret;
    }
}
// Write your BinarySearchTree sealed interface and its implementations here
abstract sealed class BinarySearchTree permits Empty, Node {

    abstract int size();
    abstract boolean contains(String value);
    abstract BinarySearchTree insert(String value);

    @Override
    public abstract String toString();
}

final class Empty extends BinarySearchTree {

    public static final Empty INSTANCE = new Empty();

    // Private constructor to ensure a singleton pattern
    public Empty() {}

    @Override
    int size() {
        return 0;
    }

    @Override
    boolean contains(String value) {
        return false;
    }

    @Override
    BinarySearchTree insert(String value) {
        return new Node(value, INSTANCE, INSTANCE); // Return a new Node with Empty children
    }

    @Override
    public String toString() {
        return "()"; // Empty node represented as ()
    }
}

final class Node extends BinarySearchTree {

    private final String value;
    private final BinarySearchTree left;
    private final BinarySearchTree right;

    public Node(String value, BinarySearchTree left, BinarySearchTree right) {
        this.value = value;
        this.left = left;
        this.right = right;
    }

    @Override
    int size() {
        // Compute the size by adding 1 for the current node plus the sizes of the left and right children
        return 1 + left.size() + right.size();
    }

    @Override
    boolean contains(String value) {
        if (this.value.equals(value)) {
            return true;
        }
        if (value.compareTo(this.value) < 0) {
            return left.contains(value); // Search the left subtree
        }
        return right.contains(value); // Search the right subtree
    }

    @Override
    BinarySearchTree insert(String value) {
        if (this.value.equals(value)) {
            return this; // If the value is already present, return this node (no duplicates)
        }
        if (value.compareTo(this.value) < 0) {
            // If value is smaller, insert it in the left subtree
            return new Node(this.value, left.insert(value), right);
        }
        // Otherwise, insert it in the right subtree
        return new Node(this.value, left, right.insert(value));
    }

    @Override
    public String toString() {
        // In-order traversal and clean up redundant empty nodes
        return String.format("(%s%s%s)", left, value, right).replace("()", "");
    }
}
