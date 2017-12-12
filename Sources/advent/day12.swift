import Foundation

// http://adventofcode.com/2017/day/12

func findRootGroupCount(_ input: [[String]], partTwo: Bool = false) -> Int {
    let network = createNetwork(input)
    var seen = Set<Int>()
    
    let connectedCount = countConnected(network: network, node: 0, seen: &seen)

    if partTwo {
        let groups = network.reduce(into: Set<Set<Int>>(), {groups, keyValue in
            var group = Set<Int>()
            groups.insert(connectGroup(network: network, node: keyValue.key, seen: &group))
        })

        print("Number of groups:", groups.count)
    }

    return connectedCount
}

private func createNetwork(_ input: [[String]]) -> [Int: Set<Int>] {
    var network = [Int: Set<Int>]()

    for line in input {
        let rootProgram = Int(line[0])!
        let childPrograms = Set(line[1].components(separatedBy: " ").map({ Int($0)! }))

        network[rootProgram] = childPrograms

        for child in childPrograms {
            network[child, default: []].insert(rootProgram)
        }
    }

    return network
}

private func countConnected(network: [Int: Set<Int>], node: Int, seen: inout Set<Int>) -> Int {
    guard !seen.contains(node) else { return 0 }

    seen.insert(node)

    return 1 + network[node]!.map({ countConnected(network: network, node: $0, seen: &seen) }).reduce(0, +)
}

private func connectGroup(network: [Int: Set<Int>], node: Int, seen: inout Set<Int>) -> Set<Int> {
    guard !seen.contains(node) else { return seen }

    seen.insert(node)

    network[node]!.forEach({child in
        _ = connectGroup(network: network, node: child, seen: &seen)
    })

    return seen
}
