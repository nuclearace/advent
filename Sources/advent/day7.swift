import Foundation

// http://adventofcode.com/2017/day/7

func findRootProgram(_ input: String, partTwo: Bool = false) -> String {
    let nodes = input.components(separatedBy: "\n")
    let tree = createTree(nodes)

    if partTwo {
        let (badNode, targetWeight) = Node.findImbalance(root: tree)

        print("Bad Node: \(badNode); Target Weight: \(badNode.weight - (badNode.sum() - targetWeight))")
    }

    return tree.name
}

private func createTree(_ rows: [String]) -> Node {
    var nodes = [String: Node]()
    var nodesLookingForParents = [String: Node]()
    var nodesWaitingForChildren = [String: Node]()

    for row in rows {
        let sep = row.components(separatedBy: " ")
        let name = sep[0]
        let weightString = sep[1]
        let weight = Int(weightString[weightString.index(after: weightString.startIndex)..<weightString.index(before: weightString.endIndex)])!
        let node = Node(name: String(name), weight: weight)

        if row.contains("->") {
            let children = row.components(separatedBy: " -> ")[1].replacingOccurrences(of: ",", with: "").components(separatedBy: " ")

            for child in children {
                // Has the children already been made?
                if let childNode = nodes[child] {
                    node.children.append(childNode)
                    childNode.parent = node
                    nodesLookingForParents.removeValue(forKey: child)
                } else {
                    nodesWaitingForChildren[child] = node
                }
            }
        }

        // Is there a node waiting to connect to this node?
        if let parentNode = nodesWaitingForChildren[name] {
            node.parent = parentNode
            parentNode.children.append(node)
        } else {
            nodesLookingForParents[name] = node
        }

        nodes[name] = node
    }

    return nodesLookingForParents.first!.1
}

private class Node : CustomStringConvertible, Hashable {
    private typealias NodeCount = (node: Node, count: Int)
    private typealias NodeCounter = [Int: NodeCount]

    let name: String
    let weight: Int

    weak var parent: Node?
    var children = [Node]()
    var description: String {
        return "\(name) \(String(describing: weight))"
    }

    var hashValue: Int {
        return name.hashValue
    }

    init(name: String, weight: Int) {
        self.name = name
        self.weight = weight
    }

    static func findImbalance(root: Node, targetWeight: Int = -1) -> (Node, Int) {
        guard !root.children.isEmpty else {
            return (root, targetWeight)
        }

        let nodeCounts = root.children.map({ ($0, $0.sum()) })
                                      .reduce(into: NodeCounter(), {(minMap: inout NodeCounter, nodeCount: NodeCount) in
                                          minMap[nodeCount.1, default: (nodeCount.0, 0)].count += 1
                                      })
        let min = nodeCounts.first(where: { $1.count == 1 })?.value.node

        if min == nil {
            return (root, targetWeight)
        }

        return findImbalance(root: min!, targetWeight: nodeCounts.first(where: { $0.key != min!.sum() })!.key)
    }

    func reduce(initial: Int, f: (Int, Int) -> Int) -> Int {
        guard !children.isEmpty else {
            return f(initial, weight)
        }

        return children.map({ $0.reduce(initial: initial, f: f) }).reduce(initial, f) + weight
    }

    func sum() -> Int {
        return reduce(initial: 0, f: +)
    }

    static func ==(lhs: Node, rhs: Node) -> Bool {
        return lhs.name == rhs.name
    }
}
