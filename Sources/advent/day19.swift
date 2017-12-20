import Foundation

// http://adventofcode.com/2017/day/19

func findPath(_ input: [[String]], partTwo: Bool = false) -> String {
    var direction = Direction.down
    var curRow = 1
    var curColumn = input[0].index(of: direction.pathChar)!
    var letters = ""
    var steps = 1

    func incrementIndexes() {
        steps += 1

        switch direction {
        case .down:
            curRow += 1
        case .up:
            curRow -= 1
        case .left:
            curColumn -= 1
        case .right:
            curColumn += 1
        }
    }

    while true {
        let curChar = input[curRow][curColumn]

        guard curChar != " " else { break }

        if curChar == "+" {
            switch direction {
            case .up where !["|", " "].contains(input[curRow][curColumn+1]),
                 .down where !["|", " "].contains(input[curRow][curColumn+1]):
                // Go right
                direction = .right
            case .up where !["|", " "].contains(input[curRow][curColumn-1]),
                 .down where !["|", " "].contains(input[curRow][curColumn-1]):
                // Go left
                direction = .left
            case .left where !["-", " "].contains(input[curRow+1][curColumn]),
                 .right where !["-", " "].contains(input[curRow+1][curColumn]):
                // Go down
                direction = .down
            case .left where !["-", " "].contains(input[curRow-1][curColumn]),
                 .right where !["-", " "].contains(input[curRow-1][curColumn]):
                // Go up
                direction = .up
            default:
                fatalError()
            }
        } else if !["|", "-", " "].contains(curChar) {
            letters += curChar
        }

        incrementIndexes()
    }

    if partTwo {
        print("Took \(steps)")
    }

    return letters
}

private enum Direction {
    case up, down, left, right

    var pathChar: String {
        switch self {
        case .up, .down:
            return "|"
        case .left, .right:
            return "-"
        }
    }
}
