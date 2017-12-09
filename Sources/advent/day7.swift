import Foundation

// http://adventofcode.com/2017/day/7

func findRootProgram(_ input: String) -> String {
    let nodes = input.components(separatedBy: "\n")
    let tree = createTree(nodes)

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
    let name: String
    let weight: Int

    weak var parent: Node?
    var children = [Node]()
    var description: String {
        return name
    }

    var hashValue: Int {
        return name.hashValue
    }

    init(name: String, weight: Int) {
        self.name = name
        self.weight = weight
    }

    static func ==(lhs: Node, rhs: Node) -> Bool {
        return lhs.name == rhs.name
    }
}
