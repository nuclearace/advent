import Foundation

// http://adventofcode.com/2017/day/16

func getFinalPositions(_ danceMoves: [String], partTwo: Bool = false) -> String {
    let count = partTwo ? 1_000_000_000 : 1
    var programs = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p"]
    var seen = [String]()

    for i in 0..<count {
        let joined = programs.joined()

        if seen.contains(joined) {
            return seen[count % i]
        }

        seen.append(joined)

        for move in danceMoves {
            if move.hasPrefix("s") {
                programs.shift(amount: 16 - Int(move.dropFirst())!)
            } else if move.hasPrefix("x") {
                let swapPositions = move.dropFirst().components(separatedBy: "/")

                programs.swapAt(Int(swapPositions[0])!, Int(swapPositions[1])!)
            } else if move.hasPrefix("p") {
                let partnerPositions = move.dropFirst().components(separatedBy: "/")

                programs.swapAt(programs.index(of: partnerPositions[0])!, programs.index(of: partnerPositions[1])!)
            }
        }
    }

    return programs.reduce("", +)
}
