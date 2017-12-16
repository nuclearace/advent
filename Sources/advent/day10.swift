import Foundation

// http://adventofcode.com/2017/day/10

private let suffix = [17, 31, 73, 47, 23]

func knotHash(_ input: String) -> String {
    let inputArray = input.map({ Int($0.unicodeScalars.first!.value) }) + suffix
    let hashArray = twist(inputArray)

    return hashArray.chunks(16).map({ $0.reduce(0, ^) }).map({ pad(String($0, radix: 16), to: 2) }).reduce("", +)
}

func twist(_ input: [Int], rounds: Int = 64) -> [Int] {
    var knot = Array(0...255)
    var curPos = 0
    var skipSize = 0

    for _ in 0..<rounds {
        for reverseLength in input {
            guard reverseLength < knot.count else { continue }

            knot.shift(amount: curPos)
            knot.replaceSubrange(0..<reverseLength, with: Array(knot[0..<reverseLength].reversed()))
            knot.shift(amount: -curPos)

            curPos += reverseLength + skipSize

            if curPos >= knot.count {
                curPos %= knot.count
            }

            skipSize += 1
        }
    }

    return knot
}
