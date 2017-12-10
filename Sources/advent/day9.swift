import Foundation

// http://adventofcode.com/2017/day/9

func calculateScore(_ input: String) -> Int {
    return Parser(input: input).getScore()
}

private class Parser {
    private let input: String

    private var cancel = false
    private var groupDepth = 0
    private var inGarbage = false

    init(input: String) {
        self.input = input
    }

    func getScore() -> Int {
        var sum = 0

        for char in input {
            if cancel {
                cancel = false
                continue
            } else if inGarbage && ![">", "!"].contains(String(char)) {
                continue
            }

            switch char {
            case "{":
                groupDepth += 1
            case "}":
                sum += groupDepth
                groupDepth -= 1
            case "<":
                inGarbage = true
            case ">":
                inGarbage = false
            case "!":
                cancel = true
            case ",":
                continue
            default:
                fatalError()
            }
        }

        return sum
    }
}
