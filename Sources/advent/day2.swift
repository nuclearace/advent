import Foundation

// http://adventofcode.com/2017/day/2

func checksum(_ input: String, partTwo: Bool = false) -> Int {
    return input.components(separatedBy: "\n")
                .map({ $0.components(separatedBy: "\t").flatMap(Int.init) })
                .map(partTwo ? calculateEvenlyDividers : calculateRowDifference)
                .reduce(0, +)
}

private func calculateRowDifference(_ row: [Int]) -> Int {
    guard !row.isEmpty else { return 0 }

    return row.max()! - row.min()!
}

private func calculateEvenlyDividers(_ row: [Int]) -> Int {
    for n in row {
        for y in row where n % y == 0 && n != y {
            return n / y
        }
    }

    return 0
}

