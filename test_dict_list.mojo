from std.collections import Dict, List

def main() raises:
    var d = Dict[Int, List[Int]]()
    var l = List[Int]()
    l.append(42)
    d[1] = l^

    # Can we mutate or reassign?
    var retrieved = d[1].copy()
    retrieved.append(99)
    d[1] = retrieved^

    print("Length of d[1]:", len(d[1]))
    for i in range(len(d[1])):
        print(d[1][i])
