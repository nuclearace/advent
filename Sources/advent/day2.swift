import Foundation

func checksum(_ input: String) -> Int {
    return input.components(separatedBy: "\n")
                .map({ $0.components(separatedBy: "\t").flatMap(Int.init) })
                .map(calculateRowDifference)
                .reduce(0, +)
}

private func calculateRowDifference(_ row: [Int]) -> Int {
    guard !row.isEmpty else { return 0 }

    return row.max()! - row.min()!
}

